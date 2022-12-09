---@class TCE.ScrollContainer:TCE.BaseControl
local ScrollContainer = class("ScrollContainer", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local ScrollBar = require("ScrollBar")

function ScrollContainer:__init(parent, parentRoot, data, param)
    ScrollContainer.super.__init(self, parent, parentRoot, data)
    self._containerRoot = nil  ---@type UINode
    self._sv = nil
    self._isSvVertical = true
    self._canScrollVertical = false
    self._lastSize = nil
    self._scrollBar = nil  ---@type TCE.ScrollBar
    self._bgColor = "A2"

    self._isItemFillWidth = true
    if param.isItemFillWidth ~= nil then
        self._isItemFillWidth = param.isItemFillWidth
    end

    self._isGrid = false
    if param.isGrid ~= nil then
        self._isGrid = param.isGrid
    end
end

function ScrollContainer:_preInitScrollContainer(location)
    local x, y = location[1], location[2]
    local name = "scroll_base"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 200, 400 }, {
                layout = "FULL",
                bgColor = self._bgColor,
            }, true)
    self._sv = UIScrollView.new("panel_list", 0, 0, 200, 333)
    UIUtil.setMargins(self._sv, 0, 0, 0, 0, true, true)
    self._root:addChild(self._sv)
    self._root:applyMargin(true)

    self:_onCreatePanelItem()
end

function ScrollContainer:_postInitScrollContainer()
    self._sv:applyMargin(true)
    self:_onUpdateScrollContainer(true)
    self._scrollBar = ScrollBar.new(self, self._root, true)
    self._scrollBar:setVisible(self._canScrollVertical)
end

function ScrollContainer:_onUpdateScrollContainer(isInit)
    self._sv:applyMargin(true)

    local cfg = {
        isItemFillWidth = self._isItemFillWidth,
        isGrid = self._isGrid,
    }
    local innerSize = UIUtil.getTableViewInnerSize(self._sv, self, self._isSvVertical, cfg)
    if innerSize.height > self._sv.height then
        self._canScrollVertical = true
        self._sv:setRightMargin(Constant.SCROLL_BAR_WIDTH, true)
    else
        self._canScrollVertical = false
        self._sv:setRightMargin(0, true)
    end
    self._sv:applyMargin()
    print(innerSize, self._sv.size, self._canScrollVertical, isInit)

    if isInit then
        UIUtil.createTableView(self._sv, self, self._isSvVertical, cfg)
        self._sv:addResizeListener({ self._onResize, self })
    else
        UIUtil._updateTableView(self._sv, self, true, self._isSvVertical, cfg)
        self._scrollBar:setVisible(self._canScrollVertical)
    end
    self._lastSize = self._sv.size
end

function ScrollContainer:_onResize(_)
    if self._sv.size == self._lastSize then
        return
    end

    self:_onUpdateScrollContainer(false)
end

function ScrollContainer:_makeDefaultPanelItem(width, height)
    local panelItem = UIUtil.newPanel(self._sv, "panel_item",
            { 0, 0, width, height }, {
                bgColor = self._bgColor,
            }, false)
    return panelItem
end

function ScrollContainer:_onCreatePanelItem()
    local panelItem = self:_makeDefaultPanelItem(200, Constant.DEFAULT_ELEMENT_HEIGHT)
    return panelItem
end

function ScrollContainer:_getTableElementCount()
    return 0
end

---_setTableElement
---@param node UINode
---@param index number
function ScrollContainer:_setTableElement(node, index)
end

return ScrollContainer