---@class TCE.TreeView:TCE.ScrollContainerView
local TreeView = class("TreeView", require("ScrollContainerView"))
---@class TCE.TreeElementView:TCE.BaseView
local TreeElementView = class("TreeViewElement", require("BaseView"))
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")
local Locale = require("locale.Locale")

function TreeElementView:__init(root, index, widget, parent, level)
    TreeElementView.super.__init(self, index, widget, parent, "None")
    self._index = index
    self._level = level
    self._root = root
    self:_initContent()
end

---@return TCE.TreeElement
function TreeElementView:getWidget()
    return self._widget
end

function TreeElementView:_initContent()
    self:adjustLayout(true)
    self._root:addMousePointedEnterListener({ self._onElementMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
    self._root:addTouchDownListener({ self._onElementClicked, self })
end

function TreeElementView:adjustLayout(isInitializing, _)
    local widget = self:getWidget()
    ---@type TCE.Tree
    local treeWidget = self._parent:getWidget()

    local arr = UIPanel.cast(self._root:getChild("img_arr"))
    local icon = UIPanel.cast(self._root:getChild("img_icon"))
    local cap = UIText.cast(self._root:getChild("cap"))
    local line = UIText.cast(self._root:getChild("line"))

    local curX = self._level * 10
    local isParentNode = false
    if widget:getCanExpand() then
        arr.sprite = UISpritePool.getInstance():get("icon_arr_folded")
        isParentNode = true
    elseif #widget:getElements() > 0 then
        arr.sprite = UISpritePool.getInstance():get("icon_arr_unfolded")
        isParentNode = true
    end
    if isParentNode then
        arr.sprite.color = ThemeUtil.getColor("ICON_COLOR")
    end
    arr.visible = isParentNode
    arr.positionX = curX
    curX = curX + 16

    local iconName
    if widget:getIcon() ~= "" then
        iconName = widget:getIcon()
    end

    if iconName == nil then
        local iconList = treeWidget:getIconList()
        if #iconList >= 2 then
            if isParentNode then
                iconName = iconList[1]
            else
                iconName = iconList[2]
            end
        end
    end

    line:setLeftMargin(curX, true)
    if iconName ~= nil then
        icon.sprite = UISpritePool.getInstance():get(iconName)
        icon.visible = true
        icon.positionX = curX
        curX = curX + 16
    else
        icon.visible = false
    end
    curX = curX + 2

    cap.text = Locale.get(widget:getText())
    cap.positionX = curX

    if isInitializing then
        self._root:getChild("sd").visible = false
    end

    self._root:applyMargin(true)
    if isInitializing then
        self:_updateSelectedState(false)
    end
end

function TreeElementView:_onElementMouseEnter(_, _)
    self:_updateSelectedState(true)
end

function TreeElementView:_onElementMouseLeave(_, _)
    self:_updateSelectedState(false)
end

function TreeElementView:_updateSelectedState(pointed)
    UIUtil.setPanelDisplay(self._root, self._index == self._parent:getSelectedIndex(),
            pointed, nil, "A")
end

function TreeElementView:_onElementClicked(_, _)
    self._parent:setSelected(self._index)
end

function TreeView:__init(key, widget, parent, parentRoot, location)
    TreeView.super.__init(self, key, widget, parent, parentRoot, {})
    self._mappingList = {}
    self:_initContent(location)
end

function TreeView:_onDestroy()
    self._mappingList = {}
    TreeView.super._onDestroy(self)
end

---@return TCE.TreeData
function TreeView:getWidget()
    return self._widget
end

function TreeView:_reloadMappingList()
    self._mappingList = {}
    local widget = self:getWidget()

    ---@param _subData TCE.TreeElementData
    ---@param _level number
    local function _loadRecursively(_subData, _level)
        table.insert(self._mappingList, { _subData, _level })
        for _, _nextData in ipairs(_subData:getElements()) do
            _loadRecursively(_nextData, _level + 1)
        end
    end

    for _, subData in ipairs(widget:getElements()) do
        _loadRecursively(subData, 0)
    end
end

function TreeView:_initContent(location)
    self:adjustLayout(true, { location[1], location[2], 200, 400 })
end

function TreeView:adjustLayout(isInitializing, location)
    self:_adjustLayoutBegin(isInitializing, location)
    self:_reloadMappingList()
    self:_adjustLayoutEnd(isInitializing)
end

function TreeView:_onEnsurePanelItem()
    local panelItem = TreeView.super._onEnsurePanelItem(self)
    UIUtil.ensurePanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    UIUtil.ensurePanel(panelItem, "img_arr", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    }, false, false)
    UIUtil.ensurePanel(panelItem, "img_icon", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    }, false, false)
    UIUtil.ensureText(panelItem, "cap", nil, "1", {
        layout = "CENTER_H",
    })
    UIUtil.ensurePanel(panelItem, "line", { 0, 0, 32, 1 }, {
        margins = { 0, nil, 8, 0, true, false },
        bgColor = Color.new(255, 255, 255, 24),
    }, false, false)

    return panelItem
end

function TreeView:_getTableElementCount()
    return #self._mappingList
end

function TreeView:_onCreateElement(node, index)
    local mapping = self._mappingList[index]
    local widget = mapping[1]
    local level = mapping[2]

    return TreeElementView.new(node, index, widget, self, level)
end

function TreeView:onNotifyChanges(_, names)
    if names["elements"] then
        self:adjustLayout(false)
    end
end

return TreeView