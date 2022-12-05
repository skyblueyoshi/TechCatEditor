---@class TCE.TreeView:TCE.BaseControl
local TreeView = class("TreeView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local ScrollBar = require("ScrollBar")

--[[
TreeNode：{
    str Text  描述文字
    bool CanExpand  是否可以展开下一层级
    [TreeNode] Children  下一层级所有节点
}
--]]

function TreeView:__init(parent, parentRoot, data, location)
    TreeView.super.__init(self, parent, parentRoot, data)
    self._sv = nil
    self._mappingList = {}
    self._selectIndex = 0
    self._scrollBar = nil  ---@type TCE.ScrollBar
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
    if #self._data > 0 then
        for _, subData in ipairs(self._data) do
            self:_loadMappingDataRecursively(subData, 0)
        end
    end
end

function TreeView:_initContent(location)
    local x, y = location[1], location[2]
    local name = "tree"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 200, 400 }, {
                layout = "FULL",
                bgColor = "A",
            }, true)
    self._sv = UIScrollView.new("panel_list", 0, 0, 200, 333)
    UIUtil.setMargins(self._sv, 0, 0, 0, 0, true, true)
    self._root:addChild(self._sv)

    local panelItem = UIUtil.newPanel(self._sv, "panel_item",
            { x, y, 200, Constant.DEFAULT_ELEMENT_HEIGHT }, {
                bgColor = "B",
            }, false)
    UIUtil.newPanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    local text = UIUtil.newText(panelItem, "cap", nil, "1", {
        layout = "CENTER_H",
    })
    self:_reloadMappingList()
    self._sv:applyMargin(true)
    UIUtil.createTableView(self._sv, self, true, {
        isItemFillWidth = true,
    })

    self._scrollBar = ScrollBar.new(self, self._root, true)
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
    local cap = UIText.cast(node:getChild("cap"))
    cap.text = data.Text
    cap.positionX = level * 24

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