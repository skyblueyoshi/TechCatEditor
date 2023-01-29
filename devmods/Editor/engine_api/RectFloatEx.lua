---@API

---@class RectFloatEx:SerializableType 描述一个矩形区域，坐标精度为float，尺寸精度为float。
---@field x number 矩形左上角横坐标。
---@field y number 矩形左上角纵坐标。
---@field width number 矩形宽度。
---@field height number 矩形高度。
---@field rightX number 矩形右边缘横坐标。
---@field bottomY number 矩形下边缘纵坐标。
---@field centerX number 矩形中心横坐标。
---@field centerY number 矩形中心纵坐标。
local RectFloatEx = {}

---创建一个矩形区域对象。
---@param x number
---@param y number
---@param width number
---@param height number
---@return RectFloatEx 新的矩形区域对象。
function RectFloatEx.new(x, y, width, height)
end

---当前矩形区域是否为空。
---@return boolean
function RectFloatEx:empty()
end

---当前矩形区域是否与另一个矩形区域重叠。
---@param other RectFloatEx
---@return boolean
function RectFloatEx:isOverlapping(other)
end

---当前矩形区域是否完全包含另一个矩形区域。
---@param other RectFloatEx
---@return boolean
function RectFloatEx:isFullyContains(other)
end

---当前矩形区域是否包含指定点。
---@param pointX number
---@param pointY number
---@return boolean
function RectFloatEx:isPointIn(pointX, pointY)
end

---获取完全包含当前矩形区域和另一个矩形区域并集的最小矩形区域。
---@param other RectFloatEx
---@return RectFloatEx
function RectFloatEx:union(other)
end

---获取当前矩形区域和另外一个矩形区域的相交部分。
---@param other RectFloatEx
---@return RectFloatEx
function RectFloatEx:intersect(other)
end

return RectFloatEx