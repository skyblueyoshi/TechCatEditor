---@class TCE.Button:TCE.ActivePanel
local Button = class("Button", require("ActivePanel"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

--[[
{
    Text = "",
    IsTab = bool,
    Children = {},
    PopupMenu = {},
}
--]]

function Button:__init(parent, parentRoot, data, location, tag)
    Button.super.__init(self, parent, parentRoot, data, location)
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
    Button.super._initContent(self, location)

    local data = self._data
    if data.Text then
        local text = UIUtil.newText(self._root, "cap", nil, data.Text, {
            layout = "CENTER",
        })
        self._root.width = math.max(self._root.width, text.width + Constant.TEXT_SIDE_OFFSET * 2)
    end

    self._root:applyMargin(true)
end

function Button:_onMouseEnter(_)
    if self._data.IsTab then
        if self._parent.showPopupWhenPointed then
            self._parent:setSelected(self._tag)
        end
    end
    Button.super._onMouseEnter(self, _)
end

function Button:_onMouseLeave(_)
    self:setPointed(false)
end

function Button:_onMouseDown(_)
    if self._data.IsTab then
        self._parent.showPopupWhenPointed = true
        self._parent:setSelected(self._tag)
    end
    Button.super._onMouseDown(self, _)
end

function Button:tryShowPopupMenu()
    self:hidePopupMenu()
    if self._data.PopupMenu then
        local PopupMenu = require("PopupMenu")
        local wx, wy = self:getPositionInWindow()
        self._subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot(),
                self._data.PopupMenu,
                { wx, wy + self._root.height })
    end
    return self._subPopupMenu
end

function Button:hidePopupMenu()
    self:_destroySubPopupMenu()
end

return Button