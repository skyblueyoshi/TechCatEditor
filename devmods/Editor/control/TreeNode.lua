---@class TCE.TreeNode:TCE.ActivePanel
local TreeNode = class("TreeNode", require("ActivePanel"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

function TreeNode:__init(parent, parentRoot, data, location)
    TreeNode.super.__init(self, parent, parentRoot, data)

    self:_initContent(location)
end
local s = 0
function TreeNode:_initContent(location)
    TreeNode.super._initContent(self, location)
    s = s + 1
    local t = string.format("k%d", s)
    if not self._root:getChild("cap"):valid() then
        local text = UIUtil.newText(self._root, "cap", nil, t, {
            layout = "CENTER",
        })
    else
        UIText.cast(self._root:getChild("cap")).text = t
    end
end

return TreeNode