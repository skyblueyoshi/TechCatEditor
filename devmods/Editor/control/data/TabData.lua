---@class TCE.TabData:TCE.BaseData
local TabData = class("TabData", require("BaseData"))
local DataMembers = {
    elements = { {}, "TabElementData", "list" },
}

function TabData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value table
function TabData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.TabElementData[]
function TabData:getElements()
    return self:_get("elements")
end

---@param element TCE.TabElementData
function TabData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function TabData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

function TabData:clearElements()
    self:_listClear("elements")
end

return TabData