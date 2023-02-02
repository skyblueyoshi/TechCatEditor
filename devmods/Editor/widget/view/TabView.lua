---@class TCE.TabView:TCE.BaseView
local TabView = class("TabView", require("BaseView"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local ButtonView = require("ButtonView")
local ContainerView = require("ContainerView")

local VIEW_CONTAINER_KEY = "ViewContainer"

function TabView:__init(key, widget, parent, parentRoot, location)
    TabView.super.__init(self, key, widget, parent, parentRoot, location)
    self._selectedIndex = 0
    self._panelTab = nil  ---@type UINode
    self._panelContainer = nil  ---@type UINode
    self._panelInnerContainer = nil  ---@type UINode
    self:_initContent(location)
end

function TabView:_onDestroy()
    self._panelTab = nil
    self._panelContainer = nil
    self._panelInnerContainer = nil
    TabView.super._onDestroy(self)
end

---@return TCE.Tab
function TabView:getWidget()
    return self._widget
end

function TabView:_initContent(location)
    self:adjustLayout(true, location)
end

function TabView:adjustLayout(isInitializing, location)
    local data = self:getWidget()
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, {
        layout = "FULL", bgColor = "B", }, true)

    self._panelTab = UIUtil.ensurePanel(self._root, "panel_tab", { 0, 0, 32, Constant.DEFAULT_BAR_HEIGHT }, {
        layout = "FULL_W" }, true)

    self._panelContainer = UIUtil.ensurePanel(self._root, "panel_container", {}, {
        margins = { 0, Constant.DEFAULT_BAR_HEIGHT, 0, 0, true, true }, bgColor = "A", })

    self._panelInnerContainer = UIUtil.ensurePanel(self._panelContainer, "inner", {}, {
        margins = { Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, true, true },
        bgColor = "B", })

    self:removeAllChildren()
    local elementX, elementY = 0, 0
    for idx, widgetElement in ipairs(data:getElements()) do
        local tabBtn = widgetElement:getTabButton()
        local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
        local tab = ButtonView.new(idx, tabBtn, self, self._panelTab, elementLocation,
                { tag = idx, style = "Tab", selectedColor = "A" })
        elementX = elementX + tab:getRoot().width
    end

    if isInitializing then
        self:setSelected(1)
    else
        self:checkSelectedValid()
    end
end

function TabView:checkSelectedValid()
    if not self:hasAnyTab() then
        return
    end
    local total = #self:getWidget():getElements()
    if self._selectedIndex <= total then
        return
    end
    self:setSelected(1)
end

function TabView:setSelected(index)
    if not self:hasAnyTab() then
        return
    end
    if self._selectedIndex == index then
        return
    end
    self._selectedIndex = index
    self:updateSelect()
end

function TabView:hasAnyTab()
    return #self:getWidget():getElements() > 0
end

function TabView:updateSelect()
    for index, child in ipairs(self._children) do
        local selected = index == self._selectedIndex
        child:setSelected(selected)
    end

    local data = self:getWidget()
    local elementData = data:getElements()[self._selectedIndex]
    local containerWidget = elementData:getContainer()

    self:tryRemoveChild(VIEW_CONTAINER_KEY)
    ContainerView.new(VIEW_CONTAINER_KEY, containerWidget, self, self._panelInnerContainer, {})
end

return TabView