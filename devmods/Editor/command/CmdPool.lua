---@class TCE.CmdPool
local CmdPool = class("CmdPool")
local MiscUtil = require("core.MiscUtil")

local s_instance
---@return TCE.CmdPool
function CmdPool.getInstance()
    if s_instance == nil then
        s_instance = CmdPool.new()
    end
    return s_instance
end

function CmdPool:__init()
end

function CmdPool.runCmdFromView(view, widget, callbackName, ...)
    if callbackName == nil or callbackName == "" then
        return
    end
    local inputs = MiscUtil.strSplit(callbackName, "/")
    local funName, moduleName, func
    if #inputs == 1 then
        funName = inputs[1]
    else
        moduleName = inputs[1]
        funName = inputs[2]
    end
    print("run cmd:", callbackName)
    if moduleName ~= nil then
        local m = require(moduleName)
        if m then
            func = m[funName]
        end
    else
        func = CmdPool[funName]
    end
    if func ~= nil then
        func()
    end
end

function CmdPool.redo()

end

function CmdPool.undo()

end

return CmdPool