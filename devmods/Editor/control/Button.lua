---@class TCE.Button:TCE.BaseControl
local Button = class("Button", require("BaseControl"))
local UIFactory = require("core.UIFactory")
local Constant = require("config.Constant")

--[[
{
    Text = "",
    IsTab = bool,
    Children = {},
    PopupMenu = {},
}
--]]

function Button:__init(parent, data, location, tag)
    Button.super.__init(self, parent, data)
    self._pointed = false
    self._selected = false
    self._tag = tag
    self._subPopupMenu = nil

    self:_initContent(location)
end

function Button:onDestroy()
    self:_destroySubPopupMenu()
    Button.super.onDestroy(self)
end

function Button:_destroySubPopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

function Button:_initContent(location)
    local name = string.format("btn")
    self._root = UIFactory.newPanel(self._parent:getRoot(),
            name, location, nil, true, true)
    UIFactory.newPanel(self._root, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    self._root:getChild("sd").visible = false
    local data = self._data
    if data.Text then
        local text = UIFactory.newText(self._root, "cap", nil, data.Text, {
            layout = "CENTER",
        })
        self._root.width = math.max(self._root.width, text.width + Constant.TEXT_SIDE_OFFSET * 2)
    end

    self._root:addMousePointedEnterListener({ self._onMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
    self._root:addTouchDownListener({ self._onMouseDown, self })
    self._root:applyMargin(true)
end

function Button:setPointed(pointed)
    if self._pointed == pointed then
        return
    end
    self._pointed = pointed
    self:_updateDisplay()
end

function Button:setSelected(selected)
    if self._selected == selected then
        return
    end
    self._selected = selected
    self:_updateDisplay()
end

function Button:_updateDisplay()
    UIFactory.setPanelDisplay(self._root, self._selected, self._pointed)
end

function Button:_onMouseEnter(_)
    if self._data.IsTab then
        if self._parent.showPopupWhenPointed then
            self._parent:setSelected(self._tag)
        end
    end
    self:setPointed(true)
end

function Button:_onMouseLeave(_)
    self:setPointed(false)
end

function Button:_onMouseDown(_)
    if self._data.IsTab then
        self._parent.showPopupWhenPointed = true
        self._parent:setSelected(self._tag)
    end
end

function Button:tryShowPopupMenu()
    self:hidePopupMenu()
    if self._data.PopupMenu then
        local PopupMenu = require("PopupMenu")
        local wx, wy = self:getPositionInWindow()
        self._subPopupMenu = PopupMenu.new(self:getWindow(), self._data.PopupMenu,
                { wx, wy + self._root.height })
    end
    return self._subPopupMenu
end

function Button:hidePopupMenu()
    self:_destroySubPopupMenu()
end

return Button