local PropertyListElement = require("PropertyListElement")
---@class TCE.PropertyListElement_Boolean:TCE.PropertyListElement
local PropertyListElement_Boolean = class("PropertyListElement_Boolean", PropertyListElement)
local PropertyTypes = require("PropertyTypes")
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")

local PANEL_NAME = "panel_check"

function PropertyListElement_Boolean:__init(root, parent, data, index)
    self._nodeListeners = {
        ["check"] = {
            OnTouchEnd = self._onCheckClicked,
            OnCheckEvent = self._updateDisplay,
        }
    }
    PropertyListElement_Boolean.super.__init(self, PropertyTypes.Boolean, PANEL_NAME, root, parent, data, index)
end

function PropertyListElement_Boolean.ensureElementPanel(panelElement)
    local subPanel = PropertyListElement.makeSubPanel(PANEL_NAME, panelElement)
    local checkBox = UIUtil.ensurePanel(subPanel, "check", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    })
    checkBox.sprite = UISpritePool.getInstance():get("icon_16_check_false")
end

function PropertyListElement_Boolean:_onCheckClicked(_, _)
    self:setValue(not self:getValue())
end

function PropertyListElement_Boolean:_updateDisplay(node)
    local checkBox = UIPanel.cast(node)
    local value = self:getValue()
    checkBox.sprite = UISpritePool.getInstance():get(value and "icon_16_check_true" or "icon_16_check_false")
end

return PropertyListElement_Boolean