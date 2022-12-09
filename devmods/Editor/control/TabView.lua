---@class TCE.TabView:TCE.BaseControl
local TabView = class("TabView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local Button = require("Button")
local Container = require("Container")

local VIEW_CONTAINER_KEY = "ViewContainer"

function TabView:__init(parent, parentRoot, data, location)
    TabView.super.__init(self, parent, parentRoot, data, location)
    self._selectedIndex = 0
    self._tabCount = 0
    self._panelTab = nil  ---@type UINode
    self._panelContainer = nil  ---@type UINode
    self._panelInnerContainer = nil  ---@type UINode
    self._viewContainer = nil  ---@type TCE.Container
    self:_initContent(location)
end

function TabView:onDestroy()
    self._panelTab = nil
    self._panelContainer = nil
    self._panelInnerContainer = nil
    self._viewContainer = nil
    TabView.super.onDestroy(self)
end

function TabView:_initContent(location)
    self._tabCount = #self._data
    self._root = UIUtil.newPanel(self._parentRoot, "tab_view", location, {
        layout = "FULL",
        --bgColor = "B",
    }, true)

    self._panelTab = UIUtil.newPanel(self._root, "panel_tab", { 0, 0, 32, Constant.DEFAULT_BAR_HEIGHT }, {
        layout = "FULL_W"
    }, true)

    self._panelContainer = UIUtil.newPanel(self._root, "panel_container", {}, {
        margins = { 0, Constant.DEFAULT_BAR_HEIGHT, 0, 0, true, true },
        bgColor = "A",
    })

    self._panelInnerContainer = UIUtil.newPanel(self._panelContainer, "inner", {}, {
        margins = { Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, true, true },
        bgColor = "B",
    })

    local elementX, elementY = 0, 0
    for idx, data in ipairs(self._data) do
        local tabData = data.Tab
        local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
        local tab = Button.new(self, self._panelTab, tabData, elementLocation, { tag = idx, style = "Tab", selectedColor = "A" })
        elementX = elementX + tab:getRoot().width
        self:addChild(tab)
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
    return self._tabCount > 0
end

function TabView:updateSelect()
    for index, child in ipairs(self._children) do
        local selected = index == self._selectedIndex
        child:setSelected(selected)
    end

    local data = self._data[self._selectedIndex]
    local containerData = data.Container

    if self:getChildFromMap(VIEW_CONTAINER_KEY) ~= nil then
        self:removeChildFromMap(VIEW_CONTAINER_KEY)
        self._viewContainer = nil
    end
    self._viewContainer = Container.new(self, self._panelInnerContainer, containerData, {})
    self:addChildToMap(VIEW_CONTAINER_KEY, self._viewContainer)
end

return TabView