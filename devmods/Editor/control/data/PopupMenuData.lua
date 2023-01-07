---@class TCE.PopupMenuData:TCE.BaseData
local PopupMenuData = class("PopupMenuData", require("BaseData"))
local DataMembers = {
    elements = { {}, "PopupMenuElementData", "list" },
}

function PopupMenuData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value table
function PopupMenuData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.PopupMenuElementData[]
function PopupMenuData:getElements()
    return self:_get("elements")
end

---@param element TCE.PopupMenuElementData
function PopupMenuData:addToElements(element)
    self:_listAppend("elements", element)
end

function PopupMenuData:clearElements()
    self:_listClear("elements")
end

return PopupMenuData