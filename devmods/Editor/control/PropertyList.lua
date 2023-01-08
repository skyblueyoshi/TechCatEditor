---@class TCE.PropertyList:TCE.ScrollContainer
local PropertyList = class("PropertyList", require("ScrollContainer"))
local UIUtil = require("core.UIUtil")
local PropertyTypes = require("PropertyTypes")

local PropertyTypeElements = {
    [PropertyTypes.Boolean] = require("PropertyListElement_Boolean"),
    [PropertyTypes.ComboBox] = require("PropertyListElement_ComboBox"),
    [PropertyTypes.Int] = require("PropertyListElement_Int"),
    [PropertyTypes.Float] = require("PropertyListElement_Float"),
}

local function createElement(propertyType, root, parent, data, index)
    local ElementClass = PropertyTypeElements[propertyType]
    return ElementClass.new(root, parent, data, index)
end

function PropertyList:__init(name, parent, parentRoot, data, location)
    PropertyList.super.__init(self, name, parent, parentRoot, data, {})
    self:_initContent(location)
end

---@return TCE.PropertyListData
function PropertyList:getData()
    return self._data
end

function PropertyList:_initContent(location)
    self:adjustLayout(true, location)
end

function PropertyList:adjustLayout(isInitializing, location)
    self:_adjustLayoutBegin(isInitializing, location)
    self:_adjustLayoutEnd(isInitializing)
end

function PropertyList:_onEnsurePanelItem()
    local panelItem = PropertyList.super._onEnsurePanelItem(self)
    UIUtil.ensurePanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    local panelElement = UIUtil.ensurePanel(panelItem, "panel_element", nil, {
        layout = "FULL",
    }, false, false)

    for _, ElementClass in pairs(PropertyTypeElements) do
        ElementClass.ensureElementPanel(panelElement)
    end

    panelItem:applyMargin(true)
    return panelItem
end

function PropertyList:_getTableElementCount()
    return #self:getData():getElements()
end

function PropertyList:_onCreateElement(node, index)
    local data = self:getData()
    local elementData = self:getData():getElements()[index]
    local configData = data:getConfig():getElements()[elementData:getConfigIndex()]
    return createElement(configData:getPropertyType(), node, self, elementData, index)
end

function PropertyList:onDataChanged(names)
    self:adjustLayout(false)
end

return PropertyList