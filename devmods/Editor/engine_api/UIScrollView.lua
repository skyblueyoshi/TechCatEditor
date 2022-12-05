---@API

---@class UIScrollView:UINode 滚动容器节点。
---@field sprite UISprite 滚动容器的精灵资源。
---@field viewSize Size 内容尺寸。
---@field isScrollVertical boolean 是否开启了纵向滚动。
---@field isScrollHorizontal boolean 是否开启了横向滚动。
---@field isScrollable boolean 当前内容尺寸是否可以激活滚动。
---@field canScrollVertical boolean 当前内容高度是否可以激活纵向滚动。
---@field canScrollHorizontal boolean 当前内容宽度是否可以激活横向滚动。
---@field isScrolling boolean 当前是否正在滚动。
---@field scrollRateVertical number 当前纵向滚动比例。
---@field scrollRateHorizontal number 当前横向滚动比例。
---@field mouseScrollMoveTime number 鼠标滚轮滚动后内部容器滚动动画总时长。
---@field mouseScrollMoveDistance number 单次鼠标滚轮滚动后内部容器滚动距离。
local UIScrollView = {}

---new
---@overload fun(name:string):UIScrollView
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIScrollView
function UIScrollView.new(name, x, y, width, height)
end

---
---@param value UIScrollView
---@return UIScrollView
function UIScrollView.clone(value)
end

---case
---@param uiNode UINode
---@return UIScrollView
function UIScrollView.cast(uiNode)
end

function UIScrollView:scrollToTop()
end

function UIScrollView:scrollToBottom()
end

function UIScrollView:scrollToLeft()
end

function UIScrollView:scrollToRight()
end

function UIScrollView:stopScrolling()
end

---滚动内部容器。
---@overload fun(moveX:number,moveY:number)
---@param moveX number 横向滚动距离。
---@param moveY number 纵向滚动距离。
---@param clampInArea boolean 滚动后是否限制边界。
function UIScrollView:scroll(moveX, moveY, clampInArea)
end

---纵向滚动到指定比例。
---@param rate number
function UIScrollView:scrollToRateVertical(rate)
end

---横向滚动到指定比例。
---@param rate number
function UIScrollView:scrollToRateHorizontal(rate)
end

---@return Vector2
function UIScrollView:getViewPosition()
end

---
---@param listener table|function
---@return ListenerID
function UIScrollView:addScrollingListener(listener)
end

---
---@param listenerID ListenerID
function UIScrollView:removeScrollingListener(listenerID)
end

return UIScrollView