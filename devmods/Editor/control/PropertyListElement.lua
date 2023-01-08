---@class TCE.PropertyListElement:TCE.BaseControl
local PropertyListElement = class("PropertyListElement", require("BaseControl"))
local UIUtil = require("core.UIUtil")

function PropertyListElement:__init(propertyType, panelName, root, parent, data, index)
    PropertyListElement.super.__init(self, "", parent, nil, data, {})
    self._propertyType = propertyType
    self._panelName = panelName
    self._index = index
    self._root = root
    self:_initContent()
end

---@return TCE.PropertyListElementData
function PropertyListElement:getData()
    return self._data
end

function PropertyListElement:_initContent()
    self:adjustLayout(true)
end

function PropertyListElement:adjustLayout(isInitializing, _)
    local data = self:getData()

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

function PropertyListElement:getConfigData()
    local parentData = self._parent:getData() ---@type TCE.PropertyListData
    return parentData:getConfig():getElements()[self:getData():getConfigIndex()]
end

function PropertyListElement:getElementPanel()
    local panelElement = self._root:getChild("panel_element")
    return panelElement:getChild(self._panelName)
end

function PropertyListElement:getElementSubPanel()
    return self:getElementPanel():getChild("sub")
end

function PropertyListElement:getValue()
    return self:getData():getValue()
end

function PropertyListElement:setValue(value)
    --self:getData():setValue(value)
    self:getData():request("value", value)
end

function PropertyListElement:onDataChanged(_)
    self:adjustLayout(false)
end

function PropertyListElement.makeSubPanel(panelName, panelElement)
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

return PropertyListElement