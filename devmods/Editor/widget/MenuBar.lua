local BaseWidget = require("BaseWidget")
---@class TCE.MenuBar:TCE.BaseWidget
local MenuBar = class("MenuBar", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    elements = BaseWidget.newPropDef({ {}, "Button", "list" }),
}

function MenuBar:__init()
    MenuBar.super.__init(self, DataDefine, PropertyDefines)
end

---@return TCE.Button[]
function MenuBar:getElements()
    return self["elements"]
end

---@param widget TCE.Button
function MenuBar:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.Button
function MenuBar:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.Button
function MenuBar:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function MenuBar:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function MenuBar:elementsClear()
    self:_propertyListClear("elements")
end

return MenuBar