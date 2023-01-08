---@class TCE.Command_ChangeBoolean:TCE.Command_ChangeProperty
local Command_ChangeBoolean = class("Command_ChangeBoolean", require("Command_ChangeProperty"))

function Command_ChangeBoolean:getInfo()
    local function toBooleanString(bValue)
        return bValue and "true" or "false"
    end
    return string.format("Change '%s' boolean: '%s' -> '%s'",
            self._propertyName, toBooleanString(self._oldValue), toBooleanString(self._newValue))
end

return Command_ChangeBoolean