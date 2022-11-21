---@class TCE.BaseControl
local BaseControl = class("BaseControl")

function BaseControl:__init(parent, data)
    self._parent = parent ---@type TCE.BaseControl
    self._root = nil ---@type UINode

    self._data = data ---@type table

    self._children = {} ---@type TCE.BaseControl[]
    self._childrenMap = {}

    self.isWindow = false
    self._destroyed = false
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
    for _, child in ipairs(self._children) do
        child:destroy()
    end
    self._children = {}
    for k, child in pairs(self._childrenMap) do
        child:destroy()
    end
    self._childrenMap = {}

    self._parent:getRoot():removeChild(self._root)
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
        assert(false)
    end
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