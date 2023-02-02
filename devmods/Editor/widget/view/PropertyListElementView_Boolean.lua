local PropertyListElementView = require("PropertyListElementView")
---@class TCE.PropertyListElementView_Boolean:TCE.PropertyListElementView
local PropertyListElementView_Boolean = class("PropertyListElement_Boolean", PropertyListElementView)
local PropertyTypes = require("PropertyTypes")
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")

local PANEL_NAME = "panel_check"

function PropertyListElementView_Boolean:__init(root, index, widget, parent)
    self._nodeListeners = {
        ["check"] = {
            OnTouchEnd = self._onCheckClicked,
            OnCheckEvent = self._updateDisplay,
        }
    }
    PropertyListElementView_Boolean.super.__init(self, PropertyTypes.Boolean, PANEL_NAME, root, index, widget, parent)
end

function PropertyListElementView_Boolean.ensureElementPanel(panelElement)
    local subPanel = PropertyListElementView.makeSubPanel(PANEL_NAME, panelElement)
    local checkBox = UIUtil.ensurePanel(subPanel, "check", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    })
    checkBox.sprite = UISpritePool.getInstance():get("icon_16_check_false")
end

function PropertyListElementView_Boolean:_onCheckClicked(_, _)
    self:setValue(not self:getValue())
end

function PropertyListElementView_Boolean:_updateDisplay(node)
    local checkBox = UIPanel.cast(node)
    local value = self:getValue()
    checkBox.sprite = UISpritePool.getInstance():get(value and "icon_16_check_true" or "icon_16_check_false")
end

return PropertyListElementView_Boolean