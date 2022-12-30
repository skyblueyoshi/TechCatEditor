---@API

---@class TextVerticalOverflow_Value 枚举值类型。

---@class TextVerticalOverflow 描述文本竖直溢出方案。
---@field Truncate TextVerticalOverflow_Value 文本不能超过竖直边界。
---@field Overflow TextVerticalOverflow_Value 文本可以超过竖直边界继续显示。
local TextVerticalOverflow = {}

return TextVerticalOverflow