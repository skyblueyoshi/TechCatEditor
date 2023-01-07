---@class TCE.PropertyListConfigData:TCE.BaseData
local PropertyListConfigData = class("PropertyListConfigData", require("BaseData"))
local DataMembers = {
    elements = { {}, "PropertyListConfigElementData", "list" },
}

function PropertyListConfigData:__init(cfg)
    self:initData(DataMembers, cfg, true)
end

---@param value table
function PropertyListConfigData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.PropertyListConfigElementData[]
function PropertyListConfigData:getElements()
    return self:_get("elements")
end

---@param element TCE.PropertyListConfigElementData
function PropertyListConfigData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function PropertyListConfigData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

function PropertyListConfigData:clearElements()
    self:_listClear("elements")
end

return PropertyListConfigData