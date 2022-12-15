---@class TCE.RenderTargetView:TCE.BaseControl
local RenderTargetView = class("RenderTargetView", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local Button = require("Button")
local Container = require("Container")
local UISpritePool = require("core.UISpritePool")

function RenderTargetView:__init(parent, parentRoot, data, location)
    RenderTargetView.super.__init(self, parent, parentRoot, data, location)
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
end

function RenderTargetView:_testRT(n, w, h)
    GraphicsDevice.drawRect2D(RectFloat.new(0, 0, w, h), Color.Black)
    Sprite.beginBatch()

    local tex = UISpritePool.getInstance():get("check_box_true").textureLocation
    local rect = Rect.new(0, 0, 16, 16)

    for i = 1, 60 do
        local pos = Vector2.new(8 + i * 16, h / 2 + math.cos(i * 0.3) * 60)
        Sprite.draw(tex, pos, rect, Color.White, 0)
    end
    Sprite.endBatch()
end

return RenderTargetView