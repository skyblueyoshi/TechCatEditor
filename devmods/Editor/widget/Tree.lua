local BaseWidget = require("BaseWidget")
---@class TCE.Tree:TCE.BaseWidget
local Tree = class("Tree", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    iconList = BaseWidget.newPropDef({ {} }),
    elements = BaseWidget.newPropDef({ {}, "TreeElement", "list" }),
}

function Tree:__init()
    Tree.super.__init(self, DataDefine, PropertyDefines)
end

---@param iconList table
function Tree:setIconList(iconList)
    self:_set("iconList", iconList)
end

---@return table
function Tree:getIconList()
    return self["iconList"]
end

---@return TCE.TreeElement[]
function Tree:getElements()
    return self["elements"]
end

---@param widget TCE.TreeElement
function Tree:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.TreeElement
function Tree:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.TreeElement
function Tree:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function Tree:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function Tree:elementsClear()
    self:_propertyListClear("elements")
end

return Tree