---@class TCE.PopupMenuData:TCE.BaseData
local PopupMenuData = class("PopupMenuData", require("BaseData"))

local DataMembers = {
    elements = { {}, "PopupMenuElement", "list" },
}

function PopupMenuData:__init(cfg)
    self:initData(DataMembers, cfg)
end

function PopupMenuData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.PopupMenuElementData[]
function PopupMenuData:getElements()
    return self:_get("elements")
end

return PopupMenuData