local PropertyListElement = require("PropertyListElement")
---@class TCE.PropertyListElement_ComboBox:TCE.PropertyListElement
local PropertyListElement_ComboBox = class("PropertyListElement_ComboBox", PropertyListElement)
local PropertyTypes = require("PropertyTypes")
local UIUtil = require("core.UIUtil")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

local PANEL_NAME = "panel_combo"

function PropertyListElement_ComboBox:__init(root, parent, data, index)
    self._nodeListeners = {
        ["combo"] = {
            OnTouchBegin = self._onComboClicked,
            OnCheckEvent = self._updateCombo,
        }
    }
    PropertyListElement_ComboBox.super.__init(self, PropertyTypes.ComboBox, PANEL_NAME, root, parent, data, index)
    self._popupMenu = nil
end

function PropertyListElement_ComboBox:onDestroy()
    self:_destroyPopupMenu()
    PropertyListElement_ComboBox.super.onDestroy(self)
end

function PropertyListElement_ComboBox:_destroyPopupMenu()
    if self._popupMenu ~= nil then
        self._popupMenu:destroy()
        self._popupMenu = nil
    end
end

function PropertyListElement_ComboBox:_initContent()
    PropertyListElement_ComboBox.super._initContent(self)

    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function PropertyListElement_ComboBox:_onPopupOutsideEvent(_)
    self:hidePopupMenu()
end

function PropertyListElement_ComboBox:hidePopupMenu()
    self:_destroyPopupMenu()
end

function PropertyListElement_ComboBox.ensureElementPanel(panelElement)
    local subPanel = PropertyListElement.makeSubPanel(PANEL_NAME, panelElement)
    local combo = UIUtil.ensurePanel(subPanel, "combo", nil, {
        margins = { 1, 1, 1, 1, true, true },
        bgColor = "A",
    })
    UIUtil.ensureText(combo, "cap", { 4, 0, 32, 32 }, "Cap", {
        margins = { 4, 0, 20, 0, true, false },
        autoAdaptSize = false,
        verticalAlignment = TextAlignment.VCenter,
        horizontalOverflow = TextHorizontalOverflow.Discard,
    })
    local arr = UIUtil.ensurePanel(combo, "arr", { 0, 0, 16, 16 }, {
        margins = { nil, 0, 4, 0, false, false },
    }, false, false)
    arr.sprite = UISpritePool.getInstance():get("icon_arr_down")
    arr.sprite.color = ThemeUtil.getColor("FONT_COLOR")
end

---@param node UINode
function PropertyListElement_ComboBox:_onComboClicked(node, _)
    if self._popupMenu then
        self:hidePopupMenu()
    else
        local config = self:getConfigData()
        local PopupMenu = require("PopupMenu")
        local wx, wy = node.positionInCanvas.x, node.positionInCanvas.y
        self._popupMenu = PopupMenu.new("pop", self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                config:getPopupMenu(),
                { wx, wy + node.height, node.width }, 0, {
                    clickCallback = {
                        function(self, value)
                            self:setValue(value)
                        end, self
                    }
                })

        self:_updateCombo(node)
    end
end

---@param node UINode
function PropertyListElement_ComboBox:_updateCombo(node)
    local value = self:getValue()
    local config = self:getConfigData()
    local popupElementData = config:getPopupMenu():getElements()[value]

    local text = popupElementData:getText()
    local cap = UIText.cast(node:getChild("cap"))
    cap.text = text
end

return PropertyListElement_ComboBox