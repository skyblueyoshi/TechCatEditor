---@class TCE.DraggableArea:TCE.BaseControl
local DraggableArea = class("DraggableArea", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

---__init
---@param parent TCE.BaseControl
---@param parentRoot UINode
function DraggableArea:__init(name, parent, parentRoot, isVertical, callback)
    DraggableArea.super.__init(self, name, parent, parentRoot, {})
    self._isVertical = isVertical
    self._lastTouchPos = nil  ---@type Vector2
    self._curTouchPos = nil  ---@type Vector2
    self._callback = callback
    self:_initContent()
end

function DraggableArea:onDestroy()
    DraggableArea.super.onDestroy(self)
end

function DraggableArea:_initContent()
    self:adjustLayout(true)
    self._root:addTouchDownListener({ self._onTouchDown, self })
    self._root:addTouchUpAfterMoveListener({ self._onTouchUp, self })
    self._root:addTouchMoveListener({ self._onTouchMove, self })
end

function DraggableArea:adjustLayout(isInitializing, location)
    local margins
    if self._isVertical then
        margins = { nil, 1, 1, 1, false, true }
    else
        margins = { 1, nil, 1, 1, true, false }
    end

    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, { 0, 0, Constant.DRAG_AREA_SIZE, Constant.DRAG_AREA_SIZE }, {
        margins = margins,
        bgColor = "B",
    }, false, true)

    local marginSD
    if self._isVertical then
        marginSD = { 0, 2, 0, 2, false, true }
    else
        marginSD = { 2, 0, 2, 0, true, false }
    end
    local sd = UIUtil.ensurePanel(self._root, "sd", { 0, 0, 64, 64 }, {
        margins = marginSD,
        bgColor = "SD",
    })
    if isInitializing then
        sd.visible = false
    end
end

---_onTouchDown
---@param touch Touch
function DraggableArea:_onTouchDown(_, touch)
    self._lastTouchPos = touch.position
    self._curTouchPos = touch.position
    self:updateDragging(true)
    self._root:getChild("sd").visible = true
end

function DraggableArea:_onTouchMove(_, touch)
    self._curTouchPos = touch.position
    self:updateDragging(false)
end

function DraggableArea:_onTouchUp(_, _)
    self._lastTouchPos = nil
    self._curTouchPos = nil
    self._root:getChild("sd").visible = false
end

function DraggableArea:updateDragging(isBegin)
    if self._curTouchPos == nil then
        return
    end
    local move
    if self._isVertical then
        move = self._curTouchPos.y - self._lastTouchPos.y
    else
        move = self._curTouchPos.x - self._lastTouchPos.x
    end
    move = math.floor(move)
    self._callback[1](self._callback[2], move, isBegin)
end

return DraggableArea