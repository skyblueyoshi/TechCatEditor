---@class TCE.BlueprintNode
local BlueprintNode = class("BlueprintNode")

function BlueprintNode:__init(graph, position)
	self.inputs = {}  ---@type TCE.BlueprintSlot[]
    self.outputs = {}  ---@type TCE.BlueprintSlot[]
    self._inOutLinks = {}  --- [(node, [(当前输入口id, 子节点输出口id)])]
    self._outInLinks = {}  --- [(node, [(当前输出口id, 子节点输入口id)])]
    self._flag = false
	self._graph = graph
	self._guid = graph._guid
	self.posMin = Vector2.clone(position)
	self.posMax = Vector2.clone(position)
	self.bound = RectFloatEx.new(0,0,0,0)
	self.bgColor = Color.new(37, 37, 38, 200)
	self.capBgColor = Color.new(72, 99, 118, 200)
    self.borderColor = Color.new(120, 120, 120)
    self.rounding = 12
    self.borderThickness = 2
    self.pointedBorderColor = Color.new(63, 145, 199)

    self.pointed = false
    self._hasSlotPointed = false
    self._slotPointedIsInput = false
    self._slotPointedIndex = 0
end

function BlueprintNode:getGuid()
	return self._guid
end

function BlueprintNode.same(node1, node2)
    return node1._guid == node2._guid
end

function BlueprintNode:addLink(nextNode, curIn, nextOut)
    if self:hasLink(curIn) then
        self:removeLink(curIn)
    end
    self:_forceAddLink(nextNode, curIn, nextOut)
    local ok = self:_checkCanLink(self._guid)
    self._graph:_clearAllFlags()
    if not ok then
        self:removeLink(curIn)
    end
end

function BlueprintNode:_checkCanLink(endGuid)
    self._flag = true
    for _, data in ipairs(self._inOutLinks) do
        local node = data[1]
        if node._guid == endGuid then
            return false
        end
        if not node._flag then
            local ok = node:_checkCanLink(endGuid)
            if not ok then
                return false
            end
        end
    end
    return true
end

---@param nextNode TCE.BlueprintNode
---@param curIn number
---@param nextOut number
function BlueprintNode:_forceAddLink(nextNode, curIn, nextOut)
    local function _addLinkSide(links, nextSideNode, firstSlot, nextSlot, isInOut)
        local ok = false
        for _, data in ipairs(links) do
            local node, slotInfo = data[1], data[2]
            if BlueprintNode.same(node, nextSideNode) then
                for _, slotPair in ipairs(slotInfo) do
                    if isInOut then
                        -- 一个输入口只能对应一个输出口
                        if slotPair[1] == firstSlot then
                            assert(false)
                            ok = true
                            break
                        end
                    else
                        -- 一个输出口可以对应多个输入口
                        if slotPair[1] == firstSlot and slotPair[2] == nextSlot then
                            ok = true
                            break
                        end
                    end
                end
                if not ok then
                    table.insert(slotInfo, { firstSlot, nextSlot })
                    ok = true
                end
                break
            end
        end
        if not ok then
            table.insert(links, { nextSideNode, { { firstSlot, nextSlot }, } })
        end
    end

    _addLinkSide(self._inOutLinks, nextNode, curIn, nextOut, true)
    _addLinkSide(nextNode._outInLinks, self, nextOut, curIn, false)
end

function BlueprintNode:removeLink(curIn)
    local nextNode, nextOut, i, j = BlueprintNode._getLink(self._inOutLinks, curIn)
    if i == nil then
        return
    end

    local function _removeLinkSide(links, _i, _j)
        table.remove(links[_i][2], _j)
        if #links[_i][2] == 0 then
            table.remove(links, _i)
        end
    end 
    _removeLinkSide(self._inOutLinks, i, j)
    local _, _, ii, jj = BlueprintNode._getLink(nextNode._outInLinks, nextOut)
    _removeLinkSide(nextNode._outInLinks, ii, jj)
end

function BlueprintNode._getLink(links, firstSlot)
    for i, data in ipairs(links) do
        local slotInfo = data[2]
        for j, slotPair in ipairs(slotInfo) do
            if slotPair[1] == firstSlot then
                return data[1], slotPair[2], i, j
            end
        end
    end
    return nil, nil, nil, nil
end

function BlueprintNode:getLink(curIn)
    return BlueprintNode._getLink(self._inOutLinks, curIn)
end

function BlueprintNode:hasLink(curIn)
    local _, _, i, _ = self:getLink(curIn)
    return i ~= nil
end

function BlueprintNode:updateLocation(posMin)
	posMin = posMin or self.posMin
    self.posMin = posMin:clone()
    self.posMax = Vector2.new(posMin.x + 88, posMin.y + 160)
	local posMax = self.posMax
	self.bound = RectFloatEx.new(posMin.x, posMin.y, posMax.x - posMin.x, posMax.y - posMin.y)

    for i, slot in ipairs(self.inputs) do
        local pos = Vector2.new(self.posMin.x + 18, self.posMin.y + (i - 1) * 32 + 32 + 16)
        slot:updateLocation(pos)
    end
    for i, slot in ipairs(self.outputs) do
        local pos = Vector2.new(self.posMax.x - 24, self.posMin.y + (i - 1) * 32 + 32 + 16)
        slot:updateLocation(pos)
    end

    for _, slot in ipairs(self.outputs) do
        slot.hasLinked = false
    end

    for _, data in ipairs(self._outInLinks) do
        local nextNode = data[1] ---@type TCE.BlueprintNode
        local outAndIns = data[2]
        for _, outAndIn in ipairs(outAndIns) do
            local curOut = outAndIn[1]
            local nextIn = outAndIn[2]
            self.outputs[curOut].hasLinked = true
            nextNode.inputs[nextIn].hasLinked = true
            nextNode.inputs[nextIn].color = self.outputs[curOut].color:clone()
        end
    end
end

function BlueprintNode:setPointed(pointed)
    if self.pointed ~= pointed then
        self.pointed = pointed
        if not pointed then
            self:clearSlotPointed()
        end
        return true
    end
    return false
end

function BlueprintNode:hasSlotPointed()
    return self._hasSlotPointed
end

function BlueprintNode:getPointedSlot()
    if self._hasSlotPointed then
        return self:getSlot(self._slotPointedIsInput, self._slotPointedIndex)
    end
    return nil
end

function BlueprintNode:getPointedSlotIndex()
    return self._slotPointedIndex
end

function BlueprintNode:clearSlotPointed()
    if not self._hasSlotPointed then
        return false
    end
    self._hasSlotPointed = false
    local slot = self:getSlot(self._slotPointedIsInput, self._slotPointedIndex)
    slot.pointed = false
    return true
end

function BlueprintNode:getSlot(isInput, slotIndex)
    if isInput then
        return self.inputs[slotIndex]
    else
        return self.outputs[slotIndex]
    end
end

function BlueprintNode:setSlotPointed(isInput, slotIndex)
    if self._hasSlotPointed then
        if self._slotPointedIsInput == isInput and self._slotPointedIndex == slotIndex then
            return false
        end
    end
    self:clearSlotPointed()
    self._hasSlotPointed = true
    self._slotPointedIsInput = isInput
    self._slotPointedIndex = slotIndex

    self:getSlot(isInput, slotIndex).pointed = true
    return true
end

function BlueprintNode:isPointIn(pointX, pointY)
    return self.bound:isPointIn(pointX, pointY)
end

function BlueprintNode:findTouchedSlot(posX, posY)
    for i, slot in ipairs(self.inputs) do
        if slot:isPointIn(posX, posY) then
            return true, true, i
        end
    end
    for i, slot in ipairs(self.outputs) do
        if slot:isPointIn(posX, posY) then
            return true, false, i
        end
    end
    return false, nil, nil
end

function BlueprintNode:getCurveControlPoints(p0, p3, fromInput)
    local diffX = p3.x - p0.x
    if diffX < 0 then
        diffX = -diffX * 2
    end
    local curveOffset = diffX  * 0.5
    if fromInput then
        curveOffset = -curveOffset
    end
    local p1 = Vector2.new(p0.x + curveOffset, p0.y)
    local p2 = Vector2.new(p3.x - curveOffset, p3.y)
    return p1, p2
end

---@param drawList DrawList
function BlueprintNode:renderLink(drawList)
    for _, data in ipairs(self._outInLinks) do
        local nextNode = data[1] ---@type TCE.BlueprintNode
        local outAndIns = data[2]
        for _, outAndIn in ipairs(outAndIns) do
            local curOut, nextIn = outAndIn[1], outAndIn[2]
            local color = self.outputs[curOut].color
            local p0 = self.outputs[curOut].pos
            local p3 = nextNode.inputs[nextIn].pos
            local p1, p2 = self:getCurveControlPoints(p0, p3, false)
            drawList:addBezierCubic(p0, p1, p2, p3, color, 4, 0)
        end
    end
end

---@param drawList DrawList
function BlueprintNode:render(drawList)
	local posMin = self.posMin
	local posMax = self.posMax
    local rounding = self.rounding
    local borderThickness = self.borderThickness
    local capHeight = 32

    drawList:addRectRoundFilledEx(posMin, Vector2.new(posMax.x, posMin.y + capHeight), self.capBgColor, rounding, rounding, 0, 0)
    drawList:addRectRoundFilledEx(Vector2.new(posMin.x, posMin.y + capHeight), posMax, self.bgColor, 0, 0, rounding, rounding)
    drawList:addRectRound(posMin, posMax, self.borderColor, rounding, borderThickness)

    if self.pointed then
        local diff = 2
        local diffs = Vector2.new(diff, diff)
        drawList:addRectRound(posMin - diffs, posMax + diffs, self.pointedBorderColor, rounding + diff, borderThickness)
    end

    for i, slot in ipairs(self.inputs) do
        slot:render(drawList)
    end

    for i, slot in ipairs(self.outputs) do
        slot:render(drawList)
    end
end

return BlueprintNode