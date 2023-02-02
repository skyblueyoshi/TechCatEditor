local BaseWidget = require("BaseWidget")
---@class TCE.TreeElement:TCE.BaseWidget
local TreeElement = class("TreeElement", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
    icon = BaseWidget.newPropDef({ "" }),
    canExpand = BaseWidget.newPropDef({ false }),
    elements = BaseWidget.newPropDef({ {}, "TreeElement", "list" }),
}

function TreeElement:__init()
    TreeElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function TreeElement:setText(text)
    self:_set("text", text)
end

---@return string
function TreeElement:getText()
    return self["text"]
end

---@param icon string
function TreeElement:setIcon(icon)
    self:_set("icon", icon)
end

---@return string
function TreeElement:getIcon()
    return self["icon"]
end

---@param canExpand boolean
function TreeElement:setCanExpand(canExpand)
    self:_set("canExpand", canExpand)
end

---@return boolean
function TreeElement:getCanExpand()
    return self["canExpand"]
end

---@return TCE.TreeElement[]
function TreeElement:getElements()
    return self["elements"]
end

---@param widget TCE.TreeElement
function TreeElement:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.TreeElement
function TreeElement:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.TreeElement
function TreeElement:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function TreeElement:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function TreeElement:elementsClear()
    self:_propertyListClear("elements")
end

return TreeElement