---@class TCE.Command_Blueprint_MoveNodes:TCE.BaseCommand
local Command_Blueprint_MoveNodes = class("Command_Blueprint_MoveNodes", require("BaseCommand"))

---__init
---@param graph TCE.BlueprintGraph
---@param nodeGuidAndFromToList number[]
function Command_Blueprint_MoveNodes:__init(graph, nodeGuidAndFromToList)
    self._graph = graph
    self._nodeGuidAndFromToList = nodeGuidAndFromToList
end

function Command_Blueprint_MoveNodes:execute()
    if #self._nodeGuidAndFromToList == 0 then
        return false
    end
    for _, data in ipairs(self._nodeGuidAndFromToList) do
        local guid = data[1]
        local toX, toY = data[4], data[5]
        local node = self._graph:getNode(guid)
        node:updateLocation(Vector2.new(toX, toY))
    end
    for _, data in ipairs(self._nodeGuidAndFromToList) do
        local guid = data[1]
        local node = self._graph:getNode(guid)
        node:updateLinkLocation()
    end
    self._graph:flushDisplay()
    return true
end

function Command_Blueprint_MoveNodes:undo()
    for _, data in ipairs(self._nodeGuidAndFromToList) do
        local guid = data[1]
        local fromX, fromY = data[2], data[3]
        local node = self._graph:getNode(guid)
        node:updateLocation(Vector2.new(fromX, fromY))
    end
    for _, data in ipairs(self._nodeGuidAndFromToList) do
        local guid = data[1]
        local node = self._graph:getNode(guid)
        node:updateLinkLocation()
    end
    self._graph:flushDisplay()
end

return Command_Blueprint_MoveNodes