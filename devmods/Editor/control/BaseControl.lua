---@class TCE.BaseControl
local BaseControl = class("BaseControl")
local EventManager = require("core.EventManager")

function BaseControl:__init(parent, parentRoot, data)
    self._parent = parent ---@type TCE.BaseControl
    self._parentRoot = parentRoot ---@type UINode
    self._root = nil ---@type UINode

    self._data = data ---@type table

    self._children = {} ---@type TCE.BaseControl[]
    self._childrenMap = {}

    self.isWindow = false
    self._destroyed = false
    self._eventListenerIDs = {}
end

function BaseControl:isDestroyed()
    return self._destroyed
end

function BaseControl:destroy()
    if self:isDestroyed() then
        return
    end
    self:onDestroy()
end

function BaseControl:onDestroy()
    local eventManager = EventManager.getInstance()
    for _, id in ipairs(self._eventListenerIDs) do
        eventManager:removeListener(id)
    end
    self._eventListenerIDs = {}

    for _, child in ipairs(self._children) do
        child:destroy()
    end
    self._children = {}
    for k, child in pairs(self._childrenMap) do
        child:destroy()
    end
    self._childrenMap = {}

    self._parentRoot:removeChild(self._root)
    self._parentRoot = nil
    self._parent = nil
    self._root = nil

    self._config = nil
    self._data = nil
    self._destroyed = true
end

function BaseControl:addChild(child)
    table.insert(self._children, child)
end

function BaseControl:addMap(key, child)
    if self._childrenMap[key] == nil then
        self._childrenMap[key] = child
    else
        print("fail map:", key)
        assert(false)
    end
end

function BaseControl:addEventListener(eventID, func)
    local id = EventManager.getInstance():addListener(eventID, func)
    table.insert(self._eventListenerIDs, id)
end

function BaseControl:triggerEvent(eventID, args)
    EventManager.getInstance():triggerEvent(eventID, args)
end

function BaseControl:getRoot()
    return self._root
end

function BaseControl:getWindow()
    if self.isWindow then
        return self
    end
    return self._parent:getWindow()
end

function BaseControl:getPositionInWindow()
    if self.isWindow then
        return 0, 0
    end
    local topX, topY = self._parent:getPositionInWindow()
    return topX + self._root.positionX, topY + self._root.positionY
end

return BaseControl