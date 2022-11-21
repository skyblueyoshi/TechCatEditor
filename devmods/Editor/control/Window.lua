---@class TCE.Window:TCE.Container
local Window = class("MenuBar", require("Container"))

function Window:__init(parent, data, location)
    Window.super.__init(self, parent, data, location)
    self.isWindow = true

    self:_initWindowContent(location)
end

function Window:_initWindowContent(location)

end

return Window