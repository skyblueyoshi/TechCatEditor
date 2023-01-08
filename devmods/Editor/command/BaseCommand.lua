---@class TCE.BaseCommand
local BaseCommand = class("BaseCommand")

function BaseCommand:__init()
end

---执行操作。
function BaseCommand:execute()
end

---撤销操作。
function BaseCommand:undo()
end

---重做操作。
function BaseCommand:redo()
    self:execute()
end

---打印信息。
function BaseCommand:getInfo()
    return "base command."
end

return BaseCommand