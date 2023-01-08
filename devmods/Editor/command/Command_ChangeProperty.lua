---@class TCE.Command_ChangeProperty:TCE.BaseCommand
local Command_ChangeProperty = class("Command_ChangeProperty", require("BaseCommand"))
local Listener = require("core.Listener")

---__init
---@param target table
---@param propertyName string
---@param newValue any
---@param listener TCE.Listener
function Command_ChangeProperty:__init(target, propertyName, newValue, listener)
    self._target = target
    self._propertyName = propertyName
    self._newValue = newValue
    self._oldValue = self._target[self._propertyName]
    self._canRun = self._newValue ~= self._oldValue
    self._listener = listener
    if type(listener) == "function" or type(listener) == "table" then
        self._listener = Listener.new(listener)
    end
end

function Command_ChangeProperty:_runListener()
    if self._listener ~= nil then
        self._listener:run(self._target, self._propertyName)
    end
end

function Command_ChangeProperty:execute()
    if not self._canRun then
        return
    end
    self._target[self._propertyName] = self._newValue
    self:_runListener()
end

function Command_ChangeProperty:undo()
    if not self._canRun then
        return
    end
    self._target[self._propertyName] = self._oldValue
    self:_runListener()
end

return Command_ChangeProperty