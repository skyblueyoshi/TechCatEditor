---@class TCE.TreeView:TCE.ScrollContainer
local TreeView = class("TreeView", require("ScrollContainer"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

--[[
TreeNode：{
    str Text  描述文字
    bool CanExpand  是否可以展开下一层级
    [TreeNode] Children  下一层级所有节点
}
--]]

function TreeView:__init(parent, parentRoot, data, location)
    TreeView.super.__init(self, parent, parentRoot, data, {})
    self._mappingList = {}
    self._selectIndex = 0
    self:_initContent(location)
end

function TreeView:onDestroy()
    self._mappingList = {}
    TreeView.super.onDestroy(self)
end

function TreeView:_loadMappingDataRecursively(data, level)
    table.insert(self._mappingList, { data, level })
    if data.Children then
        for _, subData in ipairs(data.Children) do
            self:_loadMappingDataRecursively(subData, level + 1)
        end
    end
end

function TreeView:_reloadMappingList()
    self._mappingList = {}
    if #self._data.Children > 0 then
        for _, subData in ipairs(self._data.Children) do
            self:_loadMappingDataRecursively(subData, 0)
        end
    end
end

function TreeView:_initContent(location)
    self:_preInitScrollContainer(location)

    self:_reloadMappingList()
    self:_postInitScrollContainer()
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
    local data, level = mapping[1], mapping[2]
    local arr = UIPanel.cast(node:getChild("img_arr"))
    local icon = UIPanel.cast(node:getChild("img_icon"))
    local cap = UIText.cast(node:getChild("cap"))

    local curX = level * 10
    local isParentNode = false
    if data.CanExpand then
        arr.sprite = UISpritePool.getInstance():get("icon_arr_folded")
        isParentNode = true
    elseif data.Children and #data.Children > 0 then
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
    if self._data.IconList and #self._data.IconList >= 2 then
        if isParentNode then
            iconName = self._data.IconList[1]
        else
            iconName = self._data.IconList[2]
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

    cap.text = data.Text
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