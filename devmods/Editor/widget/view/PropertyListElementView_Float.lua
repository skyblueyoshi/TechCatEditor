local PropertyListElementView_Input = require("PropertyListElementView_Input")
---@class TCE.PropertyListElementView_Float:TCE.PropertyListElementView_Input
local PropertyListElementView_Float = class("PropertyListElement_Float", PropertyListElementView_Input)
local PropertyTypes = require("PropertyTypes")

local PANEL_NAME = "panel_int"

function PropertyListElementView_Float:__init(root, index, widget, parent)
    self._nodeListeners = {
        ["panel_input.in"] = {
            OnFinishedEditing = self._onEditFloatFinished,
            OnBeginEditing = self._onEditBegin,
            OnCheckEvent = self._setEditNum,
        }
    }
    PropertyListElementView_Float.super.__init(self, PropertyTypes.Float, PANEL_NAME, root, index, widget, parent)
end


function PropertyListElementView_Float.ensureElementPanel(panelElement)
    PropertyListElementView_Input._ensureElementPanel(PANEL_NAME, panelElement)
end

return PropertyListElementView_Float