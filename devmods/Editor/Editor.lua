---@class TCE.Editor
local Editor = class("Editor")
local UISpritePool = require("core.UISpritePool")
local EditorDebug = require("ui_debug.EditorDebug")

function Editor:__init()

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
end

function Editor:destroy()
    self._canvas:removeAllChildren()
    self._uiDebug:destroy()
end

function Editor:update()
    self._uiDebug:update()
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
    self._wd = require("control.Window").new(self, self:getRoot(), TestData, nil)

end

function Editor:getRoot()
    return self._canvas:getChild("panel")
end

return Editor