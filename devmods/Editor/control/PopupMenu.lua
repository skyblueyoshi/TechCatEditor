---@class TCE.PopupMenu:TCE.BaseControl
local PopupMenu = class("PopupMenu", require("BaseControl"))
local UIFactory = require("core.UIFactory")
local PopupMenuElement = require("PopupMenuElement")

---__init
---
function PopupMenu:__init(parent, data, location, level)
    PopupMenu.super.__init(self, parent, data)
    self._level = level or 0

    self._selectedIndex = 0
    self._subPopupMenu = nil

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
    self._root = UIFactory.newPanel(self._parent:getRoot(),
            "popup", { location[1], location[2] }, {
                bgColor = "A",
                borderColor = "BD",
            }, true)

    local offsetY = 0
    local maxWidth = 0
    for idx, data in ipairs(self._data) do
        local element = PopupMenuElement.new(self, data, { 0, offsetY }, idx)
        offsetY = offsetY + element:getRoot().height
        maxWidth = math.max(maxWidth, element:getRoot().width)
        self:addChild(element)
    end
    self._root.height = offsetY
    self._root.width = maxWidth

    for _, child in ipairs(self._children) do
        child:fixWidth(maxWidth)
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

return PopupMenu