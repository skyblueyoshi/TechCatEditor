---@class TCE.ActivePanel:TCE.BaseControl
local ActivePanel = class("ActivePanel", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

function ActivePanel:__init(name, parent, parentRoot, data, location)
    ActivePanel.super.__init(self, name, parent, parentRoot, data)
    self._pointed = false
    self._selected = false
    self._selectedColor = "SD"
    self._pointedColor = "BD"
end

function ActivePanel:_initContent(location)
    self:adjustLayout(true, location)
    self._root:addMousePointedEnterListener({ self._onMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
    self._root:addTouchDownListener({ self._onMouseDown, self })
end

function ActivePanel:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, nil, true, true)
    UIUtil.ensurePanel(self._root, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)

    if isInitializing then
        self._root:getChild("sd").visible = false
    end

    self._root:applyMargin(true)
end

function ActivePanel:setPointed(pointed)
    if self._pointed == pointed then
        return
    end
    self._pointed = pointed
    self:_updateDisplay()
end

function ActivePanel:setSelected(selected)
    if self._selected == selected then
        return
    end
    self._selected = selected
    self:_updateDisplay()
end

function ActivePanel:_updateDisplay()
    UIUtil.setPanelDisplay(self._root, self._selected, self._pointed, self._selectedColor, self._pointedColor)
end

function ActivePanel:_onMouseEnter(_)
    self:setPointed(true)
end

function ActivePanel:_onMouseLeave(_)
    self:setPointed(false)
end

function ActivePanel:_onMouseDown(_)

end

return ActivePanel