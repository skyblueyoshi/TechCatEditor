---@class TCE.Command_ChangeString:TCE.Command_ChangeProperty
local Command_ChangeString = class("Command_ChangeString", require("Command_ChangeProperty"))

function Command_ChangeString:getInfo()
    return string.format("Change '%s' string: '%s' -> '%s'",
            self._propertyName, self._oldValue, self._newValue)
end

return Command_ChangeString