local BaseWidget = require("BaseWidget")
---@class TCE.GridElement:TCE.BaseWidget
local GridElement = class("GridElement", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
}

function GridElement:__init()
    GridElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function GridElement:setText(text)
    self:_set("text", text)
end

---@return string
function GridElement:getText()
    return self["text"]
end

return GridElement