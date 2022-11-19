---@class TCE.ThemeUtil
local ThemeUtil = class("ThemeUtil")
local ThemeConfig = require("config.ThemeConfig")
local ColorUtil = require("core.ColorUtil")

function ThemeUtil.getColor(name)
    local hex = ThemeConfig.Colors[name]
    if hex ~= nil then
        return ColorUtil.fromHex(hex)
    end
    return Color.new()
end

return ThemeUtil