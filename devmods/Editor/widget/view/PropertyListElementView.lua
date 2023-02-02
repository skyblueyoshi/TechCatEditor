---@class TCE.PropertyListElementView:TCE.BaseView
local PropertyListElementView = class("PropertyListElementView", require("BaseView"))
local UIUtil = require("core.UIUtil")

function PropertyListElementView:__init(propertyType, panelName, root, index, widget, parent)
    PropertyListElementView.super.__init(self, index, widget, parent, "None")
    self._propertyType = propertyType
    self._panelName = panelName
    self._index = index
    self._root = root
    self:_initContent()
end

---@return TCE.PropertyListElement
function PropertyListElementView:getWidget()
    return self._widget
end

function PropertyListElementView:_initContent()
    self:adjustLayout(true)
end

function PropertyListElementView:adjustLayout(isInitializing, _)
    local data = self:getWidget()

    -- 仅显示当前指定的panel
    local panelElement = self._root:getChild("panel_element")
    for i = 1, panelElement:getChildrenCount() do
        local node = panelElement:getChildByIndex(i - 1)
        node.visible = (node.name == self._panelName)
    end
    local text = data:getText()

    local panel = self:getElementPanel()
    local subPanel = self:getElementSubPanel()

    -- 标题
    local cap = UIText.cast(panel:getChild("cap"))
    cap.text = text

    if self._nodeListeners ~= nil then
        for nodeName, ls in pairs(self._nodeListeners) do
            local tempNode = subPanel:getChild(nodeName)
            assert(tempNode:valid(), "missing node: " .. nodeName)
            if isInitializing then
                local uiTypeName = tempNode:getTypeName()
                if uiTypeName == "InputField" then
                    if ls.OnBeginEditing ~= nil then
                        UIInputField.cast(tempNode):addBeginEditingListener({ ls.OnBeginEditing, self })
                    end
                    if ls.OnFinishedEditing ~= nil then
                        UIInputField.cast(tempNode):addFinishedEditingListener({ ls.OnFinishedEditing, self })
                    end
                end
                if ls.OnTouchBegin ~= nil then
                    tempNode:addTouchDownListener({ ls.OnTouchBegin, self })
                end
                if ls.OnTouchEnd ~= nil then
                    tempNode:addTouchUpListener({ ls.OnTouchEnd, self })
                end
            end
            if ls.OnCheckEvent ~= nil then
                ls.OnCheckEvent(self, tempNode)
            end
        end
    end

    self._root:applyMargin(true)
end

function PropertyListElementView:getConfigData()
    local parentData = self._parent:getWidget() ---@type TCE.PropertyListData
    return parentData:getConfig():getElements()[self:getWidget():getConfigIndex()]
end

function PropertyListElementView:getElementPanel()
    local panelElement = self._root:getChild("panel_element")
    return panelElement:getChild(self._panelName)
end

function PropertyListElementView:getElementSubPanel()
    return self:getElementPanel():getChild("sub")
end

function PropertyListElementView:getValue()
    return self:getWidget():getValue()
end

function PropertyListElementView:setValue(value)
    --self:getWidget():setValue(value)
    --self:getWidget():request("value", value)
end

function PropertyListElementView:onNotifyChanges(_, _)
    self:adjustLayout(false)
end

function PropertyListElementView.makeSubPanel(panelName, panelElement)
    local panelCheck = UIUtil.ensurePanel(panelElement, panelName, nil, {
        layout = "FULL",
    }, false, false)
    local capWidthRate = 0.5
    UIUtil.ensureText(panelCheck, "cap", { 4, 0, 32, 32 }, "Cap", {
        layout = "CENTER_H",
        widthRate = capWidthRate,
        autoAdaptSize = false,
        verticalAlignment = TextAlignment.VCenter,
        horizontalOverflow = TextHorizontalOverflow.Discard,
    })
    local subPanel = UIUtil.ensurePanel(panelCheck, "sub", { 0, 0, 140, 32 }, {
        margins = { nil, 0, 0, 0, false, true },
        widthRate = 1 - capWidthRate - 0.02,
    }, false, false)

    return subPanel
end

return PropertyListElementView