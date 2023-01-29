---@class TCE.BlueprintNodeCache
local BlueprintNodeCache = class("BlueprintNodeCache")

function BlueprintNodeCache:__init()
    self.inData = {}  ---{ key: in, value: { type, var } }
    self.outData = {}  --- { key: out, value: { type, var } }
end

---@class TCE.BlueprintGraph
local BlueprintGraph = class("BlueprintGraph")

function BlueprintGraph:__init()
    self._nodePool = {}  ---@type TCE.BlueprintNode[]
    self._sortedNodes = {}  ---@type TCE.BlueprintNode[]
    self._totalNodes = 0
	self._guid = 1

    self._drawList = DrawList.new()
    self._drawListGrid = DrawList.new()
    self._pointedGuid = nil

    -- 拖拽状态
    self._isNodeDragging = false
    self._draggingMouseStartX = 0
    self._draggingMouseStartY = 0
    self._draggingStartPos = nil

    -- 连线状态
    self._isLineDragging = false
    self._draggingLineIsFromInput = false
    self._draggingLineCurPos = nil
    self._lastTargetedNodeGuid = nil
    self._lastTargetedSlotIsInput = nil
    self._lastTargetedSlotIndex = nil
end

function BlueprintGraph:_clearAllFlags() 
    for _, node in pairs(self._nodePool) do
        node._flag = false
    end
end

function BlueprintGraph:_addNode(node)
    self._nodePool[self._guid] = node
    table.insert(self._sortedNodes, node)
    self._guid = self._guid + 1
	self._totalNodes = self._totalNodes + 1
end

function BlueprintGraph:getNode(guid)
    return self._nodePool[guid]
end

function BlueprintGraph:removeNode(guid)
end

function BlueprintGraph:solve()
	-- 拓扑排序
	local startNode = nil
	
	local inDegrees = {}
	local nextGuids = {}
	local solvedGuids = {}
	
	for _, node in ipairs(self._sortedNodes) do
        local guid = node:getGuid()
		if #node._outInLinks == 0 then
			startNode = node
		end
		
		local nexts = {}
		for _, data in ipairs(node._outInLinks) do
			nexts[data[1]._guid] = true
		end
		nextGuids[guid] = nexts
		inDegrees[guid] = #node._inOutLinks
	end

	 local zeroDegrees = require("core.Deque").new()
    for _, node in ipairs(self._sortedNodes) do
        local guid = node:getGuid()
        if inDegrees[guid] == 0 then
            table.insert(solvedGuids, guid)
            zeroDegrees:push(guid)
        end
    end

	while not zeroDegrees:empty() do
        local guid = zeroDegrees:pop()
        inDegrees[guid] = inDegrees[guid] - 1
        for nextGuid, _ in pairs(nextGuids[guid]) do
            inDegrees[nextGuid] = inDegrees[nextGuid] - 1
            if inDegrees[nextGuid] == 0 then
                table.insert(solvedGuids, nextGuid)
                zeroDegrees:pushFirst(nextGuid)
            end
        end
    end
    print("solvedGuids", solvedGuids)

	self:_beginSolve()

	local nodeCaches = {}
    for _, guid in ipairs(solvedGuids) do
        nodeCaches[guid] = BlueprintNodeCache.new()
    end
    for i, guid in ipairs(solvedGuids) do
        local node = self._nodePool[guid]  ---@type TCE.BlueprintNode
        local nodeCache = nodeCaches[guid]  ---@type TCE.BlueprintNodeCache
        
        for _, slotData in ipairs(node._outInLinks) do
            for _, slotPair in ipairs(slotData[2]) do
                local out = slotPair[1]
                nodeCache.outData[out] = true
            end
        end
		local outData = self:_solveNode(i, node, nodeCache)
        nodeCache.outData = outData
        for iOut, varInfo in pairs(outData) do
            for _, link in ipairs(node._outInLinks) do
                for _, outAndIn in ipairs(link[2]) do
                    if outAndIn[1] == iOut then
                        local nextNode = link[1]  ---@type TCE.BlueprintNode
                        local nextIn = outAndIn[2]
                        local nextGuid = nextNode:getGuid()
                        
                        local nextNodeCache = nodeCaches[nextGuid]  ---@type TCE.BlueprintNodeCache
                        nextNodeCache.inData[nextIn] = varInfo
                    end
                end
            end
        end
    end

	return self:_endSolve()
end

function BlueprintGraph:_beginSolve()

end

function BlueprintGraph:_solveNode(i, node, nodeCache)
	return nil
end

function BlueprintGraph:_endSolve()
	return ""
end

function BlueprintGraph:onMouseMove(mousePosX, mousePosY)
    if self._isNodeDragging or self._isLineDragging then
        return false
    end
    local solvePointed = false
    local changed = false
    for i = #self._sortedNodes, 1, -1 do
        local node = self._sortedNodes[i]
        local pointed = false
        if not solvePointed then
            pointed = node:isPointIn(mousePosX, mousePosY)
            solvePointed = pointed
        end
        if node:setPointed(pointed) then
            changed = true
        end
        if pointed then
            self._pointedGuid = node:getGuid()
            local ok, isInput, slotIndex = node:findTouchedSlot(mousePosX, mousePosY)
            if ok then
                if node:setSlotPointed(isInput, slotIndex) then
                    changed = true
                end
            else
                if node:clearSlotPointed() then
                    changed = true
                end
            end
        end
    end
    return changed
end

function BlueprintGraph:findTouchedNode(posX, posY)
    for i = #self._sortedNodes, 1, -1 do
        local node = self._sortedNodes[i]
        if node:isPointIn(posX, posY) then
            return node
        end
    end
    return nil
end

function BlueprintGraph:onTouchDown(mousePosX, mousePosY)
    if self._pointedGuid ~= nil then
        local node = self:getNode(self._pointedGuid)
        if node:hasSlotPointed() then
            -- 拖出线
            local slot = node:getPointedSlot()
            if not slot:canDragOutLine() then
                return false
            end
            self._isLineDragging = true
            self._draggingLineIsFromInput = slot.isInput
            self._draggingLineCurPos = Vector2.new(mousePosX, mousePosY)
        else
            -- 拖动节点
            self._isNodeDragging = true
            self._draggingStartPos = node.posMin:clone()
            self._draggingMouseStartX = mousePosX
            self._draggingMouseStartY = mousePosY
        end
        return true
    end
    return false
end

function BlueprintGraph:onTouchUp(mousePosX, mousePosY)
    if not self._isNodeDragging and not self._isLineDragging then
        return false
    end
    if self._isLineDragging and self._lastTargetedNodeGuid ~= nil then
        local curNode, nextNode, slotIn, nextOut
        if self._draggingLineIsFromInput then
            curNode = self:getNode(self._pointedGuid)
            nextNode = self:getNode(self._lastTargetedNodeGuid)
            slotIn = curNode:getPointedSlotIndex()
            nextOut = self._lastTargetedSlotIndex
        else
            curNode = self:getNode(self._lastTargetedNodeGuid)
            nextNode = self:getNode(self._pointedGuid)
            slotIn = self._lastTargetedSlotIndex
            nextOut = nextNode:getPointedSlotIndex()
        end
        curNode:addLink(nextNode, slotIn, nextOut)
        curNode:updateLocation()
        nextNode:updateLocation()
    end
    self._isNodeDragging = false
    self._isLineDragging = false
    self:clearTargetSlotInfo()
    return true
end

function BlueprintGraph:onTouchMove(mousePosX, mousePosY)
    if not self._isNodeDragging and not self._isLineDragging then
        return false
    end
    local node = self:getNode(self._pointedGuid)
    if self._isNodeDragging then
        local offsets = Vector2.new(mousePosX - self._draggingMouseStartX, mousePosY - self._draggingMouseStartY)
        node:updateLocation(self._draggingStartPos + offsets)
    else
        local hasSlotTargeted = false
        local node = self:findTouchedNode(mousePosX, mousePosY)
        if node ~= nil then
            local ok, isInput, slotIndex = node:findTouchedSlot(mousePosX, mousePosY)
            if ok and isInput ~= self._draggingLineIsFromInput then
                if node:getGuid() == self._lastTargetedNodeGuid and isInput == self._lastTargetedSlotIsInput and slotIndex == self._lastTargetedSlotIndex then
                    return false
                end
                local slot = node:getSlot(isInput, slotIndex)
                self:clearTargetSlotInfo()
                self._lastTargetedNodeGuid = node:getGuid()
                self._lastTargetedSlotIsInput = isInput
                self._lastTargetedSlotIndex = slotIndex
                slot.targeted = true
                
                hasSlotTargeted = true
                self._draggingLineCurPos = slot.pos:clone()
            end
        end
        if not hasSlotTargeted then
            self:clearTargetSlotInfo()
            self._draggingLineCurPos = Vector2.new(mousePosX, mousePosY)
        end
    end
    return true
end

function BlueprintGraph:clearTargetSlotInfo()
    if self._lastTargetedNodeGuid ~= nil then
        local lastNode = self:getNode(self._lastTargetedNodeGuid)
        lastNode:getSlot(self._lastTargetedSlotIsInput, self._lastTargetedSlotIndex).targeted = false
        
        self._lastTargetedNodeGuid = nil
        self._lastTargetedSlotIsInput = nil
        self._lastTargetedSlotIndex = nil
    end
end

function BlueprintGraph:renderGridBg(targetWidth, targetHeight)
    local drawList = self._drawListGrid
    drawList:clear()

    local cellSize = 32
    local boldCellCount = 4

    local cellCountX = math.ceil(targetWidth / cellSize)
    local cellCountY = math.ceil(targetHeight / cellSize)
    local smallColor = Color.new(255,255,255, 10)
    local borderColor = Color.new(255,255,255, 10)
    
    local smallCellIndex = 0
    local gridLineStart = Vector2.new(0, 0)
    local gridLineEnd = Vector2.new(0, targetHeight)
    for i = 0, cellCountX - 1 do
        local c = i * cellSize
        gridLineStart.x = c
        gridLineEnd.x = c
        local color = smallColor
        local thickness = 1
        if smallCellIndex == boldCellCount then
            color = borderColor
            smallCellIndex = 0
            thickness = 2
        end
        smallCellIndex = smallCellIndex + 1
        drawList:addLine(gridLineStart, gridLineEnd, color, thickness)
    end

    smallCellIndex = 0
    gridLineStart.x = 0
    gridLineEnd.x = targetWidth
    for i = 0, cellCountY - 1 do
        local c = i * cellSize
        gridLineStart.y = c
        gridLineEnd.y = c
        local color = smallColor
        local thickness = 1
        if smallCellIndex == boldCellCount then
            color = borderColor
            smallCellIndex = 0
            thickness = 2
        end
        smallCellIndex = smallCellIndex + 1
        drawList:addLine(gridLineStart, gridLineEnd, color, thickness)
    end

    drawList:drawAll()
end

---@param drawList DrawList
function BlueprintGraph:renderDraggingLine(drawList)
    if self._isLineDragging then
        local node = self:getNode(self._pointedGuid)
        local slot = node:getPointedSlot()
        local fromInput = self._draggingLineIsFromInput
        local p0 = slot.pos
        local p3 = self._draggingLineCurPos
        local p1, p2 = node:getCurveControlPoints(p0, p3, fromInput)
        drawList:addBezierCubic(p0, p1, p2, p3, slot.color, 4, 0)
    end
end

function BlueprintGraph:render(targetWidth, targetHeight)
    local drawList = self._drawList
    drawList:clear()
    self:renderGridBg(targetWidth, targetHeight)
    for _, node in ipairs(self._sortedNodes) do
        node:renderLink(drawList)
    end
    self:renderDraggingLine(drawList)
    for _, node in ipairs(self._sortedNodes) do
        node:render(drawList)
    end
    drawList:drawAll()
end

return BlueprintGraph