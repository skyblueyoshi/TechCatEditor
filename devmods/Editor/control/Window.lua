---@class TCE.Window:TCE.BaseControl
local Window = class("MenuBar", require("BaseControl"))
local UIFactory = require("core.UIFactory")

function Window:__init(parent, config, data, location)
    Window.super.__init(self, parent, config, data)
    self._root = nil ---@type:UINode

    self:_initContent(location)
end

function Window:destroy()
    if self:isDestroyed() then
        return
    end

    Window.super.destroy(self)
end

function Window:_initContent(location)

    local name = "window"
    self._root = UIFactory.newPanel(self._parent, name, { 0, 0 }, {
        margins = { 0, 0, 0, 0, true, true },
        bgColor = "C",
    })
end

return Window