---@class TCE.Command_ChangeFloat:TCE.Command_ChangeProperty
local Command_ChangeFloat = class("Command_ChangeFloat", require("Command_ChangeProperty"))

function Command_ChangeFloat:getInfo()
    return string.format("Change '%s' float: '%f' -> '%f'",
            self._propertyName, self._oldValue, self._newValue)
end

return Command_ChangeFloat