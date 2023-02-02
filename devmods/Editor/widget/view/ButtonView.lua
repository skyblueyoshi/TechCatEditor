---@class TCE.ButtonView:TCE.ActivePanelView
local ButtonView = class("ButtonView", require("ActivePanelView"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local Locale = require("locale.Locale")
local CmdPool = require("command.CmdPool")

local POPUP_KEY = "pop"

function ButtonView:__init(key, widget, parent, parentRoot, location, params)
    ButtonView.super.__init(self, key, widget, parent, parentRoot)
    self._style = params.style or "None"
    self._tag = params.tag or 0

    if params.selectedColor ~= nil then
        self._selectedColor = params.selectedColor
    end
    if params.pointedColor ~= nil then
        self._pointedColor = params.pointedColor
    end
    self._subPopupMenu = nil

    self:_initContent(location)
end

function ButtonView:_onDestroy()
    self:hidePopupMenu()
    ButtonView.super._onDestroy(self)
end

---@return TCE.Button
function ButtonView:getWidget()
    return self._widget
end

function ButtonView:_initContent(location)
    ButtonView.super._initContent(self, location)
    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function ButtonView:adjustLayout(isInitializing, location)
    ButtonView.super.adjustLayout(self, isInitializing, location)

    local widget = self:getWidget()
    local icon = widget:getIcon()
    local text = widget:getText()

    local curX = Constant.BTN_SIDE_OFFSET
    if icon ~= "" then
        local img = UIUtil.ensurePanel(self._root, "icon", { curX, 0, 16, 16 }, { layout = "CENTER_H", }, false, false)
        img.sprite = UISpritePool.getInstance():get(icon)
        curX = curX + img.width + Constant.BTN_SIDE_OFFSET
    end
    if text ~= "" then
        local lbText = UIUtil.ensureText(self._root, "cap", { curX, 0 }, Locale.get(text), { layout = "CENTER_H", })
        curX = curX + lbText.width
    end
    curX = curX + Constant.BTN_SIDE_OFFSET
    self._root.width = math.max(self._root.width, curX)

    self._root:applyMargin(true)
end

function ButtonView:_isStyle(name)
    return self._style == name
end

function ButtonView:_onMouseEnter(_)
    if self:_isStyle("Tab") then
        if self._parent.showPopupWhenPointed then
            self._parent:setSelected(self._tag)
        end
    end
    ButtonView.super._onMouseEnter(self, _)
end

function ButtonView:_onMouseLeave(_)
    self:setPointed(false)
end

function ButtonView:_onMouseDown(_)
    if self:_isStyle("Tab") then
        if self._parent.showPopupWhenPointed ~= nil then
            self._parent.showPopupWhenPointed = true
        end
        self._parent:setSelected(self._tag)
    end
    ButtonView.super._onMouseDown(self, _)
    CmdPool.runCmdFromView(self, self:getWidget(), self:getWidget():getClickCallback())
end

function ButtonView:tryShowPopupMenu()
    self:hidePopupMenu()
    local data = self:getWidget()
    local popupMenuData = data:getPopupMenu()
    if popupMenuData ~= nil then
        local PopupMenuView = require("PopupMenuView")
        local wx, wy = self:getPositionInWindow()
        local location = { wx, wy + self._root.height }
        self._subPopupMenu = PopupMenuView.new(POPUP_KEY, popupMenuData, self:getWindow(), self:getWindow():getRoot():getChild("popup_area"), location)
    end
end

function ButtonView:hidePopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

function ButtonView:_onPopupOutsideEvent(_)
    self:hidePopupMenu()
end

function ButtonView:onNotifyChanges(_, names)
    if names["popupMenu"] then
        self:hidePopupMenu()
    end
    self:adjustLayout(false)
    self:requestParentChangeLayout(nil)
end

return ButtonView