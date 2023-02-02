local MiscUtil = require("core.MiscUtil")
local PropertyType = {
    BaseType = 0, WidgetPointer = 1, WidgetList = 2, WidgetDict = 3,
}

local function _createWidget(propertyDefine, data)
    local WidgetPoolImpl = require("widget.WidgetPoolImpl")
    return WidgetPoolImpl.load(propertyDefine.widgetTypeName, data)
end

---@class TCE.WidgetPropertyDefine
local WidgetPropertyDefine = class("WidgetPropertyDefine")

function WidgetPropertyDefine:__init(def, type, widgetTypeName)
    self.defaultValue = def
    self.type = type
    self.widgetTypeName = widgetTypeName
end

---@class TCE.BaseWidget
local BaseWidget = class("BaseWidget")

function BaseWidget:__init(dataDefine, propertyDefines)
    -- 控件本身描述、各个属性描述
    self._dataDefine = dataDefine
    self._propertyDefines = propertyDefines  ---@type TCE.WidgetPropertyDefine[]
    -- 所有监听中的视图
    self._views = {}  ---@type TCE.BaseView[]
    -- 父节点和位置信息：parent->{member_name->(true,key=nil)}
    self._parents = {}
    -- 控件已经被释放
    self._destroyed = false
    -- 引用计数，为0时按周期回收释放
    self._refCount = 0
    -- 是否正在检测通知变更
    self._isNotifyDetecting = false
    self._changedPropertyNames = {}
    self._pendingNotifyChildren = {}
    -- 挂接数据
    self._hookData = nil
    self:_initProperties()
end

---销毁控件，由控件池自动执行。
function BaseWidget:destroy()
    self:_onDestroy()
end

function BaseWidget:_onDestroy()
    --此时一定不存在父节点
    assert(not self._destroyed and self:canFree())
    self._destroyed = true

    --直接清除所有视图监听
    self._views = {}
    self:clearHookData()
    self._dataDefine = nil
    self._propertyDefines = nil
end

---初始化所有属性。
function BaseWidget:_initProperties()
    for propertyName, propertyDefine in pairs(self._propertyDefines) do
        if propertyDefine.type == PropertyType.BaseType then
            -- 基本数据
            self[propertyName] = propertyDefine.defaultValue
        elseif propertyDefine.type == PropertyType.WidgetPointer then
            -- 控件指针
            self[propertyName] = nil
        else
            -- 控件容器（数组/字典）
            self[propertyName] = {}
        end
    end
end

---从序列化数据中读取所有属性。
function BaseWidget:load(data)
    if self._isNotifyDetecting then
        self._pendingNotifyChildren = self:_load(data, 0, self._isNotifyDetecting)
    else
        self:_load(data, 0, false)
    end
end

---解析得到序列化数据。
---@return table
function BaseWidget:save(ignoreDefault)
    local data = {}
    for propertyName, propertyDefine in pairs(self._propertyDefines) do
        local prop = self[propertyName]
        if propertyDefine.type == PropertyType.BaseType then
            -- 基本类型
            if not ignoreDefault or not MiscUtil.isSameValue(prop, propertyDefine.defaultValue) then
                data[propertyName] = prop
            end
        elseif propertyDefine.type == PropertyType.WidgetPointer then
            if prop ~= nil then
                data[propertyName] = prop:save(ignoreDefault)
            elseif not ignoreDefault then
                -- 显式表明空指针
                data[propertyName] = "None"
            end
        elseif propertyDefine.type == PropertyType.WidgetList then
            if #prop > 0 then
                local arrData = {}
                for i, widget in ipairs(prop) do
                    arrData[i] = widget:save(ignoreDefault)
                end
                data[propertyName] = arrData
            end
        elseif propertyDefine.type == PropertyType.WidgetDict then
            if next(prop) ~= nil then
                local dictData = {}
                for key, widget in pairs(prop) do
                    dictData[key] = widget:save(ignoreDefault)
                end
                data[propertyName] = dictData
            end
        end
    end
    return data
end

function BaseWidget:_load(data, level, testNotifying)
    if level > 0 and testNotifying then
        self:beginNotifyDetect()
    end
    local pendingNotifyChildren = {}
    for propertyName, propertyDefine in pairs(self._propertyDefines) do
        local propertyData = data[propertyName]
        if propertyData == nil then
            -- 设置默认值
            self:_propertySetDefault(propertyName)
        else
            if propertyDefine.type == PropertyType.BaseType then
                -- 基本类型
                self:_set(propertyName, propertyData)
            elseif propertyDefine.type == PropertyType.WidgetPointer then
                -- 因为没法遍历得到nil，必须显式"None"表明空指针
                if type(propertyData) == "string" and propertyData == "None" then
                    self:_set(propertyName, nil)
                else
                    local propOld = self[propertyData]  ---@type TCE.BaseWidget
                    if propOld == nil then
                        -- 之前是空指针，直接创建一个控件
                        self:_set(propertyName, _createWidget(propertyDefine, propertyData))
                    else
                        -- 成员检测
                        local notifyWidgets = propOld:_load(propertyData, level + 1, testNotifying)
                        MiscUtil.concatLists(pendingNotifyChildren, notifyWidgets)
                    end
                end
            elseif propertyDefine.type == PropertyType.WidgetList then
                -- 控件数组
                local curList = self[propertyName]
                if #curList ~= #propertyData then
                    -- 数量变化，相当于整个数组重建
                    self:_propertyListClear(propertyName)
                    for i = 1, #propertyData do
                        self:_propertyTableSet(propertyName, _createWidget(propertyDefine, propertyData[i]), i)
                    end
                else
                    -- 挨个比较变化
                    for i = 1, #curList do
                        local notifyWidgets = curList[i]:_load(propertyData, level + 1, testNotifying)
                        MiscUtil.concatLists(pendingNotifyChildren, notifyWidgets)
                    end
                end
            elseif propertyDefine.type == PropertyType.WidgetDict then
                -- 控件字典
                local curDict = self[propertyName]
                if not MiscUtil.isSameKeys(curDict, propertyData) then
                    -- 键值变化，相当于整个字典重建
                    self:_propertyDictClear(propertyName)
                    for key, propertyDataElement in pairs(propertyData) do
                        self:_propertyTableSet(propertyName, _createWidget(propertyDefine, propertyDataElement), key)
                    end
                else
                    -- 键值完全相同，挨个比较变化
                    for key, propertyDataElement in pairs(propertyData) do
                        local notifyWidgets = curDict[key]:_load(propertyData, level + 1, testNotifying)
                        MiscUtil.concatLists(pendingNotifyChildren, notifyWidgets)
                    end
                end
            end
        end
    end
    if level > 0 and testNotifying then
        if #self:endNotifyDetect(false) ~= 0 then
            table.insert(pendingNotifyChildren, self)
        end
    end
    return pendingNotifyChildren
end

---在监听变化周期的话，就记录这个变化的属性名。
function BaseWidget:_tryAddNotify(propertyName)
    if self._isNotifyDetecting then
        self._changedPropertyNames[propertyName] = true
    end
end

---开始监听变化。
function BaseWidget:beginNotifyDetect()
    assert(not self._isNotifyDetecting)
    assert(next(self._changedPropertyNames) == nil)
    self._isNotifyDetecting = true
end

---结束监听变化，把变化推送出去。
function BaseWidget:endNotifyDetect(notifying)
    if notifying == nil then
        notifying = true
    end
    assert(self._isNotifyDetecting)
    self._isNotifyDetecting = false
    if notifying then
        self:_notifyChanges()
        return nil
    else
        return self._changedPropertyNames
    end
end

---是否为根容器。
function BaseWidget:isRootWidget()
    return next(self._parents) == nil
end

---添加一个监听视图。
function BaseWidget:addView(view)
    table.insert(self._views, view)
end

---移除一个监听视图。
function BaseWidget:removeView(view)
    MiscUtil.removeFromList(self._views, view)
end

---设置父控件、属性名称、属性键值。
function BaseWidget:_addParent(parentWidget, propertyName, key)
    local parentInfo = self._parents[parentWidget]
    if parentInfo == nil then
        self._parents[parentWidget] = { [propertyName] = { true, key } }
    else
        assert(parentInfo[propertyName] == nil)
        parentInfo[propertyName] = { true, key }
    end
    self:retainRef()
end

---移除一个父控件信息。
function BaseWidget:_removeParent(parentWidget, propertyName)
    local parentInfo = self._parents[parentWidget]
    assert(parentInfo ~= nil)
    assert(parentInfo[propertyName] ~= nil)
    parentInfo[propertyName] = nil
    if next(parentInfo) == nil then
        self._parents[parentWidget] = nil
    end
    self:releaseRef()
end

---增加引用。
function BaseWidget:retainRef()
    self._refCount = self._refCount + 1
end

---减少引用。
function BaseWidget:releaseRef()
    assert(self._refCount > 0)
    self._refCount = self._refCount - 1
end

---释放可以被释放。
function BaseWidget:canFree()
    return self._refCount == 0
end

---整体移动父节点key值。
function BaseWidget:_moveParentKey(parent, propertyName, keyOffset)
    local parentInfo = self._parents[parent]
    local member = parentInfo[propertyName]
    member[2] = member[2] + keyOffset
end

---将当前控件设置为默认值。
function BaseWidget:setDefault()
    for propertyName, _ in pairs(self._propertyDefines) do
        self:_propertySetDefault(propertyName)
    end
end

---属性：设置为默认值。
function BaseWidget:_propertySetDefault(propertyName)
    local propertyDefine = self._propertyDefines[propertyName]
    if propertyDefine.type == PropertyType.BaseType then
        self:_set(propertyName, propertyDefine.defaultValue)
    elseif propertyDefine.type == PropertyType.WidgetPointer then
        self:_set(propertyName, nil)
    else
        self:_propertyClearTable(propertyName)
    end
end

---属性：清空一个数据数组/字典。
function BaseWidget:_propertyClearTable(propertyName)
    local last = self[propertyName]
    if next(last) == nil then
        return
    end
    for k, v in pairs(last) do
        v:_removeParent(self, propertyName, k)
    end
    self[propertyName] = {}
    self:_tryAddNotify(propertyName)
end

---属性：清空一个指针。
function BaseWidget:_propertyClearPtr(propertyName)
    local last = self[propertyName]
    if last == nil then
        return
    end
    last:_removeParent(self, propertyName)
    self[propertyName] = nil
    self:_tryAddNotify(propertyName)
end

---属性：设置列表/字典的键值。
function BaseWidget:_propertyTableSet(propertyName, value, key)
    local prop = self[propertyName]
    local propOld = prop[key]
    if value ~= nil then
        --新增/替换值。
        if propOld ~= nil then
            if propOld == value then
                return
            end
            propOld:_removeParent(self, propertyName, key)
        end
        prop[key] = value
        value:_addParent(self, propertyName, key)
    else
        --移除值。
        if propOld == nil then
            return
        end
        propOld:_removeParent(self, propertyName, key)
        prop[key] = nil
    end
    self:_tryAddNotify(propertyName)
end

function BaseWidget:_propertyListAdd(propertyName, value)
    self:_propertyTableSet(propertyName, value, #self[propertyName] + 1)
end

function BaseWidget:_propertyListRemove(propertyName, value)
    local index = MiscUtil.findIndexFromList(self[propertyName], value)
    if index == nil then
        return
    end
    self:_propertyListRemoveAt(propertyName, index)
end

function BaseWidget:_propertyListRemoveAt(propertyName, index)
    local prop = self[propertyName]
    local elementRemoved = prop[index]
    elementRemoved:_removeParent(self, propertyName, index)
    MiscUtil.shiftElements(prop, index, -1)
    self:_moveElementParentIndices(propertyName, index, #prop, -1)
    self:_tryAddNotify(propertyName)
end

function BaseWidget:_propertyListInsert(propertyName, index, value)
    local prop = self[propertyName]
    MiscUtil.shiftElements(prop, index, 1, value)
    value:_addParent(self, propertyName, index)
    self:_moveElementParentIndices(propertyName, index + 1, #prop, 1)
    self:_tryAddNotify(propertyName)
end

function BaseWidget:_propertyListClear(propertyName)
    self:_propertyClearTable(propertyName)
end

function BaseWidget:_propertyDictAdd(propertyName, key, value)
    self:_propertyTableSet(propertyName, value, key)
end

function BaseWidget:_propertyDictRemove(propertyName, key)
    self:_propertyTableSet(propertyName, nil, key)
end

function BaseWidget:_propertyDictClear(propertyName)
    self:_propertyClearTable(propertyName)
end

function BaseWidget:_moveElementParentIndices(propertyName, iStart, iEnd, offset)
    local array = self[propertyName]
    for i = iStart, iEnd do
        array[i]:_moveParentKey(self, propertyName, offset)
    end
end

---设置基本类型数据、控件指针。
function BaseWidget:_innerSet(propertyName, value)
    local propertyDefine = self._propertyDefines[propertyName]
    local propOld = self[propertyName]
    if propertyDefine.type == PropertyType.BaseType then
        -- 基本类型，直接比较
        if MiscUtil.isSameValue(propOld, value) then
            return false
        end
        -- 数据变化
        self[propertyName] = value
    else
        -- 只能是控件指针
        assert(propertyDefine.type == PropertyType.WidgetPointer)
        if propOld == value then
            return false
        end
        -- 控件指针变化
        if propOld ~= nil then
            propOld:_removeParent(self, propertyName)
        end
        self[propertyName] = value
        if value ~= nil then
            value:_addParent(self, propertyName)
        end
    end
    return true
end

---设置属性，如果发生变化会记录推送信息。
function BaseWidget:_set(propertyName, value)
    if self:_innerSet(propertyName, value) then
        self:_tryAddNotify(propertyName)
    end
end

---对所有监听中的控件推送变化的属性，推送完毕后会重置变化状态。
function BaseWidget:_notifyChanges()
    -- 先推送所有变化的子控件。
    if #self._pendingNotifyChildren > 0 then
        for _, widget in ipairs(self._pendingNotifyChildren) do
            widget:_notifyChanges()
        end
        self._pendingNotifyChildren = {}
    end

    -- 推送读取控件变化情况。
    if next(self._changedPropertyNames) ~= nil then
        for _, view in ipairs(self._views) do
            view:onNotifyChanges(self, self._changedPropertyNames)
        end
        self._changedPropertyNames = {}
    end
end

function BaseWidget:setHookData(hookData)
    self._hookData = hookData
end

function BaseWidget:getHookData()
    return self._hookData
end

function BaseWidget:clearHookData()
    self._hookData = nil
end

function BaseWidget.newPropDef(info)
    local def = info[1]
    local propType = PropertyType.BaseType
    local widgetTypeName = ""
    if info[2] ~= nil then
        widgetTypeName = info[2]
    end
    if widgetTypeName ~= "" then
        if info[3] ~= nil then
            if info[3] == "dict" then
                propType = PropertyType.WidgetDict
            else
                propType = PropertyType.WidgetList
            end
        else
            propType = PropertyType.WidgetPointer
        end
    end
    return WidgetPropertyDefine.new(def, propType, widgetTypeName)
end

return BaseWidget