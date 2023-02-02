local PropertyListElementView = require("PropertyListElementView")
---@class TCE.PropertyListElementView_Input:TCE.PropertyListElementView
local PropertyListElementView_Input = class("PropertyListElement_Input", PropertyListElementView)
local UIUtil = require("core.UIUtil")

function PropertyListElementView_Input:__init(propertyType, panelName, root, index, widget, parent)
    PropertyListElementView_Input.super.__init(self, propertyType, panelName, root, index, widget, parent)
end

function PropertyListElementView_Input._ensureElementPanel(panelName, panelElement)
    local subPanel = PropertyListElementView.makeSubPanel(panelName, panelElement)
    local panelInput = UIUtil.ensurePanel(subPanel, "panel_input", nil, {
        margins = { 1, 1, 1, 1, true, true },
        bgColor = "B",
    })
    UIUtil.ensurePanel(panelInput, "sd", nil, {
        layout = "FULL",
        bgColor = "A2",
        borderColor = "SD",
    })
    UIUtil.ensureInputField(panelInput, "in", nil, "123", {
        margins = { 8, 0, 8, 0, true, true },
        isSelectAllFirstClicked = true,
    })
end

function PropertyListElementView_Input:setBgSelected(selected)
    local sd = self:getElementSubPanel():getChild("panel_input.sd")
    sd.visible = selected
end

function PropertyListElementView_Input:_onEditBegin(_)
    self:setBgSelected(true)
end

---@param node UINode
function PropertyListElementView_Input:_onEditNumFinished(node, castInt)
    local rawText = UIInputField.cast(node).text
    local num = tonumber(rawText)
    if num == nil then
        num = 0
    else
        if castInt then
            num = math.floor(num)
        end
    end
    local ex = self:getConfigData():getParams()
    if ex.limits ~= nil and #ex.limits >= 2 then
        num = math.max(ex.limits[1], math.min(ex.limits[2], num))
    end
    self:setValue(num)
    self:_setEditNum(node)
end

---@param node UINode
function PropertyListElementView_Input:_onEditIntFinished(node)
    self:_onEditNumFinished(node, true)
end

---@param node UINode
function PropertyListElementView_Input:_onEditFloatFinished(node)
    self:_onEditNumFinished(node, false)
end

---@param node UINode
function PropertyListElementView_Input:_setEditNum(node)
    local value = self:getValue()
    local input = UIInputField.cast(node)
    input.text = tostring(value)

    self:setBgSelected(false)
end

return PropertyListElementView_Input