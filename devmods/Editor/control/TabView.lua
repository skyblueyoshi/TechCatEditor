---@class TCE.TabView:TCE.BaseControl
local TabView = class("TabView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local Button = require("Button")
local Container = require("Container")

local VIEW_CONTAINER_KEY = "ViewContainer"

function TabView:__init(name, parent, parentRoot, data, location)
    TabView.super.__init(self, name, parent, parentRoot, data, location)
    self._selectedIndex = 0
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

---@return TCE.TabData
function TabView:getData()
    return self._data
end

function TabView:_initContent(location)
    self:adjustLayout(true, location)
end

function TabView:adjustLayout(isInitializing, location)
    local data = self:getData()
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, {
        layout = "FULL",
        bgColor = "B",
    }, true)

    self._panelTab = UIUtil.ensurePanel(self._root, "panel_tab", { 0, 0, 32, Constant.DEFAULT_BAR_HEIGHT }, {
        layout = "FULL_W"
    }, true)

    self._panelContainer = UIUtil.ensurePanel(self._root, "panel_container", {}, {
        margins = { 0, Constant.DEFAULT_BAR_HEIGHT, 0, 0, true, true },
        bgColor = "A",
    })

    self._panelInnerContainer = UIUtil.ensurePanel(self._panelContainer, "inner", {}, {
        margins = { Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, Constant.TAB_VIEW_SIDE_OFFSET, true, true },
        bgColor = "B",
    })

    self:removeAllChildren()
    local elementX, elementY = 0, 0
    for idx, elementData in ipairs(data:getElements()) do
        local tabData = elementData:getTabButton()
        local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
        local tab = Button.new("tab_" .. tostring(idx), self, self._panelTab, tabData, elementLocation,
                { tag = idx, style = "Tab", selectedColor = "A" })
        elementX = elementX + tab:getRoot().width
        self:addChild(tab)
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
    local total = #self:getData():getElements()
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
    return #self:getData():getElements() > 0
end

function TabView:updateSelect()
    for index, child in ipairs(self._children) do
        local selected = index == self._selectedIndex
        child:setSelected(selected)
    end

    local data = self:getData()
    local elementData = data:getElements()[self._selectedIndex]
    local containerData = elementData:getContainer()

    self:removeChildFromMap(VIEW_CONTAINER_KEY)
    self._viewContainer = Container.new("view", self, self._panelInnerContainer, containerData, {})
    self:addChildToMap(VIEW_CONTAINER_KEY, self._viewContainer)
end

return TabView