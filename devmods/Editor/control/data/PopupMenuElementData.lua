---@class TCE.PopupMenuElementData:TCE.BaseData
local PopupMenuElementData = class("PopupMenuElementData", require("BaseData"))
local DataMembers = {
    text = { "" },
    hotKeys = { "" },
    popupMenu = { nil, "PopupMenuData" },
}

function PopupMenuElementData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value string
function PopupMenuElementData:setText(value)
    self:_set("text", value)
end

---@return string
function PopupMenuElementData:getText()
    return self:_get("text")
end

---@param value string
function PopupMenuElementData:setHotKeys(value)
    self:_set("hotKeys", value)
end

---@return string
function PopupMenuElementData:getHotKeys()
    return self:_get("hotKeys")
end

---@param value TCE.PopupMenuData
function PopupMenuElementData:setPopupMenu(value)
    self:_set("popupMenu", value)
end

---@return TCE.PopupMenuData
function PopupMenuElementData:getPopupMenu()
    return self:_get("popupMenu")
end

return PopupMenuElementData