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

local s = 0

function TreeView:_initContent(location)

    local x, y = location[1], location[2]
    local name = "tree"
    self._root = UIUtil.newPanel(self._parentRoot, name,
            { x, y, 200, 400 }, {
                --layout = "FULL",
                bgColor = "A",
            }, true)
    self._sv = UIScrollView.new("panel_list", 0, 0, 200, 333)
    UIUtil.setMargins(self._sv, 0, 0, 0, 0, true, true)
    self._root:addChild(self._sv)

    local panelItem = UIUtil.newPanel(self._sv, "panel_item",
            { x, y, 150, Constant.DEFAULT_BAR_HEIGHT }, {
                bgColor = "C",
            }, false)

    local text = UIUtil.newText(panelItem, "cap", nil, "1", {
        layout = "CENTER",
    })

    self._sv:applyMargin(true)
    UIUtil.createTableView(self._sv, self, true, true)
end

function TreeView:_getTableElementCount()
    return 55555
end

function TreeView:_setTableElement(node, index)
    --print("TreeView:_setTableElement", index, node.position, node.size)
    s = s + 1
    local t = string.format("格子cell%d(%d)", index, s)
    local cap = UIText.cast(node:getChild("cap"))
    cap.text = t
    node:applyMargin(true)

    --local treeNode = TreeNode.new(self, node, {}, {0,0})
end

return TreeView