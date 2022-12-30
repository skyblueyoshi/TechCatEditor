---@API

---@class UIText:UINode 描述一个UI文本。
---@field horizontalAlignment TextAlignment_Value 文本的横向对其方式。
---@field verticalAlignment TextAlignment_Value 文本的纵向对其方式。
---@field verticalOverflow TextHorizontalOverflow_Value 文本的纵向溢出方式。
---@field horizontalOverflow TextVerticalOverflow_Value 文本的横向溢出方式。
---@field text string 文本内容。
---@field fontName string 所使用的字体。
---@field fontSize number 字体大小。
---@field color Color 文本颜色。
---@field autoAdaptSize boolean 是否自动根据文本内容适配尺寸。
---@field displayTextSize Size 返回文本显示区域大小。
---@field preferredSize Size
---@field preferredWidth number
---@field preferredHeight number
---@field isRichText boolean 文本是否表示富文本。
---@field outlineSize number 文本的描边尺寸。
---@field outlineColor Color 文本的描边颜色。
---@field isBatchMode boolean 是否对所有文本进行合批渲染。
local UIText = {}

---@overload fun(name:string):UIText
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIText
function UIText.new(name, x, y, width, height)
end

---
---@param value UIText
---@return UIText
function UIText.clone(value)
end

---
---@param uiNode UINode
---@return UIText
function UIText.cast(uiNode)
end

---添加一个文本变化监听器，在文本内容变化时触发。
---@param listener table|function
---@return ListenerID
function UIText:addTextChangedListener(listener)
end

---
---@param listenerID ListenerID
function UIText:removeTextChangedListener(listenerID)
end

return UIText