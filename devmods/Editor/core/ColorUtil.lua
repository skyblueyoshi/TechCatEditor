---@class TCE.ColorUtil
local ColorUtil = class("ColorUtil")

---fromHex
---@param hex string
---@return Color
function ColorUtil.fromHex(hex)
    hex = hex:gsub("#", "")
    local len = #hex
    if len ~= 6 and len ~= 8 then
        return Color.new()
    end
    local r = tonumber("0x" .. hex:sub(1, 2))
    local g = tonumber("0x" .. hex:sub(3, 4))
    local b = tonumber("0x" .. hex:sub(5, 6))
    local a = 255
    if #hex == 8 then
        a = tonumber("0x" .. hex:sub(7, 8))
    end
    return Color.new(r, g, b, a)
end

---toHex
---@param color Color
---@return string
function ColorUtil.toHex(color)
    return "#" .. string.format("%02x", color.red) ..
            string.format("%02x", color.green) ..
            string.format("%02x", color.blue) ..
            string.format("%02x", color.alpha)
end

return ColorUtil