---@class TCE.TreeView:TCE.ScrollContainer
local TreeView = class("TreeView", require("ScrollContainer"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

function TreeView:__init(name, parent, parentRoot, data, location)
    TreeView.super.__init(self, name, parent, parentRoot, data, {})
    self._mappingList = {}
    self._selectIndex = 0
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
        table.insert(self._mappingList, {_subData, _level})
        print("sssssss", _subData:getText())
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

function TreeView:_onCreatePanelItem()
    local panelItem = TreeView.super._onCreatePanelItem(self)
    UIUtil.newPanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    UIUtil.newPanel(panelItem, "img_arr", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    }, false, false)
    UIUtil.newPanel(panelItem, "img_icon", { 0, 0, 16, 16 }, {
        layout = "CENTER_H",
    }, false, false)
    UIUtil.newText(panelItem, "cap", nil, "1", {
        layout = "CENTER_H",
    })

    return panelItem
end

function TreeView:_getTableElementCount()
    return #self._mappingList
end

---_setTableElement
---@param node UINode
---@param index number
function TreeView:_setTableElement(node, index)
    --print("TreeView:_setTableElement", index, node.position, node.size)
    local mapping = self._mappingList[index]
    ---@type TCE.TreeElementData
    local data = mapping[1]
    local level = mapping[2]
    local treeData = self:getData()

    local arr = UIPanel.cast(node:getChild("img_arr"))
    local icon = UIPanel.cast(node:getChild("img_icon"))
    local cap = UIText.cast(node:getChild("cap"))

    local curX = level * 10
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
    local iconList = treeData:getIconList()
    if #iconList >= 2 then
        if isParentNode then
            iconName = iconList[1]
        else
            iconName = iconList[2]
        end
    end

    if iconName ~= nil then
        icon.sprite = UISpritePool.getInstance():get(iconName)
        icon.sprite.color = ThemeUtil.getColor("ICON_COLOR")
        icon.visible = true
        icon.positionX = curX
        curX = curX + 16
    else
        icon.visible = false
    end
    curX = curX + 2

    cap.text = data:getText()
    cap.positionX = curX

    node:getChild("sd").visible = false

    node:applyMargin(true)
    node:addMousePointedEnterListener({ self._onElementMouseEnter, self })
    node:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
    node:addTouchDownListener({ self._onElementClicked, self })

    --local treeNode = TreeNode.new(self, node, {}, {0,0})
    UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
end

function TreeView:setSelected(index)
    if self._selectIndex == index then
        return
    end
    self._selectIndex = index
    local nodes = UIUtil.getAllValidElements(self._sv)
    for _, node in ipairs(nodes) do
        UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
    end
end

function TreeView:_onElementMouseEnter(node, _)
    local index = node.tag
    UIUtil.setPanelDisplay(node, index == self._selectIndex, true, nil, "A")
end

function TreeView:_onElementMouseLeave(node, _)
    local index = node.tag
    UIUtil.setPanelDisplay(node, index == self._selectIndex, false, nil, "A")
end

function TreeView:_onElementClicked(node, _)
    local index = node.tag
    self:setSelected(index)
end

return TreeView