---@class TCE.RenderTargetView:TCE.BaseControl
local RenderTargetView = class("RenderTargetView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")
local Enum = require("shaderlab.ShaderLabEnum")
local Operation = Enum.Operation

function RenderTargetView:__init(name, parent, parentRoot, data, location)
    RenderTargetView.super.__init(self, name, parent, parentRoot, data, location)
    self._rtNode = nil
    self.sa = SpriteAnimation.new()

    self.sa:getRoot().textureLocation = UISpritePool.getInstance():get("check_box_true").textureLocation
    self.sa:getRoot().sourceRect = Rect.new(0, 0, 16, 16)
    self.sa:getRoot().scale = Vector2.new(4, 4)
    
    self.sa2 = SpriteAnimation.new()
    self.sa2:getRoot().textureLocation = UISpritePool.getInstance():get("check_box_false").textureLocation
    self.sa2:getRoot().sourceRect = Rect.new(0, 0, 16, 16)
    self.sa2:getRoot().scale = Vector2.new(2, 2)
    self.sa2:getRoot().slices9Enabled = true
    self.sa2:getRoot().slices9DisplaySize = Size.new(100,100)
    self.sa2:getRoot().slices9.left = 4
    self.sa2:getRoot().slices9.right = 4
    self.sa2:getRoot().slices9.top = 4
    self.sa2:getRoot().slices9.bottom = 4

    local i = self.sa:getRoot():addChild()
    local child = self.sa:getRoot():getChild(i)
    child.textureLocation = UISpritePool.getInstance():get("icon_16_go").textureLocation
    child.sourceRect = TextureManager.getSourceRect(child.textureLocation)
    child.offset = Vector2.new(0, 16)
    child.scale = Vector2.new(2, 2)
    child.origin = Vector2.new(child.sourceRect.width / 2, child.sourceRect.height / 2)
    

    local ShaderGraph = require("shaderlab.ShaderLab")
    local g = ShaderGraph.new()
    local nno = g:addNode(Operation.VertexShaderOutput, Vector2.new(10, 10))
    local nn = g:addNode(Operation.VertexTextureCoordinate, Vector2.new(101, 10))
    local dd = g:addNode(Operation.Dot, Vector2.new(210, 10))
    local tt = g:addNode(Operation.TextureSampler2D, Vector2.new(310, 10))
    local pp = g:addNode(Operation.Parameter, Vector2.new(410, 10))
    -- dd:addLink(nn, 1, 1)
    -- dd:addLink(nn, 2, 1)
    
    -- tt:addLink(pp, 1, 1)
    -- tt:addLink(nn, 2, 1)
    
    -- nno:addLink(tt, 1, 1)
    -- nno:addLink(dd, 2, 1)
    
    --local cc = g:solve()
    --print(cc)
    self.g = g
    self._lastMousePos = nil

    --self.tickScheduler = IntegratedClient.main:createSchedule(1)
    --IntegratedClient.main:getSchedule(self.tickScheduler):addListener({self._onTick, self})    

    self:_initContent(location)
end

function RenderTargetView:onDestroy()
    --IntegratedClient.main:removeSchedule(self.tickScheduler)
    RenderTargetView.super.onDestroy(self)
end

function RenderTargetView:_onTick()
    
end

function RenderTargetView:_initContent(location)
    self:adjustLayout(true, location)
    self._rtNode:addRenderTargetListener({ self._testRT, self })
    --self._rtNode:getPostDrawLayer(0):setSpriteAnimation(self.sa)
    self._rtNode:addMousePointedListener({ self._onMouseMove, self })
    self._rtNode:addTouchDownListener({ self._onTouchDown, self })
    self._rtNode:addTouchUpListener({ self._onTouchUp, self })
    self._rtNode:addTouchMoveListener({ self._onTouchMove, self })
end

function RenderTargetView:_onMouseMove(_)
    local pos = Input.mouse.position - self._rtNode.positionInCanvas
    if self._lastMousePos ~= nil and self._lastMousePos == pos then
        return
    end
    self._lastMousePos = pos
    local changed = self.g:onMouseMove(pos.x, pos.y)
    if changed then
        self._rtNode:flushRender()
    end
end

---@param touch Touch
function RenderTargetView:_onTouchDown(_, touch)
    local pos = touch.position - self._rtNode.positionInCanvas
    local changed = self.g:onTouchDown(pos.x, pos.y)
    if changed then
        self._rtNode:flushRender()
    end
end

---@param touch Touch
function RenderTargetView:_onTouchUp(_, touch)
    local pos = touch.position - self._rtNode.positionInCanvas
    local changed = self.g:onTouchUp(pos.x, pos.y)
    if changed then
        self._rtNode:flushRender()
    end
end

---@param touch Touch
function RenderTargetView:_onTouchMove(_, touch)
    local pos = touch.position - self._rtNode.positionInCanvas
    local changed = self.g:onTouchMove(pos.x, pos.y)
    if changed then
        self._rtNode:flushRender()
    end
end

function RenderTargetView:adjustLayout(isInitializing, location)
    self._root = UIUtil.ensurePanel(self._parentRoot, "rt_view", location, {
        layout = "FULL",
    }, false, false)
    if isInitializing then
        self._rtNode = UIRenderTargetNode.new("rt", 0, 0, 32, 32)
        self._root:addChild(self._rtNode)
        UIUtil.setCommonByCfg(self._rtNode, {
            layout = "FULL",
        })
    end
end

function RenderTargetView:_testRT(n, w, h)
    GraphicsDevice.drawRect2D(RectFloat.new(0, 0, w, h), Color.new(40, 45, 59))
    -- Sprite.beginBatch()

    -- for i = 1, 6 do
    --     local pos = Vector2.new(8 + i * 16, h / 2 + math.cos(i * 0.3) * 60)
    --     self.sa:drawTS(pos, Vector2.new(2,2))
    -- end
    -- self.sa2:drawT(Vector2.new(400, 100))
    -- Sprite.endBatch()
    -- print(w, h)
    self.g:render(w, h)
end

return RenderTargetView