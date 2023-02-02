---@class TCE.ActivePanelView:TCE.BaseView
local ActivePanelView = class("ActivePanelView", require("BaseView"))
local UIUtil = require("core.UIUtil")

function ActivePanelView:__init(key, widget, parent, parentRoot)
    ActivePanelView.super.__init(self, key, widget, parent, parentRoot)
    self._sdPanel = nil
    self._pointed = false
    self._selected = false
    self._selectedColor = "SD"
    self._pointedColor = "BD"
end

function ActivePanelView:_initContent(location)
    self:adjustLayout(true, location)
    self._root:addMousePointedEnterListener({ self._onMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
    self._root:addTouchDownListener({ self._onMouseDown, self })
end

function ActivePanelView:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, nil, true, true)
    self._sdPanel = UIUtil.ensurePanel(self._root, "sd", nil, { layout = "FULL", bgColor = "BD", }, false, false)

    if isInitializing then
        self._sdPanel.visible = false
    end

    self._root:applyMargin(true)
end

function ActivePanelView:setPointed(pointed)
    if self._pointed == pointed then
        return
    end
    self._pointed = pointed
    self:_updateDisplay()
end

function ActivePanelView:setSelected(selected)
    if self._selected == selected then
        return
    end
    self._selected = selected
    self:_updateDisplay()
end

function ActivePanelView:_updateDisplay()
    UIUtil.setPanelDisplay(self._root, self._selected, self._pointed, self._selectedColor, self._pointedColor)
end

function ActivePanelView:_onMouseEnter(_)
    self:setPointed(true)
end

function ActivePanelView:_onMouseLeave(_)
    self:setPointed(false)
end

function ActivePanelView:_onMouseDown(_)

end

return ActivePanelView