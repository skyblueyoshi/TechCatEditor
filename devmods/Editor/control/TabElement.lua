---@class TCE.TabElement:TCE.BaseControl
local TabElement = class("TabElement", require("BaseControl"))
local UIFactory = require("core.UIFactory")

function TabElement:__init(parent, config, data, location, tabIndex)
    TabElement.super.__init(self, parent, config, data)
    self._tabIndex = tabIndex

    self:_initContent(location)
end

function TabElement:destroy()
    if self:isDestroyed() then
        return
    end

    TabElement.super.destroy(self)
end

function TabElement:_initContent(location)
    local name = string.format("tab_%d", self._tabIndex)
    self._root = UIFactory.newPanel(self._parent, name, location)
    if self._data.Text then
        local TEXT_OFFSET = 8
        local text = UIFactory.newText(self._root, "cap", { 0, 0 }, self._data.Text, {
            margins = { 0, 0, 0, 0, false, false }
        })
        local textWidth = text.width
        self._root.width = math.max(self._root.width, textWidth + TEXT_OFFSET * 2)
        self._root:applyMargin(true)
    end
end

return TabElement