---@class TCE.Window:TCE.Container
local Window = class("Window", require("Container"))
local UIUtil = require("core.UIUtil")
local EventDef = require("config.EventDef")

function Window:__init(name, parent, parentRoot, data, location)
    Window.super.__init(self, name, parent, parentRoot, data, location)
    self.isWindow = true
end

function Window:adjustLayout(isInitializing, location)
    Window.super.adjustLayout(self, isInitializing, location)
    local popupArea = UIUtil.ensurePanel(self._root, "popup_area", location, { layout = "FULL" }, false)
    popupArea.touchBlockable = false
    if isInitializing then
        popupArea:addTouchDownListener({ self._onPopupOutsideClicked, self })
    end
end

function Window:_onPopupOutsideClicked(_, _)
    self:triggerEvent(EventDef.ALL_POPUP_CLOSE, nil)
end

return Window