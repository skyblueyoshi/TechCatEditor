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

local function createElementByCfg(uiName, cfgObj)
    return require("UIData").create(uiName, cfgObj)
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

function BaseData:initData(DataMembers, cfg)
    self._onDataChangedListeners = {}
    self._listenerIndex = 0
    self._memberInfo = DataMembers

    for name, info in pairs(self._memberInfo) do
        self[name] = info[1]
    end
    self:load(cfg)
end

function BaseData:addListener(listener)
    self._listenerIndex = self._listenerIndex + 1
    self._onDataChangedListeners[self._listenerIndex] = listener
    return self._listenerIndex
end

function BaseData:removeListener(listenerIndex)
    self._onDataChangedListeners[listenerIndex] = nil
end

function BaseData:clear()
    local changedMemberNames = {}
    for name, info in pairs(self._memberInfo) do
        local changed = self:_set(name, info[1], false)
        if changed then
            table.insert(changedMemberNames, name)
        end
    end
    return self:checkChangedMemberNames(changedMemberNames)
end

function BaseData:save()
    local result = {}
    for memberName, info in pairs(self._memberInfo) do
        local uiName = getInfoUIName(info)
        local curObj = self[memberName]
        if uiName ~= nil then
            local isList, isDict = isInfoListOrDict(info)
            if isList then
                local tempList = {}
                for i, curObjElement in ipairs(curObj) do
                    tempList[i] = curObjElement:save()
                end
                result[memberName] = tempList
            elseif isDict then
                local tempDict = {}
                for k, curObjElement in pairs(curObj) do
                    tempDict[k] = curObjElement:save()
                end
                result[memberName] = tempDict
            elseif curObj ~= nil then
                result[memberName] = curObj:save()
            end
        else
            result[memberName] = curObj
        end
    end
    return result
end

function BaseData:load(cfg)
    local changedMemberNames = {}
    for memberName, _ in pairs(self._memberInfo) do
        local cfgObj = cfg[memberName]
        local changed = self:_set(memberName, cfgObj, false)
        if changed then
            table.insert(changedMemberNames, memberName)
        end
    end
    return self:checkChangedMemberNames(changedMemberNames)
end

function BaseData:checkChangedMemberNames(changedMemberNames)
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
                            tempList[i] = createElementByCfg(uiName, cfgObjElement)
                        end
                        self[memberName] = tempList
                    else
                        local tempDict = {}
                        for inKey, cfgObjElement in pairs(cfgObj) do
                            tempDict[inKey] = createElementByCfg(uiName, cfgObjElement)
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

function BaseData:get(memberName)
    return self:_get(memberName)
end

function BaseData:_get(memberName)
    return self[memberName]
end

function BaseData:_onDataChanged(changedNames)
    for _, listener in pairs(self._onDataChangedListeners) do
        if listener.onDataChanged then
            listener:onDataChanged(changedNames)
        end
    end
end

return BaseData