---@API

---@class SpriteAnimationElement 描述一个精灵动画节点。
---@field textureLocation TextureLocation 纹理区域。
---@field sourceRect Rect 在纹理区域内的剪裁区域。
---@field offset Vector2 坐标偏移量。
---@field origin Vector2 原点坐标。
---@field scale Vector2 放缩量。
---@field rotation number 旋转值。
---@field color Color 渲染颜色。
---@field flipHorizontal boolean 是否左右翻转。
---@field flipVertical boolean 是否竖直翻转。
---@field slices9 UISlices9 九宫格数据。
---@field slices9Enabled boolean 是否启用九宫格。
---@field slices9DisplaySize Size 启用九宫格时显示的实际大小。
local SpriteAnimationElement = {}

---返回子节点。
---@param index number 子节点索引。
---@return SpriteAnimationElement 子节点。
function SpriteAnimationElement:getChild(index)
end

---加入一个子节点。
---@return number 子节点索引。
function SpriteAnimationElement:addChild()
end

---删除一个子节点，会对当前子节点后方的所有节点的索引整体左移。
---@param index number 子节点索引。
function SpriteAnimationElement:removeChild(index)
end

---删除所有子节点。
function SpriteAnimationElement:removeAllChildren()
end

---交换两个子节点的位置。
---@param childIndex1 number 第一个子节点索引。
---@param childIndex2 number 第二个子节点索引。
function SpriteAnimationElement:swapChildren(childIndex1, childIndex2)
end

---@class SpriteAnimation 描述一个精灵动画。
local SpriteAnimation = {}

---创建一个精灵动画对象。
---@return SpriteExData 新的精灵动画对象。
function SpriteAnimation.new()
end

---返回当前精灵动画对象是否有效。
---@return boolean
function SpriteAnimation:valid()
end

---播放指定动画。
---@param name string 动画名称。
function SpriteAnimation:playAnimation(name)
end

---播放指定动画。
---@param animationIndex number 动画索引。
function SpriteAnimation:playAnimationByIndex(animationIndex)
end

---设置播放中动画的播放中帧偏移量。
---@param name string 动画名称。
---@param frameIndex number 帧偏移量。
function SpriteAnimation:setPlayingAnimationFrameOffset(name, frameIndex)
end

---设置播放中动画的播放中帧偏移量。
---@param animationIndex number 动画索引。
---@param frameIndex number 帧偏移量。
function SpriteAnimation:setPlayingAnimationFrameOffsetByIndex(animationIndex, frameIndex)
end

---停止所有动画。
function SpriteAnimation:stopAllAnimations()
end

---停止指定动画。
---@param name string 动画名称。
function SpriteAnimation:stopAnimation(name)
end

---停止指定动画。
---@param animationIndex number 动画索引。
function SpriteAnimation:stopAnimationByIndex(animationIndex)
end

---暂停指定动画。
---@param name string 动画名称。
function SpriteAnimation:pauseAnimation(name)
end

---暂停指定动画。
---@param animationIndex number 动画索引。
function SpriteAnimation:pauseAnimationByIndex(animationIndex)
end

---暂停所有动画。
function SpriteAnimation:pauseAllAnimations()
end

---继续播放指定动画。
---@param name string 动画名称。
function SpriteAnimation:resumeAnimation(name)
end

---继续播放指定动画。
---@param animationIndex number 动画索引。
function SpriteAnimation:resumeAnimationByIndex(animationIndex)
end

---继续播放所有动画。
function SpriteAnimation:resumeAllAnimations()
end

---判断指定动画是否正在激活中（播放中或者暂停中）。
---@param name string 动画名称。
---@return boolean
function SpriteAnimation:isAnimationActivated(name)
end

---判断指定动画是否正在激活中（播放中或者暂停中）。
---@param animationIndex number 动画索引。
---@return boolean
function SpriteAnimation:isAnimationActivatedByIndex(animationIndex)
end

---判断指定动画是否正在暂停中。
---@param name string 动画名称。
---@return boolean
function SpriteAnimation:isAnimationPaused(name)
end

---判断指定动画是否正在暂停中。
---@param animationIndex number 动画索引。
---@return boolean
function SpriteAnimation:isAnimationPausedByIndex(animationIndex)
end

---判断指定动画是否正在播放中。
---@param name string 动画名称。
---@return boolean
function SpriteAnimation:isAnimationPlaying(name)
end

---判断指定动画是否正在播放中。
---@param animationIndex number 动画索引。
---@return boolean
function SpriteAnimation:isAnimationPlayingByIndex(animationIndex)
end

---获取当前对象的精灵动画根节点。
---@return SpriteAnimationElement
function SpriteAnimation:getRoot()
end

---判断是否存在播放中的动画。
---@return boolean
function SpriteAnimation:hasPlayingAnimation()
end

---获取播放中的动画数量。
---@return number
function SpriteAnimation:getPlayingAnimationCount()
end

---绘制当前精灵。
---@param position Vector2 坐标。
---@param scale Vector2 放缩量。
---@param rotation number 旋转。
---@param flipHorizontal boolean 是否左右翻转。
---@param flipVertical boolean 是否竖直翻转。
function SpriteAnimation:drawTRSF(position, scale, rotation, flipHorizontal, flipVertical)
end

---绘制当前精灵。
---@param position Vector2 坐标。
---@param scale Vector2 放缩量。
---@param rotation number 旋转。
function SpriteAnimation:drawTRS(position, scale, rotation)
end

---绘制当前精灵。
---@param position Vector2 坐标。
---@param scale Vector2 放缩量。
function SpriteAnimation:drawTS(position, scale)
end

---绘制当前精灵。
---@param position Vector2 坐标。
function SpriteAnimation:drawT(position)
end

return SpriteAnimation