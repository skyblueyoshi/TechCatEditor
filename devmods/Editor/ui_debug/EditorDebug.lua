---@class TCE:EditorDebug
local EditorDebug = class("EditorDebug")
local EditorDebugConfig = require("config.EditorDebugConfig")
local UISpritePool = require("core.UISpritePool")

function EditorDebug:__init(baseCanvas)
    self._baseCanvas = baseCanvas
    self._canvasDbgGo = GameObject.instantiate()
    self._canvasDbgGo.canvas:init()
    self._canvasDbg = self._canvasDbgGo.canvas.uiRoot
    self._lbProfiler = nil ---@type UIText
    self._imgArea = nil ---@type UIImage
    self._textArea = nil ---@type UIImage
    self._debugText = nil ---@type UIText

    self._curIndex = 0
    self._curNodeInfoList = {}

    self:_initContent()
end

function EditorDebug:destroy()
    self._baseCanvas = nil
    self._canvasDbg:removeAllChildren()
end

function EditorDebug:_initContent()
    self._canvasDbg.touchable = false
    local UIUtil = require("core.UIUtil")
    local panel = UIPanel.new("dbg_panel")
    panel:setMarginEnabled(true, true, true, true)
    panel.autoStretchWidth = true
    panel.autoStretchHeight = true
    panel.touchable = false
    --panel.sprite = UISpritePool.getInstance():get("white")
    --panel.sprite.color = Color.new(45, 45, 48)
    self._canvasDbg:addChild(panel)

    self._lbProfiler = UIText.new("profiler", 32, 180, 32, 32)
    self._lbProfiler:setBottomMargin(100, true)
    self._lbProfiler.horizontalOverflow = TextHorizontalOverflow.Overflow
    self._lbProfiler.isRichText = true
    self._lbProfiler.fontSize = 20
    panel:addChild(self._lbProfiler)

    self._imgArea = UIImage.new("area", 0, 0, 32, 32)
    self._imgArea.sprite = UISpritePool.getInstance():get("white")
    self._imgArea.sprite.color = Color.new(255, 255, 0, 64)
    self._imgArea.visible = false

    panel:addChild(self._imgArea)

    local imgAreaBorder = UIImage.new("bd")
    UIUtil.setMargins(imgAreaBorder, 0, 0, 0, 0, true, true)
    imgAreaBorder.sprite = UISpritePool.getInstance():get("white_border")
    imgAreaBorder.sprite.color = Color.Yellow
    self._imgArea:addChild(imgAreaBorder)

    local imgAreaAnchor = UIImage.new("ac", 0, 0, 4, 4)
    imgAreaAnchor:setAnchorPoint(0.5, 0.5)
    imgAreaAnchor.sprite = UISpritePool.getInstance():get("white")
    imgAreaAnchor.sprite.color = Color.Yellow
    self._imgArea:addChild(imgAreaAnchor)

    self._textArea = UIImage.new("text_area", 0, 0, 32, 32)
    self._textArea.sprite = UISpritePool.getInstance():get("white")
    self._textArea.sprite.color = Color.new(0, 0, 0, 128)
    self._textArea.visible = false
    panel:addChild(self._textArea)

    local textAreaBorder = UIImage.new("bd")
    UIUtil.setMargins(textAreaBorder, 0, 0, 0, 0, true, true)
    textAreaBorder.sprite = UISpritePool.getInstance():get("white_border")
    textAreaBorder.sprite.color = Color.new(64, 64, 64)
    self._textArea:addChild(textAreaBorder)

    self._debugText = UIText.new("text", 8, 8, 32, 32)
    self._debugText.fontSize = 20
    self._debugText.horizontalOverflow = TextHorizontalOverflow.Overflow
    self._debugText.color = Color.White
    self._debugText.autoAdaptSize = true
    self._textArea:addChild(self._debugText)

    Input.keyboard:getHotKeys(Keys.F1):addListener({ self._recapture, self })
    Input.keyboard:getHotKeys(Keys.F2):addListener({ self._triggerShowDebug, self })
    Input.mouse:addScrollListener({ self._scrollDisplayNodeInfo, self })

end

function EditorDebug:update()
    if EditorDebugConfig.ShowUIDebug then
        self._canvasDbg.visible = true

        self._lbProfiler.text = string.format("FPS:%d \nLogic:%d \nBatches:%d \nTriangles:%d",
                IntegratedClient.main.fps,
                IntegratedClient.main.gameSpeed,
                GraphicsDevice.drawCalls,
                GraphicsDevice.primitiveCount
        )

        if self._textArea.visible then
            local pointer = self._baseCanvas:screenPointToCanvasPoint(Input.mouse.position)
            self._textArea:setPosition(pointer.x + 16, pointer.y + 16)
            self:_clampIn(self._textArea)
        end
    else
        self._canvasDbg.visible = false
    end
end

---_clampIn
---@param node UINode
function EditorDebug:_clampIn(node)
    if node.positionX < 0 then
        node.positionX = 0
    elseif node.positionX + node.width > self._canvasDbg.width then
        node.positionX = self._canvasDbg.width - node.width
    end
    if node.positionY < 0 then
        node.positionY = 0
    elseif node.positionY + node.height > self._canvasDbg.height then
        node.positionY = self._canvasDbg.height - node.height
    end
end

function EditorDebug:_triggerShowDebug()
    EditorDebugConfig.ShowUIDebug = not EditorDebugConfig.ShowUIDebug
end

function EditorDebug:_recapture()
    if not EditorDebugConfig.ShowUIDebug then
        return
    end

    local pointer = self._baseCanvas:screenPointToCanvasPoint(Input.mouse.position)
    local nodes = self._baseCanvas:getAllPointedNodes(pointer)
    self._curIndex = 0
    self._curNodeInfoList = {}
    ---@param node UINode
    for i, node in ipairs(nodes) do
        if node.name ~= "popup_area" then
            self:_genNodeInfo(node)
        end
    end
    if #self._curNodeInfoList > 0 then
        self._curIndex = 1
    end
    self:_updateDisplayNodeInfo()
end

function EditorDebug:_scrollDisplayNodeInfo(_, d)
    if not EditorDebugConfig.ShowUIDebug then
        return
    end
    if self._curIndex == 0 then
        return
    end
    if d < 0 then
        self._curIndex = self._curIndex + 1
        if self._curIndex > #self._curNodeInfoList then
            self._curIndex = 1
        end
    elseif d > 0 then
        self._curIndex = self._curIndex - 1
        if self._curIndex < 1 then
            self._curIndex = #self._curNodeInfoList
        end
    end
    self:_updateDisplayNodeInfo()
end

function EditorDebug:_updateDisplayNodeInfo()
    if self._curIndex == 0 then
        self._textArea.visible = false
        self._imgArea.visible = false
        return
    end
    local info = self._curNodeInfoList[self._curIndex]

    self._imgArea.position = info.Pos
    self._imgArea.size = info.Size
    self._imgArea.visible = true
    self._imgArea:applyMargin(true)

    local ac = self._imgArea:getChild("ac")
    ac:setPosition(info.Anchor.x * info.Size.width, info.Anchor.y * info.Size.height)

    local text = string.format("(%d/%d)", self._curIndex, #self._curNodeInfoList) .. "\n"
    self._debugText.text = text .. info.Info
    self._debugText.visible = true

    self._textArea:setSize(self._debugText.width + 16, self._debugText.height + 16)
    self._textArea.visible = true
    self._textArea:applyMargin(true)

    self:_clampIn(self._textArea)
end

---_genNodeInfo
---@param node UINode
function EditorDebug:_genNodeInfo(node)
    local targetText = ""

    local name = node.name
    local parent = node:getParent()
    while parent:valid() do
        name = parent.name .. "." .. name
        parent = parent:getParent()
    end
    local type = node:getTypeName()

    targetText = targetText .. "Type: " .. type .. "\n"
    targetText = targetText .. "Path: " .. name .. "\n"
    targetText = targetText .. string.format("Pos: (%f, %f)", node.positionX, node.positionY) .. "\n"
    targetText = targetText .. string.format("GPos: (%f, %f)", node.positionInCanvas.x, node.positionInCanvas.y) .. "\n"
    targetText = targetText .. string.format("Size: (%d, %d)", node.width, node.height) .. "\n"
    targetText = targetText .. string.format("Tag: %d", node.tag) .. "\n"

    local marginText = ""
    if node.topMarginEnabled then
        marginText = marginText .. "[↑" .. tostring(node.topMargin) .. "] "
    end
    if node.bottomMarginEnabled then
        marginText = marginText .. "[↓" .. tostring(node.bottomMargin) .. "] "
    end
    if node.leftMarginEnabled then
        marginText = marginText .. "[←" .. tostring(node.leftMargin) .. "] "
    end
    if node.rightMarginEnabled then
        marginText = marginText .. "[→" .. tostring(node.rightMargin) .. "] "
    end
    if node.autoStretchWidth then
        marginText = marginText .. "[←→]" .. " "
    end
    if node.autoStretchHeight then
        marginText = marginText .. "[↑↓]" .. " "
    end
    if marginText ~= "" then
        targetText = targetText .. "Margin: " .. marginText .. "\n"
    end
    if node.enableRenderTarget then
        targetText = targetText .. "RenderTarget: True\n"
    end

    if type == "Text" then
        local hNode = UIText.cast(node)
        targetText = targetText .. "Text: " .. "\"" .. hNode.text .. "\"" .. "\n"
    end

    targetText = targetText:sub(1, -2)

    table.insert(self._curNodeInfoList, {
        Info = targetText,
        Pos = node.positionInCanvas,
        Anchor = node.anchorPoint,
        Size = node.size,
    })
end

return EditorDebug