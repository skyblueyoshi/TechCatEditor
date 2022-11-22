---@class TCE.Window:TCE.Container
local Window = class("MenuBar", require("Container"))

function Window:__init(parent, parentRoot, data, location)
    Window.super.__init(self, parent, parentRoot, data, location)
    self.isWindow = true

    self:_initWindowContent(location)
end

function Window:_initWindowContent(location)

end

return Window