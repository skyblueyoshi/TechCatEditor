---@class TCE.Button:TCE.ActivePanel
local Button = class("Button", require("ActivePanel"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

--[[
data格式：
{
    str Text  按钮描述的文字
    PopupMenu PopupMenu  弹出菜单栏数据
}
--]]

function Button:__init(parent, parentRoot, data, location, params)
    Button.super.__init(self, parent, parentRoot, data, location)
    self._subPopupMenu = nil
    self._style = params.style or "None"
    self._tag = params.tag or 0

    if params.selectedColor ~= nil then
        self._selectedColor = params.selectedColor
    end
    if params.pointedColor ~= nil then
        self._pointedColor = params.pointedColor
    end

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
    local curX = Constant.BTN_SIDE_OFFSET
    if data.Icon then
        local img = UIUtil.newPanel(self._root, "icon", { curX, 0, 16, 16 }, {
            layout = "CENTER_H",
        })
        img.sprite = UISpritePool.getInstance():get(data.Icon)
        img.sprite.color = ThemeUtil.getColor("ICON_COLOR")
        curX = curX + img.width + Constant.BTN_SIDE_OFFSET
    end
    if data.Text then
        local text = UIUtil.newText(self._root, "cap", { curX, 0 }, data.Text, {
            layout = "CENTER_H",
        })
        curX = curX + text.width

    end
    curX = curX + Constant.BTN_SIDE_OFFSET
    self._root.width = math.max(self._root.width, curX)

    if self._data.PopupMenu then
        self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
    end

    self._root:applyMargin(true)
end

function Button:_isStyle(name)
    return self._style == name
end

function Button:_onMouseEnter(_)
    if self:_isStyle("Tab") then
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
    if self:_isStyle("Tab") then
        if self._parent.showPopupWhenPointed ~= nil then
            self._parent.showPopupWhenPointed = true
        end
        self._parent:setSelected(self._tag)
    end
    Button.super._onMouseDown(self, _)
end

function Button:tryShowPopupMenu()
    self:hidePopupMenu()
    if self._data.PopupMenu then
        local PopupMenu = require("PopupMenu")
        local wx, wy = self:getPositionInWindow()
        self._subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                self._data.PopupMenu,
                { wx, wy + self._root.height })
    end
    return self._subPopupMenu
end

function Button:hidePopupMenu()
    self:_destroySubPopupMenu()
end

function Button:_onPopupOutsideEvent(_)
    self:hidePopupMenu()
end

return Button