local CommandManager = require("command.CommandManager")
local Command_Blueprint_AddLine = require("command.Command_Blueprint_AddLine")
local Command_Blueprint_MoveNodes = require("command.Command_Blueprint_MoveNodes")

---@class TCE.BlueprintNodeCache
local BlueprintNodeCache = class("BlueprintNodeCache")

function BlueprintNodeCache:__init()
    self.inData = {}  ---{ key: in, value: { type, var } }
    self.outData = {}  --- { key: out, value: { type, var } }
end

local DraggingState = {
    None = 0,
    DragNode = 1,
    DragLine = 2,
    DragSelectionArea = 3,
    DragSelectedNodes = 4,
}

local GRID_CELL_SIZE = 32
local GRID_BOLD_CELL_COUNT = 4
local GRID_LINE_COLOR = Color.new(255, 255, 255, 10)
local GRID_BOLD_LINE_THICKNESS = 2

local GuidGen = class("GuidGen")

function GuidGen:__init()
    self._requestedGuidDict = {}
    self._freeGuids = {}
    self._freeCnt = 0
    self._maxGuid = 0
end

function GuidGen:requestTarget(guid)
    assert(self._requestedGuidDict[guid] == nil)
    self._requestedGuidDict[guid] = true
end

function GuidGen:request()
    local guid
    if self._freeCnt ~= 0 then
        guid = self._freeGuids[self._freeCnt]
        self._freeGuids[self._freeCnt] = nil
        self._freeCnt = self._freeCnt - 1
    else
        self._maxGuid = self._maxGuid + 1
        guid = self._maxGuid
    end
    self:requestTarget(guid)
    return guid
end

function GuidGen:recycle(guid)
    assert(self._requestedGuidDict[guid])
    self._requestedGuidDict[guid] = nil
    table.insert(self._freeGuids, guid)
    self._freeCnt = self._freeCnt + 1
end

---@class TCE.BlueprintGraph
local BlueprintGraph = class("BlueprintGraph")

function BlueprintGraph:__init(displayChangedCallback)
    self._nodePool = {}  ---@type TCE.BlueprintNode[]
    self._sortedNodes = {}  ---@type TCE.BlueprintNode[]
    self._totalNodes = 0
    self._guidGen = GuidGen.new()

    self._drawList = DrawList.new()
    self._drawListGrid = DrawList.new()

    self._fixMoveStep = 0

    -- 正在指着/拖拽中的节点
    self._pointedGuid = nil
    -- 正在指着的连线：(node_guid, input_slot_index)
    self._pointedLink = nil

    -- 所有被选中的节点
    self._selectedNodes = {}  ---@type TCE.BlueprintNode[]
    -- 所有被选中的连线
    self._selectedLinks = {}  -- [ (node, [input_slot_index, ...]) ]

    -- 拖拽状态
    self._draggingState = DraggingState.None
    self._draggingMouseStartX = 0
    self._draggingMouseStartY = 0

    -- 连线状态
    self._draggingLineIsFromInput = false
    self._draggingLineCurPos = nil
    self._lastTargetedNodeGuid = nil
    self._lastTargetedSlotIsInput = nil
    self._lastTargetedSlotIndex = nil

    -- 选择区域
    self._draggingAreaBeginPosX = 0
    self._draggingAreaBeginPosY = 0
    self._draggingAreaEndPosX = 0
    self._draggingAreaEndPosY = 0

    self._displayChangedCallback = displayChangedCallback  ---@type TCE.Listener

    self._cmdManager = CommandManager.getInstance()
end

function BlueprintGraph:save()
    local data = {
        fixMoveStep = self._fixMoveStep
    }
    data.nodes = {}
    for _, node in ipairs(self._sortedNodes) do
        table.insert(data.nodes, node:save())
    end
    data.links = {}
    for _, node in ipairs(self._sortedNodes) do
        local guid = node:getGuid()
        for _, info in ipairs(node._inOutLinks) do
            local nextNode = info[1]
            local nextGuid = nextNode:getGuid()
            local curInAndNextOuts = info[2]
            for _, curInAndNextOut in ipairs(curInAndNextOuts) do
                table.insert(data.links, { guid, nextGuid, curInAndNextOut[1], curInAndNextOut[2] })
            end
        end
    end
    return data
end

function BlueprintGraph:load(data)
    if data.fixMoveStep ~= nil then
        self._fixMoveStep = data.fixMoveStep
    end
end

function BlueprintGraph:_clearAllFlags()
    for _, node in pairs(self._nodePool) do
        node._flag = false
    end
end

---@param node TCE.BlueprintNode
function BlueprintGraph:_addNode(node)
    local guid = self._guidGen:request()
    node._guid = guid
    self._nodePool[guid] = node
    table.insert(self._sortedNodes, node)
    self._totalNodes = self._totalNodes + 1
end

function BlueprintGraph:getNode(guid)
    return self._nodePool[guid]
end

function BlueprintGraph:removeNode(guid)
    self._guidGen:recycle(guid)
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

function BlueprintGraph:_resetPointedState(mousePosX, mousePosY)
    if self._draggingState ~= DraggingState.None then
        return
    end
    self._pointedGuid = nil
    self._pointedLink = nil
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
    if self._pointedGuid == nil then
        for i = #self._sortedNodes, 1, -1 do
            local node = self._sortedNodes[i]
            local pointedLinkIndex = 0
            if not solvePointed then
                pointedLinkIndex = node:getPointedLinkIndex(mousePosX, mousePosY)
                solvePointed = pointedLinkIndex ~= 0
            end
            if node:setPointedLinkIndex(pointedLinkIndex) then
                changed = true
            end
            if pointedLinkIndex ~= 0 then
                self._pointedLink = { node:getGuid(), pointedLinkIndex }
            end
        end
    end
    if changed then
        self:_onDisplayChanged()
    end
end

function BlueprintGraph:onMouseMove(mousePosX, mousePosY)
    self:_resetPointedState(mousePosX, mousePosY)
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

function BlueprintGraph:findInBoundNodes(bound)
    local res = {}
    for _, node in ipairs(self._sortedNodes) do
        if node:isOverlapping(bound) then
            table.insert(res, node)
        end
    end
    return res
end

function BlueprintGraph:findInBoundLinks(bound)
    local res = {}
    for _, node in ipairs(self._sortedNodes) do
        local nodeRes = node:findLinkOverlappingWithBound(bound)
        if nodeRes then
            table.insert(res, { node, nodeRes })
        end
    end
    return res
end

function BlueprintGraph:getPointedNode()
    if self._pointedGuid == nil then
        return nil
    end
    return self:getNode(self._pointedGuid)
end

function BlueprintGraph:onTouchDown(mousePosX, mousePosY)
    if self._pointedGuid ~= nil then
        local node = self:getPointedNode()
        if node.selected then
            -- 整体拖动所有选中节点
            self._draggingState = DraggingState.DragSelectedNodes
            for _, n in ipairs(self._selectedNodes) do
                n.lastMovePos = n.posMin:clone()
            end
            self._draggingMouseStartX = mousePosX
            self._draggingMouseStartY = mousePosY
        elseif node:hasSlotPointed() then
            -- 拖出线
            local slot = node:getPointedSlot()
            if not slot:canDragOutLine() then
                return false
            end
            self:clearAllSelection()
            self._draggingState = DraggingState.DragLine
            self._draggingLineIsFromInput = slot.isInput
            self._draggingLineCurPos = Vector2.new(mousePosX, mousePosY)
        else
            -- 拖动节点
            self:clearAllSelection()
            self._draggingState = DraggingState.DragNode
            node.lastMovePos = node.posMin:clone()
            self._draggingMouseStartX = mousePosX
            self._draggingMouseStartY = mousePosY
        end
    else
        -- 拖出选中区域
        self:clearAllSelection()
        self._draggingState = DraggingState.DragSelectionArea
        self._draggingAreaBeginPosX, self._draggingAreaBeginPosY = mousePosX, mousePosY
        self._draggingAreaEndPosX, self._draggingAreaEndPosY = mousePosX, mousePosY
    end
    return true
end

function BlueprintGraph:onTouchUp(mousePosX, mousePosY)
    if self._draggingState == DraggingState.None then
        return false
    end
    if self._draggingState == DraggingState.DragLine then
        if self._lastTargetedNodeGuid ~= nil then
            local curNode, nextNode, slotIn, nextOut
            if self._draggingLineIsFromInput then
                curNode = self:getPointedNode()
                nextNode = self:getNode(self._lastTargetedNodeGuid)
                slotIn = curNode:getPointedSlotIndex()
                nextOut = self._lastTargetedSlotIndex
            else
                curNode = self:getNode(self._lastTargetedNodeGuid)
                nextNode = self:getPointedNode()
                slotIn = self._lastTargetedSlotIndex
                nextOut = nextNode:getPointedSlotIndex()
            end
            curNode:addLink(nextNode, slotIn, nextOut)
            self._cmdManager:execute(Command_Blueprint_AddLine.new(self, curNode:getGuid(), slotIn, nextNode:getGuid(), nextOut))
            curNode:updateLocation()
            nextNode:updateLocation()
            curNode:updateLinkLocation()
            nextNode:updateLinkLocation()
        end
    end
    self:_fixMove()
    self._draggingState = DraggingState.None
    self:clearTargetSlotInfo()
    self:_resetPointedState(mousePosX, mousePosY)
    return true
end

function BlueprintGraph:onTouchMove(mousePosX, mousePosY)
    if self._draggingState == DraggingState.None then
        return false
    end
    if self._draggingState == DraggingState.DragNode then
        local offsets = Vector2.new(mousePosX - self._draggingMouseStartX, mousePosY - self._draggingMouseStartY)
        local node = self:getPointedNode()
        node:updateLocation(node.lastMovePos + offsets)
        node:updateLinkLocation()
    elseif self._draggingState == DraggingState.DragSelectedNodes then
        local offsets = Vector2.new(mousePosX - self._draggingMouseStartX, mousePosY - self._draggingMouseStartY)
        for _, node in ipairs(self._selectedNodes) do
            node:updateLocation(node.lastMovePos + offsets)
        end
        for _, node in ipairs(self._selectedNodes) do
            node:updateLinkLocation()
        end
    elseif self._draggingState == DraggingState.DragLine then
        local pointedNode = self:getPointedNode()
        local node = self:findTouchedNode(mousePosX, mousePosY)
        local hasSlotTargeted = false
        if node ~= nil and not node:sameTo(pointedNode) then
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
    elseif self._draggingState == DraggingState.DragSelectionArea then
        self:clearAllSelection()
        self._draggingAreaEndPosX = mousePosX
        self._draggingAreaEndPosY = mousePosY
        local bound = self:_getSelectionBound()
        self._selectedNodes = self:findInBoundNodes(bound)
        if #self._selectedNodes ~= 0 then
            -- 多选节点
            for _, node in ipairs(self._selectedNodes) do
                node.selected = true
            end
        else
            -- 多选连线
            self._selectedLinks = self:findInBoundLinks(bound)
            for _, data in ipairs(self._selectedLinks) do
                local node = data[1]  ---@type TCE.BlueprintNode
                local ins = data[2]
                for _, index in ipairs(ins) do
                    node:getSlot(true, index).isLinkSelected = true
                end
            end
        end
    end
    return true
end

function BlueprintGraph:clearAllSelection()
    self:_clearAllNodeSelection()
    self:_clearAllLinkSelection()
end

function BlueprintGraph:_clearAllLinkSelection()
    for _, data in ipairs(self._selectedLinks) do
        local node = data[1]  ---@type TCE.BlueprintNode
        local ins = data[2]
        for _, index in ipairs(ins) do
            node:getSlot(true, index).isLinkSelected = false
        end
    end
    self._selectedLinks = {}
end

function BlueprintGraph:_clearAllNodeSelection()
    for _, node in ipairs(self._selectedNodes) do
        node.selected = false
    end
    self._selectedNodes = {}
end

function BlueprintGraph:_getSelectionArea()
    local x1, y1, x2, y2 = self._draggingAreaBeginPosX, self._draggingAreaBeginPosY, self._draggingAreaEndPosX, self._draggingAreaEndPosY
    local min = math.min
    local max = math.max
    return min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)
end

function BlueprintGraph:_getSelectionBound()
    local x, y, x2, y2 = self:_getSelectionArea()
    return RectFloatEx.new(x, y, x2 - x, y2 - y)
end

function BlueprintGraph:_getSelectionMinMaxPos()
    local x, y, x2, y2 = self:_getSelectionArea()
    return Vector2.new(x, y), Vector2.new(x2, y2)
end

function BlueprintGraph:_fixMove()
    if self._draggingState ~= DraggingState.DragNode and self._draggingState ~= DraggingState.DragSelectedNodes then
        return
    end
    local step = self._fixMoveStep
    local nodeAndFromToList = {}

    local function _getToPos(node)
        local pos = node.posMin
        if step > 0 then
            local xi = math.floor(pos.x / step + 0.5)
            local yi = math.floor(pos.y / step + 0.5)
            return xi * step, yi * step
        else
            return pos.x, pos.y
        end
    end

    ---_getFromPos
    ---@param node TCE.BlueprintNode
    local function _getFromPos(node)
        return node.lastMovePos.x, node.lastMovePos.y
    end

    local function _addToList(node)
        local fromX, fromY = _getFromPos(node)
        local toX, toY = _getToPos(node)
        table.insert(nodeAndFromToList, { node:getGuid(), fromX, fromY, toX, toY })
    end

    if self._draggingState == DraggingState.DragNode then
        _addToList(self:getPointedNode())
    else
        for _, node in ipairs(self._selectedNodes) do
            _addToList(node)
        end
    end
    self._cmdManager:execute(Command_Blueprint_MoveNodes.new(self, nodeAndFromToList))
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

function BlueprintGraph:_onDisplayChanged()
    if self._displayChangedCallback ~= nil then
        self._displayChangedCallback:run()
    end
end

function BlueprintGraph:flushDisplay()
    self:_onDisplayChanged()
end

function BlueprintGraph:renderGridBg(targetWidth, targetHeight)
    local drawList = self._drawListGrid
    drawList:clear()

    local cellSize = GRID_CELL_SIZE
    local boldCellCount = GRID_BOLD_CELL_COUNT

    local cellCountX = math.ceil(targetWidth / cellSize)
    local cellCountY = math.ceil(targetHeight / cellSize)
    local smallColor = GRID_LINE_COLOR
    local borderColor = GRID_LINE_COLOR

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
            thickness = GRID_BOLD_LINE_THICKNESS
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
            thickness = GRID_BOLD_LINE_THICKNESS
        end
        smallCellIndex = smallCellIndex + 1
        drawList:addLine(gridLineStart, gridLineEnd, color, thickness)
    end

    drawList:drawAll()
end

---@param drawList DrawList
function BlueprintGraph:renderDraggingLine(drawList)
    if self._draggingState ~= DraggingState.DragLine then
        return
    end
    local node = self:getPointedNode()
    local slot = node:getPointedSlot()
    local fromInput = self._draggingLineIsFromInput
    local p0 = slot.pos
    local p3 = self._draggingLineCurPos
    local p1, p2 = node:getCurveControlPoints(p0, p3, fromInput)
    drawList:addBezierCubic(p0, p1, p2, p3, slot.color, 4, 0)
end

---@param drawList DrawList
function BlueprintGraph:renderDraggingSelectionArea(drawList)
    if self._draggingState ~= DraggingState.DragSelectionArea then
        return
    end
    local minPos, maxPos = self:_getSelectionMinMaxPos()
    drawList:addRectFilled(minPos, maxPos, Color.new(38, 79, 120, 128))
    drawList:addRect(minPos, maxPos, Color.new(38, 79, 120, 200), 2)
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
    self:renderDraggingSelectionArea(drawList)
    drawList:drawAll()
end

return BlueprintGraph