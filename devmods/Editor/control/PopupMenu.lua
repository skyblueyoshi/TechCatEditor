---@class TCE.PopupMenuElement:TCE.BaseControl
local PopupMenuElement = class("PopupMenuElement", require("BaseControl"))
local PopupMenu = class("PopupMenu", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local EventDef = require("config.EventDef")

local RIGHT_RESERVE_SIZE = 16
local HK_RESERVE_SIZE = 32

--[[
PopupMenuElement：{
    str Text  描述文字
    [str] HotKeys  快捷方式
    [PopupMenu] Children  下一项菜单栏
}

PopupMenu -> [PopupMenuElement]
--]]

function PopupMenuElement:__init(parent, parentRoot, data, location, index)
    PopupMenuElement.super.__init(self, parent, parentRoot, data)
    self._index = index
    self:_initContent(location)
end

function PopupMenuElement:_initContent(location)
    self._root = UIUtil.newPanel(self._parentRoot,
            string.format("e_%d", self._index),
            { location[1], location[2], Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT })

    if self._data.Text ~= nil then
        local selectBg = UIUtil.newPanel(self._root, "sd", nil, {
            margins = { 3, 3, 3, 3, true, true },
            bgColor = "SD",
        }, false, false)
        selectBg.visible = false

        local rx = 16
        local text = UIUtil.newText(self._root, "cap", { rx, 0 }, self._data.Text, {
            margins = { nil, 0, nil, 0, false, false },
        })
        rx = rx + text.width

        if self._data.HotKeys ~= nil then
            rx = rx + HK_RESERVE_SIZE
            local hkContent = ""
            for i, hk in ipairs(self._data.HotKeys) do
                if i == 1 then
                    hkContent = hk
                else
                    hkContent = hkContent .. "+" .. hk
                end
            end
            local hkText = UIUtil.newText(self._root, "hk", { rx, 0 }, hkContent, {
                margins = { nil, 0, nil, 0, false, false },
            })
            rx = rx + hkText.width
        end

        self._root.width = rx + RIGHT_RESERVE_SIZE
        self._root:addMousePointedEnterListener({ self._onPointedIn, self })
        self._root:addTouchDownListener({ self._onClicked, self })

    end

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
    local data = self._data
    local parent = self._parent
    if data.Children and #data.Children > 0 then
        local posInWindowX, posInWindowY = self:getPositionInWindow()

        local PopupMenu = require("PopupMenu")
        local subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                data.Children,
                { posInWindowX + self._root.width, posInWindowY },
                parent:getLevel() + 1)
        return subPopupMenu
    end
    return nil
end

function PopupMenu:__init(parent, parentRoot, data, location, level, params)
    PopupMenu.super.__init(self, parent, parentRoot, data)
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

function PopupMenu:_initContent(location)
    self._root = UIUtil.newPanel(self._parentRoot,
            "popup", { location[1], location[2] }, {
                bgColor = "A",
                borderColor = "BD",
            }, true)

    local offsetY = 0
    local maxWidth = 0
    if self._fixWidth then
        maxWidth = self._fixWidth
    end
    for idx, data in ipairs(self._data) do
        local element = PopupMenuElement.new(self, self._root, data, { 0, offsetY }, idx)
        offsetY = offsetY + element:getRoot().height
        if not self._fixWidth then
            maxWidth = math.max(maxWidth, element:getRoot().width)
        end
        self:addChild(element)
    end
    self._root.height = offsetY
    self._root.width = maxWidth

    for _, child in ipairs(self._children) do
        child:adjustWidth(maxWidth)
    end

    self._root:applyMargin(true)
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
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

return PopupMenu