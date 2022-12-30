---@API

---@class UINodeDrawLayer 描述节点的一个绘制层级。
local UINodeDrawLayer = {}

---添加绘制监听函数。
---@param listener table|function
---@return ListenerID
function UINodeDrawLayer:addListener(listener)
end

---@param listenerID ListenerID
function UINodeDrawLayer:removeListener(listenerID)
end

---获取当前层级挂接的精灵动画。
---@return SpriteAnimation
function UINodeDrawLayer:getSpriteAnimation()
end

---设置当前层级挂接的精灵动画。
---@param spriteAnimation SpriteAnimation
function UINodeDrawLayer:setSpriteAnimation(spriteAnimation)
end

---清除当前层级的精灵动画。
function UINodeDrawLayer:removeSpriteAnimation()
end

return UINodeDrawLayer