---@class TCE.RenderTargetView:TCE.BaseControl
local RenderTargetView = class("RenderTargetView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local Button = require("Button")
local Container = require("Container")
local UISpritePool = require("core.UISpritePool")

function RenderTargetView:__init(parent, parentRoot, data, location)
    RenderTargetView.super.__init(self, parent, parentRoot, data, location)
    self.sa = SpriteAnimation.new()

    self.sa:getRoot().textureLocation = UISpritePool.getInstance():get("check_box_true").textureLocation
    self.sa:getRoot().sourceRect = Rect.new(0, 0, 16, 16)
    self.sa:getRoot().scale = Vector2.new(4, 4)

    local i = self.sa:getRoot():addChild()
    local child = self.sa:getRoot():getChild(i)
    child.textureLocation = UISpritePool.getInstance():get("icon_go").textureLocation
    child.sourceRect = TextureManager.getSourceRect(child.textureLocation)
    child.offset = Vector2.new(0, 16)
    child.scale = Vector2.new(2, 2)
    child.origin = Vector2.new(child.sourceRect.width / 2, child.sourceRect.height / 2)
    self:_initContent(location)
end

function RenderTargetView:onDestroy()
    RenderTargetView.super.onDestroy(self)
end

function RenderTargetView:_initContent(location)
    self._root = UIUtil.newPanel(self._parentRoot, "rt_view", location, {
        layout = "FULL",
    }, false, false)

    local rt = UIRenderTargetNode.new("rt", 0, 0, 32, 32)
    self._root:addChild(rt)
    UIUtil.setCommonByCfg(rt, {
        layout = "FULL",
    })
    rt:addRenderTargetListener({ self._testRT, self })
    rt:getPostDrawLayer(0):setSpriteAnimation(self.sa)
end

function RenderTargetView:_testRT(n, w, h)
    GraphicsDevice.drawRect2D(RectFloat.new(0, 0, w, h), Color.Black)
    Sprite.beginBatch()

    for i = 1, 6 do
        --local pos = Vector2.new(8 + i * 16, h / 2 + math.cos(i * 0.3) * 60)
        --self.sa:drawTS(pos, Vector2.new(8,8))
    end
    Sprite.endBatch()
end

return RenderTargetView