---@class TCE.Command_ChangeInt:TCE.Command_ChangeProperty
local Command_ChangeInt = class("Command_ChangeInt", require("Command_ChangeProperty"))

function Command_ChangeInt:getInfo()
    return string.format("Change '%s' integer: '%d' -> '%d'",
            self._propertyName, self._oldValue, self._newValue)
end

return Command_ChangeInt