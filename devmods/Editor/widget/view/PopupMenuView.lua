---@class TCE.PopupMenuElementView:TCE.BaseView
local PopupMenuElementView = class("PopupMenuElementView", require("BaseView"))
---@class TCE.PopupMenuView:TCE.BaseView
local PopupMenuView = class("PopupMenuView", require("BaseView"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local Locale = require("locale.Locale")

local RIGHT_RESERVE_SIZE = 16
local HK_RESERVE_SIZE = 32

local POPUP_SUB_KEY = "pop_sub"

function PopupMenuElementView:__init(key, widget, parent, parentRoot, location, index)
    PopupMenuElementView.super.__init(self, key, widget, parent, parentRoot)
    self._index = index
    self:_initContent(location)
end

---@return TCE.PopupMenuElement
function PopupMenuElementView:getWidget()
    return self._widget
end

function PopupMenuElementView:_initContent(location)
    self:adjustLayout(true, { location[1], location[2], Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT })
    self._root:addMousePointedEnterListener({ self._onPointedIn, self })
    self._root:addTouchDownListener({ self._onClicked, self })
end

function PopupMenuElementView:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location)

    local widget = self:getWidget()
    local text = widget:getText()
    local icon = widget:getIcon()

    local selectBg = UIUtil.ensurePanel(self._root, "sd", nil, { margins = { 3, 3, 3, 3, true, true }, bgColor = "SD", }, false, false)
    if isInitializing then
        selectBg.visible = false
    end

    local rx = 16

    if icon ~= "" then
        rx = 8
        local img = UIUtil.ensurePanel(self._root, "icon", { rx, 0, 16, 16 },
                { layout = "CENTER_H", }, false, false)
        img.sprite = UISpritePool.getInstance():get(icon)
        rx = rx + img.width + 4
    end

    local lbText = UIUtil.ensureText(self._root, "cap", { rx, 0 }, Locale.get(text),
            { margins = { nil, 0, nil, 0, false, false }, })
    rx = rx + lbText.width

    local hotkeys = widget:getHotKeys()
    if hotkeys ~= "" then
        rx = rx + HK_RESERVE_SIZE
        local hkContent = ""
        for i, hk in ipairs(hotkeys) do
            if i == 1 then
                hkContent = hk
            else
                hkContent = hkContent .. "+" .. hk
            end
        end
        local hkText = UIUtil.ensureText(self._root, "hk", { rx, 0 }, hkContent,
                { margins = { nil, 0, nil, 0, false, false }, })
        rx = rx + hkText.width
    end

    self._root.width = rx + RIGHT_RESERVE_SIZE
end

function PopupMenuElementView:adjustWidth(newWidth)
    self._root.width = newWidth
    local hkText = self._root:getChild("hk")
    if hkText:valid() then
        hkText.positionX = self._root.width - RIGHT_RESERVE_SIZE - hkText.width
    end
end

function PopupMenuElementView:_onPointedIn(_)
    self._parent:clearSelect()
    self._parent:setSelect(self._index)
end

function PopupMenuElementView:_onClicked(_, _)
    self._parent:onElementClicked(self._index)
end

function PopupMenuElementView:setSelect(selected)
    UIUtil.setPanelDisplay(self._root, selected, false)
end

function PopupMenuElementView:tryShowSubPopupMenu()
    local widget = self:getWidget()
    local parent = self._parent
    local popupMenu = widget:getPopupMenu()
    if popupMenu ~= nil then
        local posInWindowX, posInWindowY = self:getPositionInWindow()
        local subPopupMenu = PopupMenuView.new(POPUP_SUB_KEY, popupMenu, self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                { posInWindowX + self._root.width, posInWindowY }, parent:getLevel() + 1)
        return subPopupMenu
    end
    return nil
end

function PopupMenuElementView:onNotifyChanges(_, names)
    self._parent:onChildElementDataChanged(names)
end

function PopupMenuView:__init(key, widget, parent, parentRoot, location, level, params)
    PopupMenuView.super.__init(self, key, widget, parent, parentRoot)
    self._level = level or 0

    self._selectedIndex = 0
    self._subPopupMenu = nil
    self._fixWidth = location[3]

    self._clickCallback = nil
    if params then
        if params.clickCallback then
            self._clickCallback = params.clickCallback
        end
    end

    self:_initContent(location)
end

function PopupMenuView:_onDestroy()
    self:_destroySubPopupMenu()
    PopupMenuView.super._onDestroy(self)
end

function PopupMenuView:_destroySubPopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

---@return TCE.PopupMenu
function PopupMenuView:getWidget()
    return self._widget
end

function PopupMenuView:_initContent(location)
    self:adjustLayout(true, { location[1], location[2] })
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
end

function PopupMenuView:adjustLayout(_, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, { bgColor = "A", borderColor = "BD", }, true)
    self:_reloadAllChildren()
end

function PopupMenuView:_reloadAllChildren()
    self:removeAllChildren()

    local widget = self:getWidget()
    local elements = widget:getElements()
    local offsetY = 0
    for idx, widgetChild in ipairs(elements) do
        local element = PopupMenuElementView.new(idx, widgetChild, self, nil, { 0, offsetY }, idx)
        offsetY = offsetY + element:getRoot().height
    end
    self:_adjustChildrenLayout()
end

function PopupMenuView:_adjustChildrenLayout()
    local offsetY = 0
    local maxWidth = 0
    if self._fixWidth then
        maxWidth = self._fixWidth
    end
    for _, child in ipairs(self._children) do
        child:adjustLayout()
        offsetY = offsetY + child:getRoot().height
        if not self._fixWidth then
            maxWidth = math.max(maxWidth, child:getRoot().width)
        end
    end
    self._root.height = offsetY
    self._root.width = maxWidth

    for _, child in ipairs(self._children) do
        child:adjustWidth(maxWidth)
    end
    self._root:applyMargin(true)
end

function PopupMenuView:_onMouseLeave(_)
    self:clearSelect()
end

function PopupMenuView:clearSelect()
    if self._selectedIndex ~= 0 then
        local element = self._children[self._selectedIndex]
        element:setSelect(false)
        self:_destroySubPopupMenu()
    end
    self._selectedIndex = 0
end

---getSelectBg
---@param idx number
---@return UINode
function PopupMenuView:getSelectBg(idx)
    return self._elements[idx]:getChild("sd")
end

function PopupMenuView:setSelect(idx)
    if self._selectedIndex == idx then
        return
    end
    self:clearSelect()
    if idx == 0 then
        return
    end
    self._selectedIndex = idx
    local element = self._children[self._selectedIndex]
    element:setSelect(true)
    self._subPopupMenu = element:tryShowSubPopupMenu()
end

function PopupMenuView:getLevel()
    return self._level
end

function PopupMenuView:onElementClicked(index)
    if self._clickCallback then
        self._clickCallback[1](self._clickCallback[2], index)
    end
    self:triggerEvent(EventDef.ALL_POPUP_CLOSE)
end

function PopupMenuView:onChildElementDataChanged(names)
    self:_destroySubPopupMenu()
    self:_adjustChildrenLayout()
end

function PopupMenuView:onNotifyChanges(_, names)
    if names["elements"] then
        self:adjustLayout(false)
    end
end

return PopupMenuView