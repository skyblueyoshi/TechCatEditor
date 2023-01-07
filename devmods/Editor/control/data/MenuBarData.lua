---@class TCE.MenuBarData:TCE.BaseData
local MenuBarData = class("MenuBarData", require("BaseData"))
local DataMembers = {
    elements = { {}, "ButtonData", "list" },
}

function MenuBarData:__init(cfg)
    self:initData(DataMembers, cfg)
end

---@param value table
function MenuBarData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.ButtonData[]
function MenuBarData:getElements()
    return self:_get("elements")
end

---@param element TCE.ButtonData
function MenuBarData:addToElements(element)
    self:_listAppend("elements", element)
end

function MenuBarData:clearElements()
    self:_listClear("elements")
end

return MenuBarData