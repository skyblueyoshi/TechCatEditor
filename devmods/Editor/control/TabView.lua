---@class TCE.TabView:TCE.BaseControl
local TabView = class("TabView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local Button = require("Button")

function TabView:__init(parent, parentRoot, data, location)
    TabView.super.__init(self, parent, parentRoot, data, location)
    self._selectedIndex = 0
    self:_initContent(location)
end

function TabView:_initContent(location)
    self._root = UIUtil.newPanel(self._parentRoot, "tab_view", location, {
        layout = "FULL",
        bgColor = "B",
    }, true)

    local panelTab = UIUtil.newPanel(self._root, "panel_tab", { 0, 0, 32, Constant.DEFAULT_BAR_HEIGHT }, {
        layout = "FULL_W"
    })

    local elementX, elementY = 0, 0
    for idx, data in ipairs(self._data) do
        local tabData = data.Tab
        local container = data.Container
        local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
        local tab = Button.new(self, panelTab, tabData, elementLocation, { tag = idx, style = "Tab" })
        elementX = elementX + tab:getRoot().width
        self:addChild(tab)
    end
end

function TabView:setSelected(index)
    if self._selectedIndex == index then
        return
    end
    self._selectedIndex = index
end

return TabView