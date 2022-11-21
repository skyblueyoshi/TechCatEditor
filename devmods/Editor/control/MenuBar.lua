---@class TCE.Menubar:TCE.BaseControl
local Menubar = class("MenuBar", require("BaseControl"))
local Button = require("Button")
local UIFactory = require("core.UIFactory")
local Constant = require("config.Constant")

function Menubar:__init(parent, data, location)
    Menubar.super.__init(self, parent, data)
    self._root = nil ---@type:UINode

    self._selectedIndex = 0
    self.showPopupWhenPointed = false
    self:_initContent(location)
end

function Menubar:_initContent(location)
    local x, y = location[1], location[2]
    local name = "menu_bar"
    self._root = UIFactory.newPanel(self._parent:getRoot(), name,
            { x, y, 0, Constant.DEFAULT_BAR_HEIGHT }, {
                layout = "FULL_W",
                bgColor = "B",
            }, true)

    if self._data.Children then
        local elementX, elementY = 0, 0
        for idx, data in ipairs(self._data.Children) do
            data.IsTab = true
            local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
            local tab = Button.new(self, data, elementLocation, idx)
            elementX = elementX + tab:getRoot().width
            self:addChild(tab)
        end
    end
end

function Menubar:setSelected(index)
    if self._selectedIndex == index then
        return
    end
    self._selectedIndex = index
    self:updateSelect()
end

function Menubar:updateSelect()
    for index, child in ipairs(self._children) do
        if index == self._selectedIndex then
            child:tryShowPopupMenu()
        else
            child:hidePopupMenu()
        end
    end
end

return Menubar