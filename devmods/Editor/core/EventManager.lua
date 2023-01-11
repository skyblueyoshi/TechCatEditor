---@class TCE.EventManager
local EventManager = class("EventManager")
local Listener = require("Listener")

local s_instance
---@return TCE.EventManager
function EventManager.getInstance()
    if s_instance == nil then
        s_instance = EventManager.new()
    end
    return s_instance
end

function EventManager:__init()
    self._eventListeners = {}
    self._freeIds = {}
    self._eventToIds = {}
end

function EventManager:addListener(eventID, listenerInput)
    local id = 0
    local data = { eventID, Listener.new(listenerInput) }
    if #self._freeIds > 0 then
        id = self._freeIds[#self._freeIds]
        table.remove(self._freeIds, #self._freeIds)
        self._eventListeners[id] = data
    else
        table.insert(self._eventListeners, data)
        id = #self._eventListeners
    end
    if self._eventToIds[eventID] == nil then
        self._eventToIds[eventID] = { id, }
    else
        table.insert(self._eventToIds[eventID], id)
    end
end

function EventManager:removeListener(id)
    local data = self._eventListeners[id]
    local eventID = data[1]
    local eventIDs = self._eventToIds[eventID]
    for i, idx in ipairs(eventIDs) do
        if idx == id then
            table.remove(eventIDs, i)
            break
        end
    end
    table.insert(self._freeIds, id)
    self._eventListeners[id] = { 0, nil }
end

function EventManager:triggerEvent(eventID, args)
    local eventIDs = self._eventToIds[eventID]
    if not eventIDs then
        return
    end
    for _, id in ipairs(eventIDs) do
        local listener = self._eventListeners[id][2]
        listener:run(args)
    end
end

return EventManager