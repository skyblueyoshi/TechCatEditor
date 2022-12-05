---@class TCE.Window:TCE.Container
local Window = class("MenuBar", require("Container"))
local UIUtil = require("core.UIUtil")
local EventDef = require("config.EventDef")

function Window:__init(parent, parentRoot, data, location)
    Window.super.__init(self, parent, parentRoot, data, location)
    self.isWindow = true

    self:_initWindowContent(location)
end

function Window:_initWindowContent(location)
    local popupArea = UIUtil.newPanel(self._root, "popup_area", location, { layout = "FULL" }, false)
    popupArea.touchBlockable = false
    popupArea:addTouchDownListener({ self._onPopupOutsideClicked, self })
end

function Window:_onPopupOutsideClicked(_, _)
    self:triggerEvent(EventDef.ALL_POPUP_CLOSE, nil)
end

return Window