local BaseWidget = require("BaseWidget")
---@class TCE.RenderTarget:TCE.BaseWidget
local RenderTarget = class("RenderTarget", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
}

function RenderTarget:__init()
    RenderTarget.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function RenderTarget:setText(text)
    self:_set("text", text)
end

---@return string
function RenderTarget:getText()
    return self["text"]
end

return RenderTarget