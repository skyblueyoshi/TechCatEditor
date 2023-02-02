local BaseWidget = require("BaseWidget")
---@class TCE.PropertyListConfig:TCE.BaseWidget
local PropertyListConfig = class("PropertyListConfig", BaseWidget)
local DataDefine = { notifyParent = true, }
local PropertyDefines = {
    elements = BaseWidget.newPropDef({ {}, "PropertyListConfigElement", "list" }),
}

function PropertyListConfig:__init()
    PropertyListConfig.super.__init(self, DataDefine, PropertyDefines)
end

---@return TCE.PropertyListConfigElement[]
function PropertyListConfig:getElements()
    return self["elements"]
end

---@param widget TCE.PropertyListConfigElement
function PropertyListConfig:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.PropertyListConfigElement
function PropertyListConfig:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.PropertyListConfigElement
function PropertyListConfig:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function PropertyListConfig:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function PropertyListConfig:elementsClear()
    self:_propertyListClear("elements")
end

return PropertyListConfig