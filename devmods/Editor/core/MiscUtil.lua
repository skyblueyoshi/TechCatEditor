---@class TCE.MiscUtil
local MiscUtil = class("MiscUtil")

function MiscUtil.strSplit(s, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(s, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function MiscUtil.concatLists(list, list2)
    for i = 1, #list2 do
        list[#list + 1] = list2[i]
    end
end

function MiscUtil.shiftElements(list, iBegin, dir, insertElement)
    local iEnd = #list
    if dir > 0 then
        for i = iEnd, iBegin, -1 do
            list[i + 1] = list[i]
        end
        list[iBegin] = insertElement
    else
        for i = iBegin + 1, iEnd do
            list[i - 1] = list[i]
        end
        list[iEnd] = nil
    end
end

function MiscUtil.findIndexFromList(list, element)
    for i, e in ipairs(list) do
        if e == element then
            return i
        end
    end
    return nil
end

function MiscUtil.removeFromList(list, element)
    local i = MiscUtil.findIndexFromList(list, element)
    if i ~= nil then
        table.remove(list, i)
    end
end

---获取表的元素数量
function MiscUtil.getTableElementCount(t)
    local cnt = 0
    for _ in pairs(t) do
        cnt = cnt + 1
    end
    return cnt
end

function MiscUtil.isSameKeys(t1, t2)
    local cnt1 = MiscUtil.getTableElementCount(t1)
    local cnt2 = MiscUtil.getTableElementCount(t2)
    if cnt1 ~= cnt2 then
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

---比较两个数据是否值完全相同
---@return boolean
function MiscUtil.isSameValue(obj1, obj2)
    local type1 = type(obj1)
    local type2 = type(obj2)
    -- 类型不同，值必定不同
    if type1 ~= type2 then
        return false
    end
    -- 基本类型比较
    if type1 ~= "table" then
        return obj1 == obj2
    end
    -- 比较列表

    -- 数组长度不一致
    if #obj1 ~= #obj2 then
        return false
    end
    local cnt1 = MiscUtil.getTableElementCount(obj1)
    local cnt2 = MiscUtil.getTableElementCount(obj2)
    -- 元素数量不一致
    if cnt1 ~= cnt2 then
        return false
    end
    -- 挨个比较元素
    for k, v in pairs(obj1) do
        local v2 = obj2[k]
        if v2 == nil then
            return false
        end
        if not MiscUtil.isSameValue(v, v2) then
            return false
        end
    end
    return true
end

return MiscUtil