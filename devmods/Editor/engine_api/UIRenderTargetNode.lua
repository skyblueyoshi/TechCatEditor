---@class UIRenderTargetNode:UINode
local UIRenderTargetNode = {}

---new
---@overload fun(name:string):UIRenderTargetNode
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIRenderTargetNode
function UIRenderTargetNode.new(name, x, y, width, height)
end

---
---@param value UIRenderTargetNode
---@return UIRenderTargetNode
function UIRenderTargetNode.clone(value)
end

---case
---@param uiNode UINode
---@return UIRenderTargetNode
function UIRenderTargetNode.cast(uiNode)
end

---@param listener table|function
---@return ListenerID
function UIRenderTargetNode:addRenderTargetListener(listener)
end

---@param listenerID ListenerID
function UIRenderTargetNode:removeRenderTargetListener(listenerID)
end

return UIRenderTargetNode