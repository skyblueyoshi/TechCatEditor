---@class TCE.WidgetPoolImpl
local WidgetPoolImpl = class("WidgetPool")
---@class TCE.WidgetPoolInstance
local WidgetPoolInstance = class("WidgetPoolInstance")

local s_instance
function WidgetPoolInstance.get()
    if s_instance == nil then
        s_instance = WidgetPoolInstance.new()
    end
    return s_instance
end

function WidgetPoolInstance:__init()
    self._pool = {}
end

function WidgetPoolInstance:load(widgetTypeName, data)
    local Widget = require(widgetTypeName)
    local widget = Widget.new()
    self._pool[widget] = true
    if data ~= nil then
        widget:load(data)
    end
    return widget
end

function WidgetPoolInstance:recycle()
    local widgets = {}  ---@type TCE.BaseWidget[]
    for widget, _ in pairs(self._pool) do
        if widget:canFree() then
            table.insert(widgets, widget)
        end
    end
    for _, widget in ipairs(widgets) do
        widget:destroy()
        self._pool[widget] = nil
    end
    return #widgets
end

---回收未使用的控件。
---@return number 总回收数量。
function WidgetPoolImpl.recycle()
    return WidgetPoolInstance.get():recycle()
end

---@param widgetTypeName string
---@param data table
---@return TCE.BaseWidget
function WidgetPoolImpl.load(widgetTypeName, data)
    return WidgetPoolInstance.get():load(widgetTypeName, data)
end

return WidgetPoolImpl