---@class TCE.ButtonData:TCE.BaseData
local ButtonData = class("ButtonData", require("BaseData"))

local DataMembers = {
    text = { "" },
    icon = { "" },
    popupMenu = { nil, "PopupMenu" },
}

function ButtonData:__init(cfg)
    self:initData(DataMembers, cfg)
    Input.keyboard:getHotKeys(Keys.B):addListener(function()
        self:setText(self:getText() .. "v")
    end)
end

function ButtonData:setText(value)
    self:_set("text", value)
end

---@return string
function ButtonData:getText()
    return self:_get("text")
end

function ButtonData:setIcon(value)
    self:_set("icon", value)
end

---@return string
function ButtonData:getIcon()
    return self:_get("icon")
end

function ButtonData:setPopupMenu(value)
    self:_set("popupMenu", value)
end

---@return TCE.PopupMenuData
function ButtonData:getPopupMenu()
    return self:_get("popupMenu")
end

return ButtonData