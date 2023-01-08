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

function TexturePool:load(path)
    path = Path.fix(path)
    assert(self._pool[path] == nil)
    local loc = TextureManager.loadFromFile(path)
    local texture = TextureManager.getTargetTextureByLocation(loc)
    local id = texture.id
    self._pool[path] = id
    return id
end

function TexturePool:getLocationByPath(path)
    path = Path.fix(path)
    local id = self._pool[path]
    return self:getLocationByID(id)
end

function TexturePool:getLocationByID(id)
    return TextureManager.getTextureByID(id):getTextureLocation()
end

return TexturePool