local BaseWidget = require("BaseWidget")
---@class TCE.Button:TCE.BaseWidget
local Button = class("Button", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
    icon = BaseWidget.newPropDef({ "" }),
    clickCallback = BaseWidget.newPropDef({ "" }),
    popupMenu = BaseWidget.newPropDef({ nil, "PopupMenu" }),
}

function Button:__init()
    Button.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function Button:setText(text)
    self:_set("text", text)
end

---@return string
function Button:getText()
    return self["text"]
end

---@param icon string
function Button:setIcon(icon)
    self:_set("icon", icon)
end

---@return string
function Button:getIcon()
    return self["icon"]
end

---@param clickCallback string
function Button:setClickCallback(clickCallback)
    self:_set("clickCallback", clickCallback)
end

---@return string
function Button:getClickCallback()
    return self["clickCallback"]
end

---@param popupMenu TCE.PopupMenu
function Button:setPopupMenu(popupMenu)
    self:_set("popupMenu", popupMenu)
end

---@return TCE.PopupMenu
function Button:getPopupMenu()
    return self["popupMenu"]
end

return Button