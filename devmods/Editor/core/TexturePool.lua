---@class TCE.TexturePool
local TexturePool = class("TexturePool")

local s_instance = nil
---@return TCE.TexturePool
function TexturePool.getInstance()
    if s_instance == nil then
        s_instance = TexturePool.new()
    end
    return s_instance
end

function TexturePool:__init()
    self._pool = {}
end

function TexturePool:loadTexture(path)

end

return TexturePool