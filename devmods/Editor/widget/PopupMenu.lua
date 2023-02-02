local BaseWidget = require("BaseWidget")
---@class TCE.PopupMenu:TCE.BaseWidget
local PopupMenu = class("PopupMenu", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    elements = BaseWidget.newPropDef({ {}, "PopupMenuElement", "list" }),
}

function PopupMenu:__init()
    PopupMenu.super.__init(self, DataDefine, PropertyDefines)
end

---@return TCE.PopupMenuElement[]
function PopupMenu:getElements()
    return self["elements"]
end

---@param widget TCE.PopupMenuElement
function PopupMenu:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.PopupMenuElement
function PopupMenu:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.PopupMenuElement
function PopupMenu:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function PopupMenu:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function PopupMenu:elementsClear()
    self:_propertyListClear("elements")
end

return PopupMenu