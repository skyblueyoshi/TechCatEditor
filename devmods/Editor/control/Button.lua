---@class TCE.Button:TCE.ActivePanel
local Button = class("Button", require("ActivePanel"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

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

---@return TCE.ButtonData
function Button:getData()
    return self._data
end

function Button:_initContent(location)
    Button.super._initContent(self, location)
    self:_adjustLayout()
    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function Button:_adjustLayout()
    local data = self:getData()
    local icon = data:getIcon()
    local text = data:getText()

    local curX = Constant.BTN_SIDE_OFFSET
    if icon ~= "" then
        local img = UIUtil.ensurePanel(self._root, "icon", { curX, 0, 16, 16 }, {
            layout = "CENTER_H",
        })
        img.sprite = UISpritePool.getInstance():get(icon)
        img.sprite.color = ThemeUtil.getColor("ICON_COLOR")
        curX = curX + img.width + Constant.BTN_SIDE_OFFSET
    end
    if text ~= "" then
        local lbText = UIUtil.ensureText(self._root, "cap", { curX, 0 }, text, {
            layout = "CENTER_H",
        })
        curX = curX + lbText.width
    end
    curX = curX + Constant.BTN_SIDE_OFFSET
    self._root.width = math.max(self._root.width, curX)

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
    local data = self:getData()
    local popupMenuData = data:getPopupMenu()
    if popupMenuData ~= nil then
        local PopupMenu = require("PopupMenu")
        local wx, wy = self:getPositionInWindow()
        self._subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                popupMenuData,
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

function Button:onDataChanged(names)
    if names["popupMenu"] then
        self:hidePopupMenu()
    end
    self:_adjustLayout()
    self:requestParentChangeLayout(nil)
end

return Button