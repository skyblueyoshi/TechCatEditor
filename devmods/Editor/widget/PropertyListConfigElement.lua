local BaseWidget = require("BaseWidget")
---@class TCE.PropertyListConfigElement:TCE.BaseWidget
local PropertyListConfigElement = class("PropertyListConfigElement", BaseWidget)
local DataDefine = { notifyParent = true, }
local PropertyDefines = {
    propertyType = BaseWidget.newPropDef({ "" }),
    params = BaseWidget.newPropDef({ {} }),
    popupMenu = BaseWidget.newPropDef({ nil, "PopupMenu" }),
}

function PropertyListConfigElement:__init()
    PropertyListConfigElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param propertyType string
function PropertyListConfigElement:setPropertyType(propertyType)
    self:_set("propertyType", propertyType)
end

---@return string
function PropertyListConfigElement:getPropertyType()
    return self["propertyType"]
end

---@param params table
function PropertyListConfigElement:setParams(params)
    self:_set("params", params)
end

---@return table
function PropertyListConfigElement:getParams()
    return self["params"]
end

---@param popupMenu TCE.PopupMenu
function PropertyListConfigElement:setPopupMenu(popupMenu)
    self:_set("popupMenu", popupMenu)
end

---@return TCE.PopupMenu
function PropertyListConfigElement:getPopupMenu()
    return self["popupMenu"]
end

return PropertyListConfigElement