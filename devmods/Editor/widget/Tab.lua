local BaseWidget = require("BaseWidget")
---@class TCE.Tab:TCE.BaseWidget
local Tab = class("Tab", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    elements = BaseWidget.newPropDef({ {}, "TabElement", "list" }),
}

function Tab:__init()
    Tab.super.__init(self, DataDefine, PropertyDefines)
end

---@return TCE.TabElement[]
function Tab:getElements()
    return self["elements"]
end

---@param widget TCE.TabElement
function Tab:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.TabElement
function Tab:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.TabElement
function Tab:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function Tab:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function Tab:elementsClear()
    self:_propertyListClear("elements")
end

return Tab