local BaseWidget = require("BaseWidget")
---@class TCE.PropertyList:TCE.BaseWidget
local PropertyList = class("PropertyList", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    config = BaseWidget.newPropDef({ nil, "PropertyListConfig" }),
    elements = BaseWidget.newPropDef({ {}, "PropertyListElement", "list" }),
}

function PropertyList:__init()
    PropertyList.super.__init(self, DataDefine, PropertyDefines)
end

---@param config TCE.PropertyListConfig
function PropertyList:setConfig(config)
    self:_set("config", config)
end

---@return TCE.PropertyListConfig
function PropertyList:getConfig()
    return self["config"]
end

---@return TCE.PropertyListElement[]
function PropertyList:getElements()
    return self["elements"]
end

---@param widget TCE.PropertyListElement
function PropertyList:elementsAdd(widget)
    self:_propertyListAdd("elements", widget)
end

---@param index number
---@param widget TCE.PropertyListElement
function PropertyList:elementsInsert(index, widget)
    self:_propertyListInsert("elements", index, widget)
end

---@param widget TCE.PropertyListElement
function PropertyList:elementsRemove(widget)
    self:_propertyListRemove("elements", widget)
end

---@param index number
function PropertyList:elementsRemoveAt(index)
    self:_propertyListRemoveAt("elements", index)
end

function PropertyList:elementsClear()
    self:_propertyListClear("elements")
end

return PropertyList