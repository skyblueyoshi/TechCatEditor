local BaseWidget = require("BaseWidget")
---@class TCE.PropertyListElement:TCE.BaseWidget
local PropertyListElement = class("PropertyListElement", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    text = BaseWidget.newPropDef({ "" }),
    configIndex = BaseWidget.newPropDef({ 0 }),
    value = BaseWidget.newPropDef({ nil }),
    params = BaseWidget.newPropDef({ {} }),
}

function PropertyListElement:__init()
    PropertyListElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param text string
function PropertyListElement:setText(text)
    self:_set("text", text)
end

---@return string
function PropertyListElement:getText()
    return self["text"]
end

---@param configIndex number
function PropertyListElement:setConfigIndex(configIndex)
    self:_set("configIndex", configIndex)
end

---@return number
function PropertyListElement:getConfigIndex()
    return self["configIndex"]
end

---@param value any
function PropertyListElement:setValue(value)
    self:_set("value", value)
end

---@return any
function PropertyListElement:getValue()
    return self["value"]
end

---@param params table
function PropertyListElement:setParams(params)
    self:_set("params", params)
end

---@return table
function PropertyListElement:getParams()
    return self["params"]
end

return PropertyListElement