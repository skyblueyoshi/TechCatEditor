---@class TCE.PropertyListData:TCE.BaseData
local PropertyListData = class("PropertyListData", require("BaseData"))
local DataMembers = {
    config = { nil, "PropertyListConfigData" },
    elements = { {}, "PropertyListElementData", "list" },
}

function PropertyListData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value TCE.PropertyListConfigData
function PropertyListData:setConfig(value)
    self:_set("config", value)
end

---@return TCE.PropertyListConfigData
function PropertyListData:getConfig()
    return self:_get("config")
end

---@param value table
function PropertyListData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.PropertyListElementData[]
function PropertyListData:getElements()
    return self:_get("elements")
end

---@param element TCE.PropertyListElementData
function PropertyListData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function PropertyListData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

function PropertyListData:clearElements()
    self:_listClear("elements")
end

return PropertyListData