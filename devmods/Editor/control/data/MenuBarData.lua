---@class TCE.MenuBarData:TCE.BaseData
local MenuBarData = class("MenuBarData", require("BaseData"))

local DataMembers = {
    elements = { {}, "Button", "list" },
}

function MenuBarData:__init(cfg)
    self:initData(DataMembers, cfg)
end

function MenuBarData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.ButtonData[]
function MenuBarData:getElements()
    return self:_get("elements")
end

return MenuBarData