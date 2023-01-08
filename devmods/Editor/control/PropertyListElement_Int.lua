local PropertyListElement_Input = require("PropertyListElement_Input")
---@class TCE.PropertyListElement_Int:TCE.PropertyListElement_Input
local PropertyListElement_Int = class("PropertyListElement_Int", PropertyListElement_Input)
local PropertyTypes = require("PropertyTypes")

local PANEL_NAME = "panel_int"

function PropertyListElement_Int:__init(root, parent, data, index)
    self._nodeListeners = {
        ["panel_input.in"] = {
            OnFinishedEditing = self._onEditIntFinished,
            OnBeginEditing = self._onEditBegin,
            OnCheckEvent = self._setEditNum,
        }
    }
    PropertyListElement_Int.super.__init(self, PropertyTypes.Int, PANEL_NAME, root, parent, data, index)
end


function PropertyListElement_Int.ensureElementPanel(panelElement)
    PropertyListElement_Input._ensureElementPanel(PANEL_NAME, panelElement)
end

return PropertyListElement_Int