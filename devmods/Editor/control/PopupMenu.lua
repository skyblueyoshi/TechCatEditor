---@class TCE.PopupMenu
local PopupMenu = class("PopupMenu")
local UIFactory = require("core.UIFactory")

---__init
---@param parent UINode
---@param dataList table
function PopupMenu:__init(parent, config, dataList, location, level)
    self._parent = parent
    self._root = nil ---@type:UINode
    self._config = config
    self._dataList = dataList
    self._level = level

    self._elements = {}
    self._elementHeight = 30
    self._elementRightReserveSize = 16
    self._elementToHotkeysReserveSize = 32
    self._selectedIdx = 0
    self._subPopupMenu = nil

    self:_initContent(location)
end

function PopupMenu:destroy()
    self:_destroySubPopupMenu()
    self._parent:removeChild(self._root)

    self._parent = nil
    self._root = nil
end

function PopupMenu:_initContent(location)
    self._root = UIFactory.newPanel(self._parent, "popup", { location[1], location[2] }, {
        bgColor = "A",
        borderColor = "BD",
    })

    local offsetY = 0
    local maxWidth = 0
    for idx, data in ipairs(self._dataList) do
        local elementPanel = self:_makeElementPanel(idx, data, offsetY)
        offsetY = offsetY + elementPanel.height
        maxWidth = math.max(maxWidth, elementPanel.width)
        table.insert(self._elements, elementPanel)
    end
    self._root.height = offsetY
    self._root.width = maxWidth
    for _, element in ipairs(self._elements) do
        self:_fixElementPanel(element, maxWidth)
    end
    self._root:applyMargin(true)
    self._root:addMousePointedLeaveListener({ self._onMouseLeave, self })
end

function PopupMenu:_makeElementPanel(idx, data, posY)
    local elementPanel = UIFactory.newPanel(self._root, string.format("e_%d", idx),
            { 0, posY, 32, self._elementHeight })

    if data.Text ~= nil then
        local selectBg = UIFactory.newPanel(elementPanel, "sel", nil, {
            margins = { 3, 3, 3, 3, true, true },
            bgColor = "SD",
        })
        selectBg.visible = false

        local rx = 16
        local text = UIFactory.newText(elementPanel, "cap", { rx, 0 }, data.Text, {
            margins = { nil, 0, nil, 0, false, false },
        })
        rx = rx + text.width

        if data.HotKeys ~= nil then
            rx = rx + self._elementToHotkeysReserveSize
            local hkContent = ""
            for i, hk in ipairs(data.HotKeys) do
                if i == 1 then
                    hkContent = hk
                else
                    hkContent = hkContent .. "+" .. hk
                end
            end
            local hkText = UIFactory.newText(elementPanel, "hk", { rx, 0 }, hkContent, {
                margins = { nil, 0, nil, 0, false, false },
            })
            rx = rx + hkText.width
        end

        elementPanel.width = rx + self._elementRightReserveSize
        elementPanel.tag = idx
        elementPanel:addMousePointedEnterListener({ self._onElementPointedIn, self })

    end

    return elementPanel
end

---_fixElementPanel
---@param elementPanel UINode
---@param width number
function PopupMenu:_fixElementPanel(elementPanel, width)
    elementPanel.width = width
    local hkText = elementPanel:getChild("hk")
    if hkText:valid() then
        hkText.positionX = elementPanel.width - self._elementRightReserveSize - hkText.width
    end
end

function PopupMenu:_onMouseLeave(_)
    self:clearSelect()
end

function PopupMenu:_onElementPointedIn(elementPanel)
    self:clearSelect()
    self:setSelect(elementPanel.tag)
end

function PopupMenu:clearSelect()
    if self._selectedIdx ~= 0 then
        local selectBg = self:getSelectBg(self._selectedIdx)
        selectBg.visible = false
        self:_destroySubPopupMenu()
    end
    self._selectedIdx = 0
end

---getSelectBg
---@param idx number
---@return UINode
function PopupMenu:getSelectBg(idx)
    return self._elements[idx]:getChild("sel")
end

function PopupMenu:setSelect(idx)
    if self._selectedIdx == idx then
        return
    end
    self:clearSelect()
    if idx == 0 then
        return
    end
    self._selectedIdx = idx
    local selectBg = self:getSelectBg(self._selectedIdx)
    selectBg.visible = true

    local data = self._dataList[idx]
    if data.Children and #data.Children > 0 then
        local elementLocation = { self._root.positionX + self._root.width, self._root.positionY + self._elements[idx].positionY }
        self._subPopupMenu = PopupMenu.new(self._parent,
                self._config, data.Children,
                elementLocation,
                self._level + 1)
    end
end

function PopupMenu:_destroySubPopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

return PopupMenu