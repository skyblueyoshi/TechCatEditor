---@API

---@class UINode 基本的UI节点，是所有类型UI节点的基类。
---@field name string 节点名字。
---@field anchorPoint Vector2 组件锚点。
---@field anchorPointX number 锚点横坐标。
---@field anchorPointY number 锚点纵坐标。
---@field position Vector2 节点在父节点空间的坐标。
---@field positionInCanvas Vector2 节点在画布空间的坐标。
---@field positionX number 节点在父节点空间的横坐标。
---@field positionY number 节点在父节点空间的纵坐标。
---@field size Size 节点尺寸。
---@field width number 节点宽度。
---@field height number 节点高度。
---@field visible boolean 节点是否可见。
---@field leftMargin number 节点到父节点的左侧边距。
---@field rightMargin number 节点到父节点的右侧边距。
---@field topMargin number 节点到父节点的上侧边距。
---@field bottomMargin number 节点到父节点的下侧边距。
---@field leftMarginEnabled boolean 是否启用节点到父节点的左侧边距。
---@field rightMarginEnabled boolean 是否启用节点到父节点的右侧边距。
---@field topMarginEnabled boolean 是否启用节点到父节点的上侧边距。
---@field bottomMarginEnabled boolean 是否启用节点到父节点的下侧边距。
---@field autoStretchWidth boolean 是否根据左右侧边距自动拉伸适配宽度，若为false，则为根据左右侧边距水平居中。
---@field autoStretchHeight boolean 是否根据上下侧边距自动拉伸适配高度，若为false，则为根据上下侧边距竖直居中。
---@field widthRate number 节点相对于父节点的宽度比例。0.0表示不启用比例适配。
---@field heightRate number 节点相对于父节点的高度比例。0.0表示不启用比例适配。
---@field touchable boolean 节点是否可被触碰。
---@field touchBlockable boolean 节点被触碰时，是否吞噬下层节点的触碰事件。
---@field tag number 节点附加值。
---@field childTag number 节点作为子节点时的附加值。
---@field isContainer boolean 节点是否作为裁切容器。
---@field allowDoubleClick boolean 节点是否允许进行双击。
---@field textBatchRendering boolean
---@field enableRenderTarget boolean 节点是否开启RenderTarget纹理缓存，开启后仅在内部节点更新时重绘纹理缓存。
---@field isTouching boolean 当前节点是否被触碰中。
local UINode = {}

---new
---@return UINode
function UINode.new()
end

---clone
---@return UINode
function UINode:clone()
end

---@return boolean
function UINode:valid()
end

---设置锚点。
---@param x number
---@param y number
function UINode:setAnchorPoint(x, y)
end

---设置坐标。
---@param x number
---@param y number
function UINode:setPosition(x, y)
end

---设置坐标和尺寸。
---@param x number
---@param y number
---@param width number
---@param height number
function UINode:setLocation(x, y, width, height)
end

---设置尺寸。
---@param width number
---@param height number
function UINode:setSize(width, height)
end

---添加一个孩子节点。
---@overload fun(node:UINode)
---@param node UINode
---@param childTag number
function UINode:addChild(node, childTag)
end

---当前节点删除指定孩子节点。
---@param node UINode
function UINode:removeChild(node)
end

---移除当前节点的所有孩子节点。
function UINode:removeAllChildren()
end

---根据当前设定的边距数据调整位置和尺寸。
---@param applyAllChildren boolean 是否对所有孩子节点执行相同操作。
function UINode:applyMargin(applyAllChildren)
end

---@param offset number
---@param enabled boolean
function UINode:setLeftMargin(offset, enabled)
end

---@param offset number
---@param enabled boolean
function UINode:setRightMargin(offset, enabled)
end

---@param offset number
---@param enabled boolean
function UINode:setTopMargin(offset, enabled)
end

---@param offset number
---@param enabled boolean
function UINode:setBottomMargin(offset, enabled)
end

---@param left boolean
---@param top boolean
---@param right boolean
---@param bottom boolean
function UINode:setMarginEnabled(left, top, right, bottom)
end

---@param widthEnabled boolean
---@param heightEnabled boolean
function UINode:setAutoStretch(widthEnabled, heightEnabled)
end

---@param childTag number
---@return UINode
function UINode:getChildByTag(childTag)
end

---由路径名称获得孩子节点。
---@param name string
---@return UINode
function UINode:getChild(name)
end

---添加一个触碰按下监听器。
---@param listener table|function
---@return ListenerID
function UINode:addTouchDownListener(listener)
end

---@param listenerID ListenerID
function UINode:removeTouchDownListener(listenerID)
end

---添加一个触碰双击监听器。
---@param listener table|function
---@return ListenerID
function UINode:addTouchDoubleDownListener(listener)
end

---@param listenerID ListenerID
function UINode:removeTouchDoubleDownListener(listenerID)
end

---添加一个触碰拖动监听器，在存在触碰按下后生效。
---@param listener table|function
---@return ListenerID
function UINode:addTouchMoveListener(listener)
end

---@param listenerID ListenerID
function UINode:removeTouchMoveListener(listenerID)
end

---添加一个触碰拖动监听器，任意触碰在上方移动均生效。
---@param listener table|function
---@return ListenerID
function UINode:addTouchPointedMoveListener(listener)
end

---@param listenerID ListenerID
function UINode:removeTouchPointedMoveListener(listenerID)
end

---添加一个触碰松开监听器，在存在触碰按下后生效。
---@param listener table|function
---@return ListenerID
function UINode:addTouchUpListener(listener)
end

---@param listenerID ListenerID
function UINode:removeTouchUpListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchUpAfterMoveListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchUpAfterMoveListener(listenerID)
end

---添加一个触碰松开监听器，任意触碰都生效。
---@param listener table|function
---@return ListenerID
function UINode:addTouchPointedUpListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchPointedUpListener(listenerID)
end

---添加一个鼠标指针持续指着的监听器。
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedListener(listener)
end

---@param listenerID ListenerID
function UINode:removeMousePointedListener(listenerID)
end

---添加一个鼠标指针进入的监听器。
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedEnterListener(listener)
end

---@param listenerID ListenerID
function UINode:removeMousePointedEnterListener(listenerID)
end

---添加一个鼠标指针离开的监听器。
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedLeaveListener(listener)
end

---@param listenerID ListenerID
function UINode:removeMousePointedLeaveListener(listenerID)
end

---添加一个尺寸变化监听器。
---@param listener table|function
---@return ListenerID
function UINode:addResizeListener(listener)
end

---@param listenerID ListenerID
function UINode:removeResizeListener(listenerID)
end

---返回前绘制层。
---@param layer number
---@return UINodeDrawLayer
function UINode:getPreDrawLayer(layer)
end

---返回后绘制层。
---@param layer number
---@return UINodeDrawLayer
function UINode:getPostDrawLayer(layer)
end

---返回当前节点拥有的孩子总数。
---@return number
function UINode:getChildrenCount()
end

---由孩子索引获得孩子节点。
---@param index number
---@return UINode
function UINode:getChildByIndex(index)
end

---返回当前节点的父节点。
---@return UINode
function UINode:getParent()
end

---返回画布空间中指定坐标所指向的节点。
---@overload fun(canvasPosition:Vector2):UINode
---@param canvasPosition Vector2 画布空间坐标。
---@param isTouching boolean 是否模拟触碰。
---@return UINode
function UINode:getPointedNode(canvasPosition, isTouching)
end

---返回画布空间中指定坐标所指向的所有节点。（忽略遮挡和吞噬）
---@param canvasPosition Vector2
---@return UINode[]
function UINode:getAllPointedNodes(canvasPosition)
end

---更新渲染信息。
function UINode:flushRender()
end

---移除全部挂接的监听器。
function UINode:removeAllListeners()
end

---返回当前节点具体类型。
---@return string
function UINode:getTypeName()
end

return UINode