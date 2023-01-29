---@API

---@class DrawList 描述一个绘制指令列表。
local DrawList = {}

---执行所有绘制指令。
function DrawList:drawAll()
end

---清空所有绘制指令。
function DrawList:clear()
end
---绘制一个线段。
---@param p1 Vector2
---@param p2 Vector2
---@param color Color
---@param thickness number 线粗度。
function DrawList:addLine(p1, p2, color, thickness)
end
---绘制一个矩形。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
---@param thickness number 线粗度。
function DrawList:addRect(minPos, maxPos, color, thickness)
end
---绘制一个填充矩形。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
function DrawList:addRectFilled(minPos, maxPos, color)
end
---绘制一个圆角矩形。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
---@param rounding number 圆角半径。
---@param thickness number 线粗度。
function DrawList:addRectRound(minPos, maxPos, color, rounding, thickness)
end
---绘制一个圆角矩形，可自定义四个角的圆角半径。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
---@param roundingLT number 左上角圆角半径。
---@param roundingRT number 右上角圆角半径。
---@param roundingLB number 左下角圆角半径。
---@param roundingRB number 右下角圆角半径。
---@param thickness number 线粗度。
function DrawList:addRectRoundEx(minPos, maxPos, color, roundingLT, roundingRT, roundingLB, roundingRB, thickness)
end
---绘制一个填充圆角矩形。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
---@param rounding number 圆角半径。
function DrawList:addRectRoundFilled(minPos, maxPos, color, rounding)
end
---绘制一个填充圆角矩形，可自定义四个角的圆角半径。
---@param minPos Vector2
---@param maxPos Vector2
---@param color Color
---@param roundingLT number 左上角圆角半径。
---@param roundingRT number 右上角圆角半径。
---@param roundingLB number 左下角圆角半径。
---@param roundingRB number 右下角圆角半径。
function DrawList:addRectRoundFilledEx(minPos, maxPos, color, roundingLT, roundingRT, roundingLB, roundingRB)
end
---绘制一个三角形。
---@param p1 Vector2
---@param p2 Vector2
---@param p3 Vector2
---@param color Color
---@param thickness number 线粗度。
function DrawList:addTriangle(p1, p2, p3, color, thickness)
end
---绘制一个填充三角形。
---@param p1 Vector2
---@param p2 Vector2
---@param p3 Vector2
---@param color Color
function DrawList:addTriangleFilled(p1, p2, p3, color)
end
---绘制一条贝塞尔曲线。（四个控制点）
---@param p0 Vector2
---@param p1 Vector2
---@param p2 Vector2
---@param p3 Vector2
---@param color Color
---@param thickness number 线粗度。
---@param segments number 分段数。0为自适应分段数量。
function DrawList:addBezierCubic(p0, p1, p2, p3, color, thickness, segments)
end
---绘制一段圆弧。
---@param center Vector2
---@param r number
---@param minAngle number
---@param maxAngle number
---@param color Color
---@param thickness number 线粗度。
---@param segments number 分段数。0为自适应分段数量。
function DrawList:addArc(center, r, minAngle, maxAngle, color, thickness, segments)
end
---绘制一个圆。
---@param center Vector2
---@param r number
---@param color Color
---@param thickness number 线粗度。
---@param segments number 分段数。0为自适应分段数量。
function DrawList:addCircle(center, r, color, thickness, segments)
end
---绘制一个填充圆。
---@param center Vector2
---@param r number
---@param color Color
---@param segments number 分段数。0为自适应分段数量。
function DrawList:addCircleFilled(center, r, color, segments)
end

return DrawList