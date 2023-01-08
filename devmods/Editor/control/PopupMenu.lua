---@class TCE.PopupMenuElement:TCE.BaseControl
local PopupMenuElement = class("PopupMenuElement", require("BaseControl"))
---@class TCE.PopupMenu:TCE.BaseControl
local PopupMenu = class("PopupMenu", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")
local UISpritePool = require("core.UISpritePool")
local Locale = require("locale.Locale")

local RIGHT_RESERVE_SIZE = 16
local HK_RESERVE_SIZE = 32

function PopupMenuElement:__init(name, parent, parentRoot, data, location, index)
    PopupMenuElement.super.__init(self, name, parent, parentRoot, data)
    self._index = index
    self:_initContent(location)
end

---@return TCE.PopupMenuElementData
function PopupMenuElement:getData()
    return self._data
end

function PopupMenuElement:_initContent(location)
    self:adjustLayout(true, { location[1], location[2], Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT })
    self._root:addMousePointedEnterListener({ self._onPointedIn, self })
    self._root:addTouchDownListener({ self._onClicked, self })
end

function PopupMenuElement:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location)

    local data = self:getData()
    local text = data:getText()
    local icon = data:getIcon()

    local selectBg = UIUtil.ensurePanel(self._root, "sd", nil, {
        margins = { 3, 3, 3, 3, true, true },
        bgColor = "SD",
    }, false, false)
    if isInitializing then
        selectBg.visible = false
    end

    local rx = 16

    if icon ~= "" then
        rx = 8
        local img = UIUtil.ensurePanel(self._root, "icon", { rx, 0, 16, 16 }, {
            layout = "CENTER_H",
        }, false, false)
        img.sprite = UISpritePool.getInstance():get(icon)
        rx = rx + img.width + 4
    end

    local lbText = UIUtil.ensureText(self._root, "cap", { rx, 0 }, Locale.get(text), {
        margins = { nil, 0, nil, 0, false, false },
    })
    rx = rx + lbText.width

    local hotkeys = data:getHotKeys()
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
        local hkText = UIUtil.ensureText(self._root, "hk", { rx, 0 }, hkContent, {
            margins = { nil, 0, nil, 0, false, false },
        })
        rx = rx + hkText.width
    end

    self._root.width = rx + RIGHT_RESERVE_SIZE
end

function PopupMenuElement:adjustWidth(newWidth)
    self._root.width = newWidth
    local hkText = self._root:getChild("hk")
    if hkText:valid() then
        hkText.positionX = self._root.width - RIGHT_RESERVE_SIZE - hkText.width
    end
end

function PopupMenuElement:_onPointedIn(_)
    self._parent:clearSelect()
    self._parent:setSelect(self._index)
end

function PopupMenuElement:_onClicked(_, _)
    self._parent:onElementClicked(self._index)
end

function PopupMenuElement:setSelect(selected)
    UIUtil.setPanelDisplay(self._root, selected, false)
end

function PopupMenuElement:tryShowSubPopupMenu()
    local data = self:getData()
    local parent = self._parent
    local popupMenu = data:getPopupMenu()
    if popupMenu ~= nil then
        local posInWindowX, posInWindowY = self:getPositionInWindow()

        local subPopupMenu = PopupMenu.new("pop", self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                popupMenu,
                { posInWindowX + self._root.width, posInWindowY },
                parent:getLevel() + 1)
        return subPopupMenu
    end
    return nil
end

function PopupMenuElement:onDataChanged(names)
    self._parent:onChildElementDataChanged(names)
end

function PopupMenu:__init(name, parent, parentRoot, data, location, level, params)
    PopupMenu.super.__init(self, name, parent, parentRoot, data)
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

function PopupMenu:onDestroy()
    self:_destroySubPopupMenu()
    PopupMenu.super.onDestroy(self)
end

function PopupMenu:_destroySubPopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

---@return TCE.PopupMenuData
function PopupMenu:getData()
    return self._data
end

function PopupMenu:_initContent(location)
    self:adjustLayout(true, { location[1], location[2] })
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
end

function PopupMenu:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot,
            self._name, location, {
                bgColor = "A",
                borderColor = "BD",
            }, true)
    self:_reloadAllChildren()
end

function PopupMenu:_reloadAllChildren()
    self:removeAllChildren()

    local data = self:getData()
    local elements = data:getElements()
    local offsetY = 0
    for idx, elementData in ipairs(elements) do
        local element = PopupMenuElement.new("e_" .. tostring(idx), self, self._root, elementData, { 0, offsetY }, idx)
        offsetY = offsetY + element:getRoot().height
        self:addChild(element)
    end
    self:_adjustChildrenLayout()
end

function PopupMenu:_adjustChildrenLayout()
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

function PopupMenu:_onMouseLeave(_)
    self:clearSelect()
end

function PopupMenu:clearSelect()
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
function PopupMenu:getSelectBg(idx)
    return self._elements[idx]:getChild("sd")
end

function PopupMenu:setSelect(idx)
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

function PopupMenu:getLevel()
    return self._level
end

function PopupMenu:onElementClicked(index)
    if self._clickCallback then
        self._clickCallback[1](self._clickCallback[2], index)
    end
    self:triggerEvent(EventDef.ALL_POPUP_CLOSE)
end

function PopupMenu:onChildElementDataChanged(names)
    self:_destroySubPopupMenu()
    self:_adjustChildrenLayout()
end

function PopupMenu:onDataChanged(names)
    if names["elements"] then
        self:adjustLayout(false)
    end
end

return PopupMenu