---@class TCE.BaseData
local BaseData = class("BaseData")

local function isTableCountSame(t1, t2)
    -- 数组数量
    if #t1 ~= #t2 then
        return false
    end
    -- 字典条目数量
    local cnt1 = 0
    local cnt2 = 0
    for _ in pairs(t1) do
        cnt1 = cnt1 + 1
    end
    for _ in pairs(t2) do
        cnt2 = cnt2 + 1
    end
    return cnt1 == cnt2
end

local function isTableKeysSame(t1, t2)
    if not isTableCountSame(t1, t2) then
        return false
    end
    for k, _ in pairs(t1) do
        local v2 = t2[k]
        if v2 == nil then
            return false
        end
    end
    return true
end

---判断两个基础类型是否相同
---@param obj1 any
---@param obj2 any
---@return boolean
local function isBaseTypeEqualTo(obj1, obj2)
    local type1 = type(obj1)
    local type2 = type(obj2)

    if type1 ~= type2 then
        return false
    end

    if type1 == "table" then
        if not isTableCountSame(obj1, obj2) then
            return false
        end
        for k, v in pairs(obj1) do
            local v2 = obj2[k]
            if v2 == nil then
                return false
            end
            if not isBaseTypeEqualTo(v, v2) then
                return false
            end
        end
        return true
    end

    return obj1 == obj2
end

local function createElementByCfg(uiName, cfgObj, parent, parentMemberName)
    local element = require("UIData").create(uiName, cfgObj)
    if parent ~= nil then
        element:_setParent(parent, parentMemberName)
    end
    return element
end

local function isInfoListOrDict(info)
    local isList, isDict = false, false
    local t = info[3]
    if t ~= nil then
        isList = t == "list"
        isDict = t == "dict"
    end
    return isList, isDict
end

local function getInfoUIName(info)
    return info[2]
end

local function getDefaultValue(info)
    return info[1]
end

function BaseData:initData(DataMembers, cfg, needParentHooked)
    -- 父数据
    self._parent = nil
    self._parentMemberName = nil

    -- 数据格式记录
    self._memberInfo = DataMembers

    -- 数据监听
    self._onDataChangedListeners = {}
    self._maxListenerID = 0
    self._needParentHooked = needParentHooked

    for name, info in pairs(self._memberInfo) do
        self[name] = getDefaultValue(info)
    end
    self:load(cfg)
end

---设置当前数据的父亲数据。
---@param parent TCE.BaseData
---@param parentMemberName string
function BaseData:_setParent(parent, parentMemberName)
    self._parent = parent
    self._parentMemberName = parentMemberName
end

function BaseData:_removeParent()
    self._parent = nil
    self._parentMemberName = nil
end

function BaseData:isNeedParentHooked()
    return self._needParentHooked
end

---加入一个数据变化监听。
---@param listener any
---@return number
function BaseData:addListener(listener)
    self._maxListenerID = self._maxListenerID + 1
    self._onDataChangedListeners[self._maxListenerID] = listener
    return self._maxListenerID
end

---移除一个数据变化监听。
---@param listenerIndex number
function BaseData:removeListener(listenerIndex)
    self._onDataChangedListeners[listenerIndex] = nil
end

---将所有数据设置为默认数据。
---@return boolean 数据是否变化。
function BaseData:clear()
    local changedMemberNames = {}
    for name, info in pairs(self._memberInfo) do
        local changed = self:_set(name, getDefaultValue(info), false)
        if changed then
            table.insert(changedMemberNames, name)
        end
    end
    return self:_checkChangedMemberNames(changedMemberNames)
end

---将所有数据保存到纯数据表。
---@param ignoreDefaultValue boolean
---@return table
function BaseData:save(ignoreDefaultValue)
    if ignoreDefaultValue == nil then
        ignoreDefaultValue = false
    end
    local result = {}
    for memberName, info in pairs(self._memberInfo) do
        local uiName = getInfoUIName(info)
        local curObj = self[memberName]
        if uiName ~= nil then
            local isList, isDict = isInfoListOrDict(info)
            if isList then
                local tempList = {}
                local ok = false
                for i, curObjElement in ipairs(curObj) do
                    ok = true
                    tempList[i] = curObjElement:save(ignoreDefaultValue)
                end
                if ok then
                    result[memberName] = tempList
                end
            elseif isDict then
                local tempDict = {}
                local ok = false
                for k, curObjElement in pairs(curObj) do
                    ok = true
                    if ok then
                        tempDict[k] = curObjElement:save(ignoreDefaultValue)
                    end
                end
                result[memberName] = tempDict
            elseif curObj ~= nil then
                result[memberName] = curObj:save(ignoreDefaultValue)
            end
        else
            local ok = true
            if ignoreDefaultValue then
                ok = not isBaseTypeEqualTo(curObj, getDefaultValue(info))
            end
            if ok then
                result[memberName] = curObj
            end
        end
    end
    return result
end

---从表中载入数据。
---@param cfg table
---@return boolean 数据是否变化。
function BaseData:load(cfg)
    local changedMemberNames = {}
    for memberName, _ in pairs(self._memberInfo) do
        local cfgObj = cfg[memberName]
        local changed = self:_set(memberName, cfgObj, false)
        if changed then
            table.insert(changedMemberNames, memberName)
        end
    end
    return self:_checkChangedMemberNames(changedMemberNames)
end

---获取指定成员数据。
---@param memberName string
---@return any
function BaseData:get(memberName)
    return self:_get(memberName)
end

function BaseData:_checkChangedMemberNames(changedMemberNames)
    if #changedMemberNames > 0 then
        local nameDict = {}
        for _, name in ipairs(changedMemberNames) do
            nameDict[name] = true
        end
        self:_onDataChanged(nameDict)
        return true
    end
    return false
end

function BaseData:_listClear(memberName)
    local arr = self:_get(memberName)
    if #arr == 0 then
        return false
    end
    self:_set(memberName, {})
    return true
end

function BaseData:_listAppendCfg(memberName, value)
    local info = self._memberInfo[memberName]
    local uiName = getInfoUIName(info)
    local element = createElementByCfg(uiName, value)
    return self:_listAppend(memberName, element)
end

function BaseData:_listAppend(memberName, element)
    self:_listInsert(memberName, -1, element)
end

function BaseData:_listInsert(memberName, index, element)
    local arr = self:_get(memberName)
    if index == -1 then
        table.insert(arr, element)
    else
        table.insert(arr, index, element)
    end
    element:_setParent(self, memberName)
    self:_onDataChanged({ [memberName] = true })
    return true
end

function BaseData:_listRemove(memberName, index)
    local arr = self:_get(memberName)
    table.remove(arr, index)
    self:_onDataChanged({ [memberName] = true })
    return true
end

function BaseData:_set(memberName, cfgObj, runOnChangeEvent)
    if runOnChangeEvent == nil then
        runOnChangeEvent = true
    end
    local info = self._memberInfo[memberName]
    local uiName = getInfoUIName(info)
    local changed = false

    if cfgObj ~= nil then
        local curObj = self[memberName]
        if uiName ~= nil then
            local isList, isDict = isInfoListOrDict(info)
            if isList or isDict then
                if not isTableKeysSame(curObj, cfgObj) then
                    changed = true
                    if isList then
                        local tempList = {}
                        for i, cfgObjElement in ipairs(cfgObj) do
                            tempList[i] = createElementByCfg(uiName, cfgObjElement, self, memberName)
                        end
                        self[memberName] = tempList
                    else
                        local tempDict = {}
                        for inKey, cfgObjElement in pairs(cfgObj) do
                            tempDict[inKey] = createElementByCfg(uiName, cfgObjElement, self, memberName)
                        end
                        self[memberName] = tempDict
                    end
                else
                    for k, cfgObjElement in pairs(cfgObj) do
                        local curObjElement = curObj[k]
                        local ok = curObjElement:load(cfgObjElement)
                        if ok then
                            changed = true
                        end
                    end
                end
            else
                if curObj == nil then
                    changed = true
                    self[memberName] = createElementByCfg(uiName, cfgObj)
                else
                    changed = curObj:load(cfgObj)
                end
            end
        else
            if not isBaseTypeEqualTo(curObj, cfgObj) then
                changed = true
                self[memberName] = cfgObj
            end
        end
    else
        if uiName ~= nil then
            local isList, isDict = isInfoListOrDict(info)
            if isList or isDict then
                return self:_set(memberName, {}, runOnChangeEvent)
            end
            if self[memberName] ~= nil then
                changed = true
                self[memberName] = nil
            end
        end
    end

    if changed and runOnChangeEvent then
        self:_onDataChanged({ [memberName] = true })
    end
    return changed
end

function BaseData:_get(memberName)
    return self[memberName]
end

function BaseData:_onDataChanged(changedNames)
    if self._needParentHooked then
        if self._parent ~= nil then
            names = nil
            if not self._parent:isNeedParentHooked() then
                names = { [self._parentMemberName] = true }
            end
            self._parent:_onDataChanged(names)
        end
        return
    end
    for _, listener in pairs(self._onDataChangedListeners) do
        if listener.onDataChanged then
            listener:onDataChanged(changedNames)
        end
    end
end

return BaseData