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

function MenuBar:_initContent(location)
    local x, y = location[1], location[2]
    local name = "menu_bar"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 0, Constant.DEFAULT_BAR_HEIGHT }, {
                layout = "FULL_W",
                bgColor = "B",
                --borderColor = "A",
            }, true)

    local tt = UIUtil.newPanel(self._root, "pp", {0,0,32,32})
    local UISpritePool = require("core.UISpritePool")
    local textureLocation = UISpritePool.getInstance():get("icon_go").textureLocation
    local textureLocation2 = UISpritePool.getInstance():get("white").textureLocation
    local sourceRect = TextureManager.getSourceRect(textureLocation)
    local offset = Vector2.new(180, 16)
    tt:getPostDrawLayer(0):addListener(function()
        --Sprite.draw(textureLocation2, offset, sourceRect, Color.Green, 0)
        --Sprite.draw(textureLocation, offset, sourceRect, Color.Blue, 0)
    end)

    if self._data.Children then
        local elementX, elementY = 0, 0
        for idx, data in ipairs(self._data.Children) do
            local elementLocation = { elementX, elementY, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }
            local tab = Button.new(self, self._root, data, elementLocation, { tag = idx, style = "Tab" })
            elementX = elementX + tab:getRoot().width
            self:addChild(tab)
        end
    end
    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
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

return MenuBar