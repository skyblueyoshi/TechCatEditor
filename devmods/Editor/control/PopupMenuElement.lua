---@class TCE.PopupMenuElement:TCE.BaseControl
local PopupMenuElement = class("PopupMenuElement", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

local RIGHT_RESERVE_SIZE = 16
local HK_RESERVE_SIZE = 32

---__init
---
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
        })
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

    end

end

function PopupMenuElement:fixWidth(newWidth)
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

function PopupMenuElement:setSelect(selected)
    UIUtil.setPanelDisplay(self._root, selected, false)
end

function PopupMenuElement:tryShowSubPopupMenu()
    local data = self._data
    local parent = self._parent
    if data.Children and #data.Children > 0 then
        local posInWindowX, posInWindowY = self:getPositionInWindow()

        local PopupMenu = require("PopupMenu")
        local subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot(),
                data.Children,
                { posInWindowX + self._root.width, posInWindowY },
                parent:getLevel() + 1)
        return subPopupMenu
    end
    return nil
end

return PopupMenuElement