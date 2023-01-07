---@class TCE.Editor
local Editor = class("Editor")
local UISpritePool = require("core.UISpritePool")
local EditorDebug = require("ui_debug.EditorDebug")

function Editor:__init()
    TextureManager.setGcEnabled(false)

    self._cameraGo = GameObject.instantiate()
    self._cameraGo.camera:init()

    self._canvasGo = GameObject.instantiate()
    self._canvasGo.canvas:init()
    self._canvas = self._canvasGo.canvas.uiRoot

    UISpritePool.getInstance():loadResources("mods/Editor/ui_res")

    self:_initCanvas()

    self._uiDebug = EditorDebug.new(self._canvas)
end

function Editor:start()
    IntegratedClient.main.isMaxFPS = true
end

function Editor:destroy()
    self._canvas:removeAllChildren()
    self._uiDebug:destroy()
end

function Editor:update()
    self._uiDebug:update()
    --self:getRoot():getChild("rt"):flushRender()
    collectgarbage()
end

function Editor:render()
    --GraphicsDevice.clear(Color.new(100, 100, 100))
end

function Editor:_initCanvas()
    local panel = UIPanel.new("panel")
    panel.enableRenderTarget = false
    panel:setMarginEnabled(true, true, true, true)
    panel.autoStretchWidth = true
    panel.autoStretchHeight = true
    --panel.sprite = UISpritePool.getInstance():get("white")
    --panel.sprite.color = Color.new(45, 45, 48)
    self._canvas:addChild(panel)

    local TestData = require("config.TestData")
    local UIData = require("control.data.UIData")
    self._wd = require("control.Window").new("win", self, self:getRoot(),
            UIData.create("ContainerData", TestData), nil)

    --local rt = UIRenderTargetNode.new("rt", 0, 0, 128, 128)
    --self:getRoot():addChild(rt)
    --
    --local function _testRender(_, w, h)
    --    --Sprite.flush()
    --    Sprite.draw(UISpritePool.getInstance():get("check_box_true").textureLocation,
    --            Vector2.new(1, 1), Rect.new(0, 0, 32, 32), Color.White, 0)
    --
    --end
    --rt:addRenderTargetListener(_testRender)
    --
    --local img = UIImage.new("img")
    --img.sprite = UISpritePool.getInstance():get("icon_go")
    --self:getRoot():addChild(img)
end

function Editor:getRoot()
    return self._canvas:getChild("panel")
end

return Editor