---@class TCE.ResTexturePool
local ResTexturePool = class("TexturePool")
---@class TCE.ResTexture
local ResTexture = class("TextureElement")

---@param texture Texture
---@param path string
function ResTexture:__init(texture, path)
    self.texture = texture
    self.id = texture.id
    self.path = path
    self.textureLocation = self.texture:getTextureLocation()
    self.width = self.texture.width
    self.height = self.texture.height
end

function ResTexture:isLoaded()
    return self.texture.isLoaded
end

local s_instance = nil
---@return TCE.ResTexturePool
function ResTexturePool.getInstance()
    if s_instance == nil then
        s_instance = ResTexturePool.new()
    end
    return s_instance
end

function ResTexturePool:__init()
    self._pool = {}  -- id -> texture
    self._pathIds = {}  -- path -> id
    self._count = 0
end

function ResTexturePool:load(path)
    local loc = TextureManager.loadFromFile(path)
    local texture = TextureManager.getTargetTextureByLocation(loc)
    local id = texture.id
    self._pool[id] = ResTexture.new(texture, path)
    self._pathIds[path] = id
    self._count = self._count + 1
    return id
end

function ResTexturePool:unload(id)
    local element = self:getByID(id)
    self._pool[id] = nil
    self._pathIds[element.path] = nil
    TextureManager.releaseTextureByID(id)
    self._count = self._count - 1
end

---@param id number
---@return TCE.ResTexture
function ResTexturePool:getByID(id)
    return self._pool[id]
end

function ResTexturePool:getByPath(path)
    local id = self._pathIds[path]
    if id ~= nil then
        return self:getByID(id)
    end
    return nil
end

return ResTexturePool