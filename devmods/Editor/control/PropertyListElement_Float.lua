local PropertyListElement_Input = require("PropertyListElement_Input")
---@class TCE.PropertyListElement_Float:TCE.PropertyListElement_Input
local PropertyListElement_Float = class("PropertyListElement_Float", PropertyListElement_Input)
local PropertyTypes = require("PropertyTypes")

local PANEL_NAME = "panel_int"

function PropertyListElement_Float:__init(root, parent, data, index)
    self._nodeListeners = {
        ["panel_input.in"] = {
            OnFinishedEditing = self._onEditFloatFinished,
            OnBeginEditing = self._onEditBegin,
            OnCheckEvent = self._setEditNum,
        }
    }
    PropertyListElement_Float.super.__init(self, PropertyTypes.Float, PANEL_NAME, root, parent, data, index)
end


function PropertyListElement_Float.ensureElementPanel(panelElement)
    PropertyListElement_Input._ensureElementPanel(PANEL_NAME, panelElement)
end

return PropertyListElement_Float