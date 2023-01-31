---@class TCE.Command_Blueprint_AddLine:TCE.BaseCommand
local Command_Blueprint_AddLine = class("Command_Blueprint_AddLine", require("BaseCommand"))

---__init
---@param graph TCE.BlueprintGraph
---@param inNodeGuid number
---@param inSlotIndex number
---@param outNodeGuid number
---@param outSlotIndex number
function Command_Blueprint_AddLine:__init(graph, inNodeGuid, inSlotIndex, outNodeGuid, outSlotIndex)
    self._graph = graph
    self._inNodeGuid = inNodeGuid
    self._inSlotIndex = inSlotIndex
    self._outNodeGuid = outNodeGuid
    self._outSlotIndex = outSlotIndex
end

function Command_Blueprint_AddLine:execute()
    local inNode = self._graph:getNode(self._inNodeGuid)
    local outNode = self._graph:getNode(self._outNodeGuid)
    local changed = inNode:addLink(outNode, self._inSlotIndex, self._outSlotIndex)
    if changed then
        self._graph:flushDisplay()
    end
    return changed
end

function Command_Blueprint_AddLine:undo()
    local inNode = self._graph:getNode(self._inNodeGuid)
    inNode:removeLink(self._inSlotIndex)
end

return Command_Blueprint_AddLine