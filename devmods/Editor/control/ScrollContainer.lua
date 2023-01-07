---@class TCE.ScrollContainer:TCE.BaseControl
local ScrollContainer = class("ScrollContainer", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local ScrollBar = require("ScrollBar")

function ScrollContainer:__init(name, parent, parentRoot, data, param)
    ScrollContainer.super.__init(self, name, parent, parentRoot, data)
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
    self:_adjustLayoutBegin(true, { location[1], location[2], 200, 400 })
end

function ScrollContainer:_postInitScrollContainer()
    self:_adjustLayoutEnd(true)
end

function ScrollContainer:_adjustLayoutBegin(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, {
                layout = "FULL",
                bgColor = self._bgColor,
                borderColor = "BD",
            }, true)

    if isInitializing then
        self._sv = UIScrollView.new("panel_list", 0, 0, 200, 333)
        self._root:addChild(self._sv)
    end
    UIUtil.setMargins(self._sv, 1, 1, 1, 1, true, true)
    self._root:applyMargin(true)

    self:_onEnsurePanelItem()
end

function ScrollContainer:_adjustLayoutEnd(isInitializing)
    self._sv:applyMargin(true)
    self:_onUpdateScrollContainer(true)
    if isInitializing then
        self._scrollBar = ScrollBar.new("scroll_bar_v", self, self._root, true)
    end
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

function ScrollContainer:_ensureDefaultPanelItem(width, height)
    local panelItem = UIUtil.ensurePanel(self._sv, "panel_item",
            { 0, 0, width, height }, {
                bgColor = self._bgColor,
            }, false)
    return panelItem
end

function ScrollContainer:_onEnsurePanelItem()
    return self:_ensureDefaultPanelItem(200, Constant.DEFAULT_ELEMENT_HEIGHT)
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