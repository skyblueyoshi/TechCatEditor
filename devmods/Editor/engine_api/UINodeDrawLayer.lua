---@API

---@class UINodeDrawLayer 描述节点的一个绘制层级。
---@field spriteAnimationPosition Vector2 当前层级挂接的精灵动画绘制偏移量。
---@field spriteAnimationScale Vector2 当前层级挂接的精灵动画绘制放缩量。
---@field spriteAnimationRotation number 当前层级挂接的精灵动画绘制旋转角度。
---@field spriteAnimationFlipHorizontal boolean 当前层级挂接的精灵动画是否左右翻转。
---@field spriteAnimationFlipVertical boolean 当前层级挂接的精灵动画是否竖直翻转。
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