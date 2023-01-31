---@class TCE.BezierCache
local BezierCache = class("BezierCache")

local BEZIER_POINT_TOLERANCE = 8
local BEZIER_SPLIT_PARTS = 8
local BEZIER_THICKNESS = 4
local BEZIER_SELECTED_THICKNESS = 8

function BezierCache:__init(p0, p1, p2, p3)
    self.p0 = nil
    self.p1 = nil
    self.p2 = nil
    self.p3 = nil

    self.bound = nil  ---@type RectFloatEx
    self.boundForPointed = nil  ---@type RectFloatEx
    self._subBounds = {}  ---@type RectFloatEx[]
    self._subBoundsForPointed = {}  ---@type RectFloatEx[]
    self:updateLocation(p0, p1, p2, p3)
end

function BezierCache:updateLocation(p0, p1, p2, p3)
    if self.p0 ~= nil and self.p0 == p0 and self.p1 == p1 and self.p2 == p2 and self.p3 == p3 then
        return
    end

    self.p0 = p0
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3

    local tol = BEZIER_POINT_TOLERANCE
    local tolTwo = tol * 2
    local bound = Geometry.getBezierCubicBound(p0, p1, p2, p3, 0, 1, 0)
    self.bound = bound
    self.boundForPointed = RectFloatEx.new(
            bound.x - tol, bound.y - tol,
            bound.width + tolTwo, bound.height + tolTwo
    )
    self._subBounds = {}
    self._subBoundsForPointed = {}
    local splitParts = BEZIER_SPLIT_PARTS
    for i = 1, splitParts do
        local boundPart = Geometry.getBezierCubicBound(p0, p1, p2, p3, 0, splitParts, i - 1)
        self._subBounds[i] = boundPart
        self._subBoundsForPointed[i] = RectFloatEx.new(
                boundPart.x - tol, boundPart.y - tol,
                boundPart.width + tolTwo, boundPart.height + tolTwo
        )
    end
end

---isOverlappingWithBound
---@param bound RectFloatEx
function BezierCache:isOverlappingWithBound(bound)
    if self.bound:isOverlapping(bound) then
        local splitParts = BEZIER_SPLIT_PARTS
        local p0, p1, p2, p3 = self.p0, self.p1, self.p2, self.p3
        for i = 1, splitParts do
            if self._subBounds[i]:isOverlapping(bound) then
                if Geometry.isBezierOverlapsWithBound(bound, p0, p1, p2, p3, 0, splitParts, i - 1) then
                    return true
                end
            end
        end
        return false
    end
end

function BezierCache:isPointIn(posX, posY)
    if self.boundForPointed:isPointIn(posX, posY) then
        local p = Vector2.new(posX, posY)
        local tol = BEZIER_POINT_TOLERANCE
        local splitParts = BEZIER_SPLIT_PARTS
        local p0, p1, p2, p3 = self.p0, self.p1, self.p2, self.p3
        for i = 1, splitParts do
            if self._subBoundsForPointed[i]:isPointIn(posX, posY) then
                local d = Geometry.getPointDistanceToBezierCubic(p, p0, p1, p2, p3, 0, splitParts, i - 1)
                if d < tol then
                    return true
                end
            end
        end
    end
    return false
end

---@param drawList DrawList
function BezierCache:render(drawList, color, thickness)
    drawList:addBezierCubic(self.p0, self.p1, self.p2, self.p3, color, thickness, 0)
end

---@class TCE.BlueprintSlot
local BlueprintSlot = class("BlueprintSlot")

function BlueprintSlot:__init(isInput)
    self.isInput = isInput
	self.pos = Vector2.new(0, 0)
    self.color = Color.new(math.random(80, 255), math.random(80, 255), math.random(80, 255))
    self.iconBound = RectFloatEx.new(0,0,0,0)

    self.pointed = false
    self.targeted = false

    self.hasLinked = false
    self.isLinkSelected = false
    self.isLinkPointed = false
    self._bezierCache = nil  ---@type TCE.BezierCache
end

function BlueprintSlot:save()
    return {}
end

function BlueprintSlot:load(data)

end

function BlueprintSlot:updateLocation(pos)
    self.pos = pos
    self.iconBound.x = pos.x - 16
    self.iconBound.y = pos.y - 8
    self.iconBound.width = 32
    self.iconBound.height = 16
end

function BlueprintSlot:clearBezierCache()
    self._bezierCache = nil
end

function BlueprintSlot:setBezierCache(p0, p1, p2, p3)
    if self._bezierCache == nil then
        self._bezierCache = BezierCache.new(p0, p1, p2, p3)
    else
        self._bezierCache:updateLocation(p0, p1, p2, p3)
    end
    return self._bezierCache
end

function BlueprintSlot:isLinkOverlappingWithBound(bound)
    if self._bezierCache == nil then
        return false
    end
    return self._bezierCache:isOverlappingWithBound(bound)
end

function BlueprintSlot:isLinkPointIn(pointX, pointY)
    if self._bezierCache == nil then
        return false
    end
    return self._bezierCache:isPointIn(pointX, pointY)
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
function BlueprintSlot:renderLink(drawList)
    if self._bezierCache == nil then
        return
    end
    local thickness = (self.isLinkSelected or self.isLinkPointed) and BEZIER_SELECTED_THICKNESS or BEZIER_THICKNESS
    self._bezierCache:render(drawList, self.color, thickness)
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