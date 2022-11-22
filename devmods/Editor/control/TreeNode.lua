---@class TCE.TreeNode:TCE.ActivePanel
local TreeNode = class("TreeNode", require("ActivePanel"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

function TreeNode:__init(parent, parentRoot, data, location)
    TreeNode.super.__init(self, parent, parentRoot, data)

    self:_initContent(location)
end
local s = 1
function TreeNode:_initContent(location)
    TreeNode.super._initContent(self, location)
    s = s + 1
    local text = UIUtil.newText(self._root, "cap", nil, string.format("k%d", s), {
            layout = "CENTER",
        })
end

return TreeNode