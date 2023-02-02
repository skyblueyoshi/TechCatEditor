---@class TCE.WindowView:TCE.ContainerView
local WindowView = class("WindowView", require("ContainerView"))
local UIUtil = require("core.UIUtil")
local EventDef = require("config.EventDef")

function WindowView:__init(key, widget, parent, parentRoot, location)
    WindowView.super.__init(self, key, widget, parent, parentRoot, location)
    self.isWindow = true
    self._popupArea = nil

    File.saveString(Path.join(App.persistentDataPath, "test.json"), JsonUtil.toJson(widget:save(true)))
end

function WindowView:adjustLayout(isInitializing, location)
    WindowView.super.adjustLayout(self, isInitializing, location)
    self._popupArea = UIUtil.ensurePanel(self._root, "popup_area", location, { layout = "FULL" }, false)
    self._popupArea.touchBlockable = false
    if isInitializing then
        self._popupArea:addTouchDownListener({ self._onPopupOutsideClicked, self })
    end
end

function WindowView:_onPopupOutsideClicked(_, _)
    self:triggerEvent(EventDef.ALL_POPUP_CLOSE, nil)
end

return WindowView