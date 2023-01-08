---@class TCE.ThemeUtil
local ThemeUtil = class("ThemeUtil")
local ThemeConfig = require("config.ThemeConfig")
local ColorUtil = require("core.ColorUtil")

local s_cache = {}

function ThemeUtil.getColor(name)
    if type(name) ~= "string" then
        return name
    end
    if s_cache[name] ~= nil then
        return s_cache[name]
    end
    local res
    local data = ThemeConfig.Colors[name]
    if type(data) == "string" then
        res = ColorUtil.fromHex(data)
    else
        local baseColor = ColorUtil.fromHex(ThemeConfig.Colors.BASE_COLOR)
        local function _fixChannel(c)
            local _c = math.max(0, math.min(c - data, 300))
            if _c > 255 then
                _c = math.max(0, 255 - (_c - 255) * 3)
            end
            return _c
        end
        local r = _fixChannel(baseColor.red)
        local g = _fixChannel(baseColor.green)
        local b = _fixChannel(baseColor.blue)
        res = Color.new(r, g, b)
    end
    s_cache[name] = res
    return res
end

return ThemeUtil