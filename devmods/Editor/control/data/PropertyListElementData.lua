---@class TCE.PropertyListElementData:TCE.BaseData
local PropertyListElementData = class("PropertyListElementData", require("BaseData"))
local DataMembers = {
    text = { "" },
    configIndex = { 0 },
    value = { nil },
    params = { {} },
}

function PropertyListElementData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value string
function PropertyListElementData:setText(value)
    self:_set("text", value)
end

---@return string
function PropertyListElementData:getText()
    return self:_get("text")
end

---@param value number
function PropertyListElementData:setConfigIndex(value)
    self:_set("configIndex", value)
end

---@return number
function PropertyListElementData:getConfigIndex()
    return self:_get("configIndex")
end

---@param value any
function PropertyListElementData:setValue(value)
    self:_set("value", value)
end

---@return any
function PropertyListElementData:getValue()
    return self:_get("value")
end

---@param value table
function PropertyListElementData:setParams(value)
    self:_set("params", value)
end

---@return table
function PropertyListElementData:getParams()
    return self:_get("params")
end

return PropertyListElementData