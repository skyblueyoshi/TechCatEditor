local PropertyListElementView_Input = require("PropertyListElementView_Input")
---@class TCE.PropertyListElementView_Int:TCE.PropertyListElementView_Input
local PropertyListElementView_Int = class("PropertyListElement_Int", PropertyListElementView_Input)
local PropertyTypes = require("PropertyTypes")

local PANEL_NAME = "panel_int"

function PropertyListElementView_Int:__init(root, index, widget, parent)
    self._nodeListeners = {
        ["panel_input.in"] = {
            OnFinishedEditing = self._onEditIntFinished,
            OnBeginEditing = self._onEditBegin,
            OnCheckEvent = self._setEditNum,
        }
    }
    PropertyListElementView_Int.super.__init(self, PropertyTypes.Int, PANEL_NAME, root, index, widget, parent)
end


function PropertyListElementView_Int.ensureElementPanel(panelElement)
    PropertyListElementView_Input._ensureElementPanel(PANEL_NAME, panelElement)
end

return PropertyListElementView_Int