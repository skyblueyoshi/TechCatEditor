---@class TCE.ScrollBar:TCE.BaseControl
local ScrollBar = class("ScrollBar", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

---__init
---@param parent TCE.BaseControl
---@param parentRoot UINode
function ScrollBar:__init(name, parent, parentRoot, isVertical)
    ScrollBar.super.__init(self, name, parent, parentRoot, {})
    self._isVertical = isVertical
    self._panelList = UIScrollView.cast(self._parentRoot:getChild("panel_list"))
    self._slider = nil  ---@type UINode
    self._isMovingByMouse = false
    self._lastSliderPosValue = 0
    self._lastTouchPos = nil  ---@type Vector2
    self._curTouchPos = nil  ---@type Vector2
    self:_initContent()
end

function ScrollBar:onDestroy()
    self._panelList = nil
    ScrollBar.super.onDestroy(self)
end

function ScrollBar:_initContent()
    self:adjustLayout(true, nil)

    local listener = { self._onScrollDataChanged, self }
    self._panelList:addScrollingListener(listener)
    self._panelList:addResizeListener(listener)

    self._slider:addTouchDownListener({ self._onTouchDown, self })
    self._slider:addTouchUpAfterMoveListener({ self._onTouchUp, self })
    self._slider:addTouchMoveListener({ self._onTouchMove, self })

    self:_onScrollDataChanged()
end

function ScrollBar:adjustLayout(isInitializing, _)
    local margins
    if self._isVertical then
        margins = { nil, 1, 1, 1, false, true }
    else
        margins = { 1, nil, 1, 1, true, false }
    end

    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, { 0, 0, Constant.SCROLL_BAR_WIDTH, Constant.SCROLL_BAR_WIDTH }, {
        margins = margins,
        bgColor = "A2",
    })
    UIUtil.ensurePanel(self._root, "mask", { 0, 0, 12, 12 }, {
        bgColor = "A",
        margins = { 6, 12, 6, 12, true, true },
    })
    local sliderLocation
    if isInitializing then
        sliderLocation = { 0, 0, Constant.SCROLL_BAR_WIDTH, Constant.SCROLL_BAR_WIDTH }
    end
    self._slider = UIUtil.ensurePanel(self._root, "slider", sliderLocation)
    UIUtil.ensurePanel(self._slider, "sd", { 0, 0, 12, 12 }, {
        bgColor = "SD",
        margins = { 4, 4, 4, 4, true, true },
    }, false, false)
    self._root:applyMargin(true)

    if not isInitializing then
        self:_onScrollDataChanged()
    end
end

function ScrollBar:_onScrollDataChanged()
    if self._isMovingByMouse then
        return
    end
    if self._panelList.height <= 0 or self._panelList.viewSize.height <= 0 then
        return
    end

    self:_refresh()
end

function ScrollBar:_setRate(rate)
    if self._isVertical then
        self._slider.positionY = math.floor((self._root.height - self._slider.height) * rate)
    else
        self._slider.positionX = math.floor((self._root.width - self._slider.width) * rate)
    end
end

function ScrollBar:_setFull()
    self._slider.height = self._root.height
    self:_setRate(0)
end

function ScrollBar:_refresh()
    local svTotal = self._isVertical and self._panelList.height or self._panelList.width
    local svViewTotal = self._isVertical and self._panelList.viewSize.height or self._panelList.viewSize.width
    if svTotal <= 0 or svViewTotal <= 0 then
        self:_setFull()
        return
    end

    local total = self._isVertical and self._root.height or self._root.width

    local sizeRate = math.max(0.01, math.min(1.0, svTotal * 1.0 / svViewTotal))
    local sliderSizeValue = math.ceil(total * sizeRate)
    sliderSizeValue = math.max(32, math.min(total, sliderSizeValue))
    if self._isVertical then
        self._slider.height = sliderSizeValue
        self:_setRate(self._panelList.scrollRateVertical)
    else
        self._slider.width = sliderSizeValue
        self:_setRate(self._panelList.scrollRateHorizontal)
    end
    self._slider:applyMargin(true)
end

function ScrollBar:_moveByMouse()
    if not self._isMovingByMouse then
        return
    end
    local move, maxValue
    if self._isVertical then
        move = self._curTouchPos.y - self._lastTouchPos.y
        maxValue = self._root.height - self._slider.height
    else
        move = self._curTouchPos.x - self._lastTouchPos.x
        maxValue = self._root.width - self._slider.width
    end
    local newPosValue = self._lastSliderPosValue + move
    if newPosValue < 0 then
        newPosValue = 0
    elseif newPosValue > maxValue then
        newPosValue = maxValue
    end
    self._slider.positionY = newPosValue
    local rate = 0.0
    if maxValue > 0 then
        rate = newPosValue * 1.0 / maxValue
    end
    if self._isVertical then
        self._panelList:scrollToRateVertical(rate)
    else
        self._panelList:scrollToRateHorizontal(rate)
    end
end

---_onTouchDown
---@param touch Touch
function ScrollBar:_onTouchDown(_, touch)
    self._lastTouchPos = touch.position
    self._curTouchPos = touch.position
    if self._isVertical then
        self._lastSliderPosValue = self._slider.positionY
    else
        self._lastSliderPosValue = self._slider.positionX
    end
    self._isMovingByMouse = true
    self:_moveByMouse()
end

function ScrollBar:_onTouchMove(_, touch)
    self._curTouchPos = touch.position
    self:_moveByMouse()
end

function ScrollBar:_onTouchUp(_, _)
    self._lastTouchPos = nil
    self._curTouchPos = nil
    self._lastSliderPosValue = 0
    self._isMovingByMouse = false
end

function ScrollBar:setVisible(visible)
    self._root.visible = visible
end

return ScrollBar