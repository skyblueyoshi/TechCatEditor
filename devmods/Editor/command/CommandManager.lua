---@class TCE.CommandManager
local CommandManager = class("CommandManager")
local Deque = require("core.Deque")

local s_instance
---@return TCE.CommandManager
function CommandManager.getInstance()
    if s_instance == nil then
        s_instance = CommandManager.new()
    end
    return s_instance
end

function CommandManager:__init()
    self._maxCommandCount = 32
    self._redoStack = Deque.new()
    self._undoDeque = Deque.new()

    -- 快捷键
    Input.keyboard:getHotKeys(Keys.LeftControl, Keys.Z):addListener({ self.undo, self })
    Input.keyboard:getHotKeys(Keys.LeftControl, Keys.Y):addListener({ self.redo, self })
end

---@param command TCE.BaseCommand
function CommandManager:execute(command)
    local ok = command:execute()
    if not ok then
        return
    end
    print("run:", command:getInfo())
    self:_register(command)
end

---@param command TCE.BaseCommand
function CommandManager:_register(command)
    self._redoStack:clear()
    if self._undoDeque:size() == self._maxCommandCount then
        self._undoDeque:popFirst()
    end
    self._undoDeque:push(command)
end

function CommandManager:undo()
    if self._undoDeque:empty() then
        return
    end
    local command = self._undoDeque:popLast()
    command:undo()
    print("undo:", command:getInfo())
    self._redoStack:push(command)
end

function CommandManager:redo()
    if self._redoStack:empty() then
        return
    end
    local command = self._redoStack:popLast()
    print("redo..")
    command:redo()
    self._undoDeque:push(command)
end

function CommandManager.runChangeInt(target, propertyName, newValue, listener)
    local c = require("command.Command_ChangeInt").new(target, propertyName, newValue, listener)
    CommandManager.getInstance():execute(c)
end

return CommandManager