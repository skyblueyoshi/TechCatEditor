---@API

---@class TextHorizontalOverflow_Value 枚举值类型。

---@class TextHorizontalOverflow 描述文本水平溢出方案。
---@field Wrap TextHorizontalOverflow_Value 到达水平边界时，文本自动换行。
---@field Overflow TextHorizontalOverflow_Value 文本可以超过垂直边界继续显示。
---@field Discard TextHorizontalOverflow_Value 丢弃超过边界部分的文本内容。
local TextHorizontalOverflow = {}

return TextHorizontalOverflow