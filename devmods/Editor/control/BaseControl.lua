---@class TCE.BaseControl
local BaseControl = class("BaseControl")

function BaseControl:__init(parent, config, data)
    self._parent = parent ---@type UINode
    self._config = config ---@type table
    self._data = data ---@type table

    self._root = nil ---@type UINode
    self._destroyed = false
end

function BaseControl:isDestroyed()
    return self._destroyed
end

function BaseControl:destroy()
    if self:isDestroyed() then
        return
    end
    self._destroyed = true

    self._parent:removeChild(self._root)
    self._parent = nil
    self._root = nil

    self._config = nil
    self._data = nil
end

function BaseControl:getSize()
    return self._root.size
end

return BaseControl