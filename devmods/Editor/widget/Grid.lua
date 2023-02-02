local BaseWidget = require("BaseWidget")
---@class TCE.Grid:TCE.BaseWidget
local Grid = class("Grid", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    elements = BaseWidget.newPropDef({ {}, "GridElement", "list" }),
}

function Grid:__init()
    Grid.super.__init(self, DataDefine, PropertyDefines)
end

---@return TCE.GridElement[]
function Grid:getElements()
    return self["elements"]
end

---@param widget TCE.GridElement
function Grid:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.GridElement
function Grid:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.GridElement
function Grid:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function Grid:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function Grid:elementsClear()
    self:_propertyListClear("elements")
end

return Grid