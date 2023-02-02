local BaseWidget = require("BaseWidget")
---@class TCE.PopupMenuElement:TCE.BaseWidget
local PopupMenuElement = class("PopupMenuElement", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
    icon = BaseWidget.newPropDef({ "" }),
    hotKeys = BaseWidget.newPropDef({ "" }),
    popupMenu = BaseWidget.newPropDef({ nil, "PopupMenu" }),
}

function PopupMenuElement:__init()
    PopupMenuElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function PopupMenuElement:setText(text)
    self:_set("text", text)
end

---@return string
function PopupMenuElement:getText()
    return self["text"]
end

---@param icon string
function PopupMenuElement:setIcon(icon)
    self:_set("icon", icon)
end

---@return string
function PopupMenuElement:getIcon()
    return self["icon"]
end

---@param hotKeys string
function PopupMenuElement:setHotKeys(hotKeys)
    self:_set("hotKeys", hotKeys)
end

---@return string
function PopupMenuElement:getHotKeys()
    return self["hotKeys"]
end

---@param popupMenu TCE.PopupMenu
function PopupMenuElement:setPopupMenu(popupMenu)
    self:_set("popupMenu", popupMenu)
end

---@return TCE.PopupMenu
function PopupMenuElement:getPopupMenu()
    return self["popupMenu"]
end

return PopupMenuElement