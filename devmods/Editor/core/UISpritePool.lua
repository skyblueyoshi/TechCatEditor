---@class TCE.UISpritePool
local UISpritePool = class("UISpritePool")

local s_uiSpritePool = nil
---@return TCE.UISpritePool
function UISpritePool.getInstance()
    if s_uiSpritePool == nil then
        s_uiSpritePool = UISpritePool.new()
    end
    return s_uiSpritePool
end

function UISpritePool:__init()
    self._pool = {}
end

function UISpritePool:loadResources(searchPath)
    local texNames = AssetManager.getAllFiles(searchPath, ".png", true, false, true)
    for _, texPath in pairs(texNames) do
        local absPath = Path.join(searchPath, texPath) .. ".png"
        local texName = texPath
        UITexturePool.register(texName, TextureManager.loadImmediately(absPath))
    end

    for _, texPath in pairs(texNames) do
        local texName = texPath
        local cfgPath = Path.join(searchPath, texPath) .. ".json"
        local sprite
        if AssetManager.isPathExist(cfgPath) then
            sprite = UISprite.new()
            local json = AssetManager.readAsString(cfgPath)
            sprite:fromJson(json)
        else
            sprite = UISprite.new(texName)
        end
        --print("loading sprite: " .. texName)
        self:add(texName, sprite)
    end
end

---add
---@param name string
---@param sprite UISprite
function UISpritePool:add(name, sprite)
    self._pool[name] = sprite:clone()
end

---@param name string
---@return boolean
function UISpritePool:has(name)
    return self._pool[name] ~= nil
end

---get
---@param name string
---@return UISprite
function UISpritePool:get(name)
    local sprite = self._pool[name]
    assert(sprite ~= nil, "cannot find " .. name .. " in UISpritePool.")
    return sprite:clone()
end

function UISpritePool:clear()
    for k in pairs(self._pool) do
        self._pool[k] = nil
    end
end

return UISpritePool