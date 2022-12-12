---@class UIInputField:UINode
---@field horizontalAlignment TextAlignment_Value
---@field verticalAlignment TextAlignment_Value
---@field text string
---@field fontName string
---@field fontSize number
---@field color Color
---@field lineType TextEditLineType_Value
---@field isEditing boolean
---@field isSelectAllFirstClicked boolean
local UIInputField = {}

---new
---@overload fun(name:string):UIInputField
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIInputField
function UIInputField.new(name, x, y, width, height)
end

---
---@param value UIInputField
---@return UIInputField
function UIInputField.clone(value)
end

---case
---@param uiNode UINode
---@return UIInputField
function UIInputField.cast(uiNode)
end

function UIInputField:cancelSelection()
end

function UIInputField:setAllSelection()
end

function UIInputField:setCaretToStart()
end

function UIInputField:setCaretToEnd()
end

---
---@param listener table|function
---@return ListenerID
function UIInputField:addTextChangedListener(listener)
end

---
---@param listenerID ListenerID
function UIInputField:removeTextChangedListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UIInputField:addBeginEditingListener(listener)
end

---
---@param listenerID ListenerID
function UIInputField:removeBeginEditingListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UIInputField:addFinishedEditingListener(listener)
end

---
---@param listenerID ListenerID
function UIInputField:removeFinishedEditingListener(listenerID)
end

return UIInputField