---@class TCE.PropertyListView:TCE.ScrollContainerView
local PropertyListView = class("PropertyListView", require("ScrollContainerView"))
local UIUtil = require("core.UIUtil")
local PropertyTypes = require("PropertyTypes")

local PropertyTypeElements = {
    [PropertyTypes.Boolean] = require("PropertyListElementView_Boolean"),
    [PropertyTypes.ComboBox] = require("PropertyListElementView_ComboBox"),
    [PropertyTypes.Int] = require("PropertyListElementView_Int"),
    [PropertyTypes.Float] = require("PropertyListElementView_Float"),
}

local function createElement(propertyType, root, index, widget, parent)
    local ElementClass = PropertyTypeElements[propertyType]
    return ElementClass.new(root, index, widget, parent)
end

function PropertyListView:__init(key, widget, parent, parentRoot, location)
    PropertyListView.super.__init(self, key, widget, parent, parentRoot, {})
    self:_initContent(location)
end

---@return TCE.PropertyList
function PropertyListView:getWidget()
    return self._widget
end

function PropertyListView:_initContent(location)
    self:adjustLayout(true, location)
end

function PropertyListView:adjustLayout(isInitializing, location)
    self:_adjustLayoutBegin(isInitializing, location)
    self:_adjustLayoutEnd(isInitializing)
end

function PropertyListView:_onEnsurePanelItem()
    local panelItem = PropertyListView.super._onEnsurePanelItem(self)
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

function PropertyListView:_getTableElementCount()
    return #self:getWidget():getElements()
end

function PropertyListView:_onCreateElement(node, index)
    local widget = self:getWidget()
    local elementWidget = self:getWidget():getElements()[index]
    local configData = widget:getConfig():getElements()[elementWidget:getConfigIndex()]
    return createElement(configData:getPropertyType(), node, index, elementWidget, self)
end

function PropertyListView:onNotifyChanges(_, names)
    self:adjustLayout(false)
end

return PropertyListView