---@class TCE.MenuBar:TCE.BaseControl
local MenuBar = class("MenuBar", require("BaseControl"))
local Button = require("Button")
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")

function MenuBar:__init(parent, parentRoot, data, location)
    MenuBar.super.__init(self, parent, parentRoot, data)
    self._selectedIndex = 0
    self.showPopupWhenPointed = false
    self:_initContent(location)
end

---@return TCE.MenuBarData
function MenuBar:getData()
    return self._data
end

function MenuBar:_initContent(location)
    local x, y = location[1], location[2]
    local name = "menu_bar"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 0, Constant.DEFAULT_BAR_HEIGHT }, {
                layout = "FULL_W",
                bgColor = "B",
                --borderColor = "A",
            }, true)

    self:_reloadAllChildren()
    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function MenuBar:_reloadAllChildren()
    self:removeAllChildren()

    local data = self:getData()
    local elements = data:getElements()
    if #elements > 0 then
        for idx, elementData in ipairs(elements) do
            local elementLocation = { 0, 0, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
            local tab = Button.new(self, self._root, elementData, elementLocation, { tag = idx, style = "Tab" })
            self:addChild(tab)
        end
    end
    self:_adjustChildrenLayout()
end

function MenuBar:_adjustChildrenLayout()
    local elementX, elementY = 0, 0
    for _, tab in ipairs(self:getChildren()) do
        tab:getRoot():setPosition(elementX, elementY)
        elementX = elementX + tab:getRoot().width
    end
end

function MenuBar:clearSelected()
    self:setSelected(0)
end

function MenuBar:setSelected(index)
    if self._selectedIndex == index then
        return
    end
    self._selectedIndex = index
    self:updateSelect()
end

function MenuBar:updateSelect()
    for index, child in ipairs(self._children) do
        if index == self._selectedIndex then
            child:tryShowPopupMenu()
        else
            child:hidePopupMenu()
        end
    end
end

function MenuBar:_onPopupOutsideEvent(_)
    self.showPopupWhenPointed = false
    self:clearSelected()
end

function MenuBar:onChildLayoutChanged(key)
    self:_onPopupOutsideEvent()
    self:_adjustChildrenLayout()
end

function MenuBar:onDataChanged(names)
    if names["elements"] then
        self:_reloadAllChildren()
    end
end

return MenuBar