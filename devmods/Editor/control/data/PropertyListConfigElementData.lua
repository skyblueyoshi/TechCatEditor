---@class TCE.PropertyListConfigElementData:TCE.BaseData
local PropertyListConfigElementData = class("PropertyListConfigElementData", require("BaseData"))
local DataMembers = {
    propertyType = { "" },
    params = { {} },
}

function PropertyListConfigElementData:__init(cfg)
    self:initData(DataMembers, cfg, true)
end

---@param value string
function PropertyListConfigElementData:setPropertyType(value)
    self:_set("propertyType", value)
end

---@return string
function PropertyListConfigElementData:getPropertyType()
    return self:_get("propertyType")
end

---@param value table
function PropertyListConfigElementData:setParams(value)
    self:_set("params", value)
end

---@return table
function PropertyListConfigElementData:getParams()
    return self:_get("params")
end

return PropertyListConfigElementData