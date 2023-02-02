---@class TCE.MenuBarView:TCE.BaseView
local MenuBarView = class("MenuBarView", require("BaseView"))
local ButtonView = require("ButtonView")
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")

function MenuBarView:__init(key, widget, parent, parentRoot, location)
    MenuBarView.super.__init(self, key, widget, parent, parentRoot)
    self._selectedIndex = 0
    self.showPopupWhenPointed = false
    self:_initContent(location)
end

---@return TCE.MenuBar
function MenuBarView:getWidget()
    return self._widget
end

function MenuBarView:_initContent(location)
    local x, y = location[1], location[2]
    self:adjustLayout(true, { x, y, 0, Constant.DEFAULT_BAR_HEIGHT })
    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function MenuBarView:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, {
                layout = "FULL_W", bgColor = "B",
                --borderColor = "A",
            }, true)

    self:_reloadAllChildren()
end

function MenuBarView:_reloadAllChildren()
    self:removeAllChildren()

    local data = self:getWidget()
    for idx, widgetElement in ipairs(data:getElements()) do
        local elementLocation = { 0, 0, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
        ButtonView.new(idx, widgetElement, self, nil, elementLocation, { tag = idx, style = "Tab" })
    end
    self:_adjustChildrenLayout()
end

function MenuBarView:_adjustChildrenLayout()
    local elementX, elementY = 0, 0
    for _, tab in ipairs(self._children) do
        tab:getRoot():setPosition(elementX, elementY)
        elementX = elementX + tab:getRoot().width
    end
end

function MenuBarView:clearSelected()
    self:setSelected(0)
end

function MenuBarView:setSelected(index)
    if self._selectedIndex == index then
        return
    end
    self._selectedIndex = index
    self:updateSelect()
end

function MenuBarView:updateSelect()
    local selectedChild = nil
    ---@param child TCE.ButtonView
    for index, child in ipairs(self._children) do
        if index ~= self._selectedIndex then
            child:hidePopupMenu()
        else
            selectedChild = child
        end
    end
    if selectedChild ~= nil then
        selectedChild:tryShowPopupMenu()
    end
end

function MenuBarView:_onPopupOutsideEvent(_)
    self.showPopupWhenPointed = false
    self:clearSelected()
end

function MenuBarView:onChildLayoutChanged(key)
    self:_onPopupOutsideEvent()
    self:_adjustChildrenLayout()
end

function MenuBarView:onNotifyChanges(_, names)
    if names["elements"] then
        self:_reloadAllChildren()
    end
end

return MenuBarView