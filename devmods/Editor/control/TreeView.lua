---@class TCE.TreeView:TCE.BaseControl
local TreeView = class("TreeView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local TreeNode = require("TreeNode")

function TreeView:__init(parent, parentRoot, data, location)
    TreeView.super.__init(self, parent, parentRoot, data)
    self._sv = nil
    self:_initContent(location)
end

function TreeView:_initContent(location)

    local x, y = location[1], location[2]
    local name = "tree"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 0, Constant.DEFAULT_BAR_HEIGHT }, {
                layout = "FULL_W",
                bgColor = "A",
            }, true)
    self._sv = UIScrollView.new("panel_list", 0, 0, 200, 333)
    UIUtil.setMargins(self._sv, 0, 0, 0, 0, true, true)
    self._root:addChild(self._sv)

    local panelItem = UIUtil.newPanel(self._sv, "panel_item",
            { x, y, 200, Constant.DEFAULT_BAR_HEIGHT }, {
                bgColor = "C",
            }, false)
    self._sv:applyMargin(true)
    UIUtil.setTable(self._sv, self)
end

function TreeView:_getTableElementCount()
    return 5
end

function TreeView:_setTableElement(node, index)
    print(index, node.position, node.size)
    local treeNode = TreeNode.new(self, node, {}, {0,0})
end

return TreeView