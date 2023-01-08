---@class TCE.TreeView:TCE.ScrollContainer
local TreeView = class("TreeView", require("ScrollContainer"))
---@class TCE.TreeViewElement:TCE.ScrollContainer
local TreeViewElement = class("TreeViewElement", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")
local Locale = require("locale.Locale")

function TreeViewElement:__init(root, parent, data, index, level)
    TreeViewElement.super.__init(self, "", parent, nil, data)
    self._index = index
    self._level = level
    self._root = root
    self:_initContent()
end

---@return TCE.TreeElementData
function TreeViewElement:getData()
    return self._data
end

function TreeViewElement:_initContent()
    self:adjustLayout(true)
    self._root:addMousePointedEnterListener({ self._onElementMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
    self._root:addTouchDownListener({ self._onElementClicked, self })
end

function TreeViewElement:adjustLayout(isInitializing, _)
    local data = self:getData()
    ---@type TCE.TreeData
    local treeData = self._parent:getData()

    local arr = UIPanel.cast(self._root:getChild("img_arr"))
    local icon = UIPanel.cast(self._root:getChild("img_icon"))
    local cap = UIText.cast(self._root:getChild("cap"))
    local line = UIText.cast(self._root:getChild("line"))

    local curX = self._level * 10
    local isParentNode = false
    if data:getCanExpand() then
        arr.sprite = UISpritePool.getInstance():get("icon_arr_folded")
        isParentNode = true
    elseif #data:getElements() > 0 then
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
    if data:getIcon() ~= "" then
        iconName = data:getIcon()
    end

    if iconName == nil then
        local iconList = treeData:getIconList()
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

    cap.text = Locale.get(data:getText())
    cap.positionX = curX

    if isInitializing then
        self._root:getChild("sd").visible = false
    end

    self._root:applyMargin(true)
    if isInitializing then
        self:_updateSelectedState(false)
    end
end

function TreeViewElement:_onElementMouseEnter(_, _)
    self:_updateSelectedState(true)
end

function TreeViewElement:_onElementMouseLeave(_, _)
    self:_updateSelectedState(false)
end

function TreeViewElement:_updateSelectedState(pointed)
    UIUtil.setPanelDisplay(self._root, self._index == self._parent:getSelectedIndex(),
            pointed, nil, "A")
end

function TreeViewElement:_onElementClicked(_, _)
    self._parent:setSelected(self._index)
end

function TreeView:__init(name, parent, parentRoot, data, location)
    TreeView.super.__init(self, name, parent, parentRoot, data, {})
    self._mappingList = {}
    self:_initContent(location)
end

function TreeView:onDestroy()
    self._mappingList = {}
    TreeView.super.onDestroy(self)
end

---@return TCE.TreeData
function TreeView:getData()
    return self._data
end

function TreeView:_reloadMappingList()
    self._mappingList = {}
    local data = self:getData()

    ---@param _subData TCE.TreeElementData
    ---@param _level number
    local function _loadRecursively(_subData, _level)
        table.insert(self._mappingList, { _subData, _level })
        for _, _nextData in ipairs(_subData:getElements()) do
            _loadRecursively(_nextData, _level + 1)
        end
    end

    for _, subData in ipairs(data:getElements()) do
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
    local data = mapping[1]
    local level = mapping[2]

    return TreeViewElement.new(node, self, data, index, level)
end

function TreeView:onDataChanged(names)
    --print(self:getData():save())
    if names["elements"] then
        self:adjustLayout(false)
    end
end

return TreeView