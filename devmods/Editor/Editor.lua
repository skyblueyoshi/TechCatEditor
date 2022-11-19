---@class TCE.Editor
local Editor = class("Editor")
local EditorDebugConfig = require("config.EditorDebugConfig")
local UISpritePool = require("core.UISpritePool")

function Editor:__init()

    self._cameraGo = GameObject.instantiate()
    self._cameraGo.camera:init()

    self._canvasGo = GameObject.instantiate()
    self._canvasGo.canvas:init()
    self._canvas = self._canvasGo.canvas.uiRoot

    self._canvasDbgGo = GameObject.instantiate()
    self._canvasDbgGo.canvas:init()
    self._canvasDbg = self._canvasDbgGo.canvas.uiRoot
    self._debugRect = nil
    self._debugPoint = nil

    UISpritePool.getInstance():loadResources("mods/Editor/ui_res")
    self:_initCanvas()
    self:_initDebugCanvas()
end

function Editor:start()
end

function Editor:destroy()
    self._canvas:removeAllChildren()
    self._canvasDbg:removeAllChildren()
end

function Editor:update()
    if EditorDebugConfig.ShowUIDebug then
        self._canvasDbg.visible = true

        local lbText = UIText.cast(self._canvasDbg:getChild("dbg_panel.text"))
        local lbText2 = UIText.cast(self._canvasDbg:getChild("dbg_panel.text2"))
        lbText2.text = string.format("FPS:%d \nLogic:%d \nBatches:%d \nTriangles:%d",
                IntegratedClient.main.fps,
                IntegratedClient.main.gameSpeed,
                GraphicsDevice.drawCalls,
                GraphicsDevice.primitiveCount
        )

        local pointer = self._canvas:screenPointToCanvasPoint(Input.mouse.position)
        local node = self._canvas:getPointedNode(pointer)

        if node:valid() then
            local nodeScreenPos = self._canvas:canvasPointToScreenPoint(node.positionInCanvas)
            local bound = RectFloat.new(nodeScreenPos.x, nodeScreenPos.y, node.size.width, node.size.height)
            self._debugRect = bound
            self._debugPoint = Vector2.new(
                    bound.x + bound.width * node.anchorPointX,
                    bound.y + bound.height * node.anchorPointY
            )
            lbText.text = node.name ..
                    " (position:" .. tostring(node.positionInCanvas) ..
                    " size:" .. tostring(node.size) .. ")"
        else
            self._debugRect = nil
            self._debugPoint = nil
            lbText.text = "[UI Debug Mode]"
        end
        lbText.visible = true

        lbText.visible = false
    else
        self._canvasDbg.visible = false
    end
    collectgarbage()
end

function Editor:render()
    --GraphicsDevice.clear(Color.new(100, 100, 100))
end

function Editor:_initCanvas()
    local panel = UIPanel.new("panel")
    panel.enableRenderTarget = true
    panel:setMarginEnabled(true, true, true, true)
    panel.autoStretchWidth = true
    panel.autoStretchHeight = true
    --panel.sprite = UISpritePool.getInstance():get("white")
    --panel.sprite.color = Color.new(45, 45, 48)
    self._canvas:addChild(panel)

    local data = {
        {
            Text = "新建模组...",
        },
        {
            Text = "打开...",
            HotKeys = {
                "Ctrl", "Shift", "Q"
            }
        },
        {
            Text = "测试内容",
            HotKeys = {
                "Ctrl", "Q"
            },
            Children = {
                {
                    Text = "测试...",
                },
                {
                    Text = "测试222...",
                    Children = {
                        {
                            Text = "模组测试1...",
                            HotKeys = {
                                "Ctrl", "Shift", "Q"
                            }
                        },
                        {
                            Text = "模组测试123...",
                            HotKeys = {
                                "Ctrl", "Shift", "Q"
                            }
                        },
                    }
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
                {
                    Text = "测试3333...",
                },
            }
        },
        {
            Text = "测试...",
        },
        {
            Text = "测试222...",
            Children = {
                {
                    Text = "模组测试1...",
                    HotKeys = {
                        "Ctrl", "Shift", "Q"
                    }
                },
                {
                    Text = "模组测试123...",
                    HotKeys = {
                        "Ctrl", "Shift", "Q"
                    }
                },
            }
        },
        {
            Text = "测试3333...",
        },
        {
            Text = "保存",
        },
        {
            Text = "退出",
            HotKeys = {
                "Ctrl", "R"
            }
        },
    }
    self._pp = require("control.PopupMenu").new(panel, { 64, 64 }, {}, data, 0)
end

function Editor:_initDebugCanvas()
    local panel = UIPanel.new("dbg_panel")
    panel:setMarginEnabled(true, true, true, true)
    panel.autoStretchWidth = true
    panel.autoStretchHeight = true
    panel.touchable = false
    --panel.sprite = UISpritePool.getInstance():get("white")
    --panel.sprite.color = Color.new(45, 45, 48)
    self._canvasDbg:addChild(panel)

    local textDebug = UIText.new("text", 0, 0, 32, 32)
    textDebug.fontSize = 20
    textDebug.horizontalOverflow = TextHorizontalOverflow.Overflow
    textDebug.color = Color.White
    panel:addChild(textDebug)

    local textDebug2 = UIText.new("text2", 32, 180, 32, 32)
    textDebug2:setBottomMargin(100, true)
    textDebug2.horizontalOverflow = TextHorizontalOverflow.Overflow
    textDebug2.isRichText = true
    textDebug2.fontSize = 20
    panel:addChild(textDebug2)
end

return Editor