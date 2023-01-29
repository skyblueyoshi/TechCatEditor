---@class TCE.BlueprintSlot
local BlueprintSlot = class("BlueprintSlot")

function BlueprintSlot:__init(isInput)
    self.isInput = isInput
	self.pos = Vector2.new(0, 0)
    self.color = Color.new(math.random(80, 255), math.random(80, 255), math.random(80, 255))
    self.iconBound = RectFloatEx.new(0,0,0,0)
    self.hasLinked = false

    self.pointed = false
    self.targeted = false
end

function BlueprintSlot:updateLocation(pos)
    self.pos = pos
    self.iconBound.x = pos.x - 16
    self.iconBound.y = pos.y - 8
    self.iconBound.width = 32
    self.iconBound.height = 16
end

function BlueprintSlot:isPointIn(pointX, pointY)
    return self.iconBound:isPointIn(pointX, pointY)
end

function BlueprintSlot:canDragOutLine()
    if self.isInput then
        if self.hasLinked then
            return false
        end
    end
    return true
end

---@param drawList DrawList
function BlueprintSlot:render(drawList)
    local iconPos = self.pos
    local iconColor = self.color
    if self.hasLinked then
        drawList:addCircleFilled(iconPos, 8, iconColor, 32)
    end
    drawList:addCircle(iconPos, 8, iconColor, 3, 32)
    drawList:addTriangleFilled(
        Vector2.new(iconPos.x + 12, iconPos.y - 6), 
        Vector2.new(iconPos.x + 12, iconPos.y + 6), 
        Vector2.new(iconPos.x + 12 + 6, iconPos.y), 
        iconColor
    )
    if self.pointed or self.targeted then
        drawList:addCircle(iconPos, 10, iconColor, 3, 32)
    end
end

return BlueprintSlot