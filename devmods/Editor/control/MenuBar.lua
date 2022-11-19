---@class TCE.Menubar:TCE.BaseControl
local Menubar = class("MenuBar", require("BaseControl"))
local TabElement = require("TabElement")
local UIFactory = require("core.UIFactory")

function Menubar:__init(parent, config, data, location)
    Menubar.super.__init(self, parent, config, data)
    self._root = nil ---@type:UINode

    self._tabElements = {}
    self:_initContent(location)
end

function Menubar:destroy()
    if self:isDestroyed() then
        return
    end
    for _, tabElement in ipairs(self._tabElements) do
        tabElement:destroy()
    end
    self._tabElements = {}

    Menubar.super.destroy(self)
end

function Menubar:_initContent(location)
    local x, y, w, h = location[1], location[2], location[3], location[4]
    local name = "menu_bar"
    self._root = UIFactory.newPanel(self._parent, name, { x, y }, {
        margins = { 0, nil, 0, nil, true, false },
        bgColor = "A",
    })

    local elementX, elementY = 0, 0
    for idx, data in ipairs(self._data) do
        local elementLocation = { elementX, elementY, 32, h }
        local tab = TabElement.new(self._root, nil, data, elementLocation, idx)
        elementX = elementX + tab:getSize().width
        table.insert(self._tabElements, tab)
    end
end

return Menubar