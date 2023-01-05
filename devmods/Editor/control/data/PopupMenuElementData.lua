---@class TCE.PopupMenuElementData:TCE.BaseData
local PopupMenuElementData = class("PopupMenuElementData", require("BaseData"))

local DataMembers = {
    text = { "" },
    hotKeys = { "" },
    popupMenu = { nil, "PopupMenu" },
}

function PopupMenuElementData:__init(cfg)
    self:initData(DataMembers, cfg)
end

function PopupMenuElementData:setText(value)
    self:_set("text", value)
end

function PopupMenuElementData:getText()
    return self:_get("text")
end

function PopupMenuElementData:setHotkeys(value)
    self:_set("hotKeys", value)
end

function PopupMenuElementData:getHotkeys()
    return self:_get("hotKeys")
end

function PopupMenuElementData:setPopupMenu(value)
    self:_set("popupMenu", value)
end

function PopupMenuElementData:getPopupMenu()
    return self:_get("popupMenu")
end

return PopupMenuElementData