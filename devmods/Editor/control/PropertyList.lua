---@class TCE.PropertyList:TCE.ScrollContainer
local PropertyList = class("PropertyList", require("ScrollContainer"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")
local EventDef = require("config.EventDef")

--[[
PropertyNode：{
    str [1]  描述文字
    int [2]  使用配置id
    any [3]  当前值
}
--]]

local PROPERTY_TYPE = {
    Boolean = "Boolean",
    ComboBox = "ComboBox",
    Int = "Int",
    Float = "Float",
}

local TYPE_TO_PANEL_NAME = {
    Boolean = "panel_check",
    ComboBox = "panel_combo_box",
    Int = "panel_int",
    Float = "panel_float",
}

function PropertyList:__init(parent, parentRoot, data, location)
    PropertyList.super.__init(self, parent, parentRoot, data, {})

    self._mappingList = {}
    self._selectIndex = 0
    self._subPopupMenu = nil
    self:_initContent(location)
end

function PropertyList:onDestroy()
    self._mappingList = {}
    self:_destroySubPopupMenu()
    PropertyList.super.onDestroy(self)
end

function PropertyList:_destroySubPopupMenu()
    if self._subPopupMenu ~= nil then
        self._subPopupMenu:destroy()
        self._subPopupMenu = nil
    end
end

function PropertyList:_reloadMappingList()
    self._mappingList = {}
    for index, data in ipairs(self._data.Children) do
        table.insert(self._mappingList, { data, index })
    end
end

function PropertyList:_initContent(location)
    self:_initElementListener()
    self:_preInitScrollContainer(location)
    self:_reloadMappingList()
    self:_postInitScrollContainer()

    self:addEventListener(EventDef.ALL_POPUP_CLOSE, { self._onPopupOutsideEvent, self })
end

function PropertyList:_onCreatePanelItem()
    local panelItem = PropertyList.super._onCreatePanelItem(self)
    UIUtil.newPanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    local panelElement = UIUtil.newPanel(panelItem, "panel_element", nil, {
        layout = "FULL",
    }, false, false)

    local function _makeSubPanel(subPanelName)
        local panelCheck = UIUtil.newPanel(panelElement, subPanelName, nil, {
            layout = "FULL",
        }, false, false)
        UIUtil.newText(panelCheck, "cap", { 4, 0, 32, 32 }, "Cap", {
            layout = "CENTER_H",
        })
        local subPanel = UIUtil.newPanel(panelCheck, "sub", { 0, 0, 140, 32 }, {
            margins = { nil, 0, 0, 0, false, true },
        }, false, false)

        return subPanel
    end

    do
        local subPanel = _makeSubPanel(TYPE_TO_PANEL_NAME.Boolean)
        local checkBox = UIUtil.newPanel(subPanel, "check", { 0, 0, 16, 16 }, {
            layout = "CENTER_H",
        })
        checkBox.sprite = UISpritePool.getInstance():get("check_box_false")
    end

    do
        local subPanel = _makeSubPanel(TYPE_TO_PANEL_NAME.ComboBox)
        local combo = UIUtil.newPanel(subPanel, "combo", nil, {
            margins = { 1, 1, 1, 1, true, true },
            bgColor = "A",
        })
        UIUtil.newText(combo, "cap", { 4, 0, 32, 32 }, "Cap", {
            layout = "CENTER_H",
        })
        local arr = UIUtil.newPanel(combo, "arr", { 0, 0, 16, 16 }, {
            margins = { nil, 0, 4, 0, false, false },
        }, false, false)
        arr.sprite = UISpritePool.getInstance():get("icon_arr_down")
        arr.sprite.color = ThemeUtil.getColor("FONT_COLOR")
    end

    local function _makeValueInputPanel(typeName)
        local subPanel = _makeSubPanel(TYPE_TO_PANEL_NAME[typeName])
        local panelInput = UIUtil.newPanel(subPanel, "panel_input", nil, {
            margins = { 1, 1, 1, 1, true, true },
            bgColor = "B",
        })
        UIUtil.newPanel(panelInput, "sd", nil, {
            layout = "FULL",
            bgColor = "A2",
            borderColor = "SD",
        })
        UIUtil.newInputField(panelInput, "in", nil, "123", {
            margins = { 8, 0, 8, 0, true, true },
            isSelectAllFirstClicked = true,
        })
    end

    do
        _makeValueInputPanel(PROPERTY_TYPE.Int)
    end
    do
        _makeValueInputPanel(PROPERTY_TYPE.Float)
    end

    panelItem:applyMargin(true)
    self:_resetItemVisibleState(panelItem, nil)
    return panelItem
end

---_resetItemVisibleState
---@param panelItem UINode
---@param typeName string|nil
function PropertyList:_resetItemVisibleState(panelItem, typeName)
    local showPanelName
    if typeName ~= nil then
        showPanelName = TYPE_TO_PANEL_NAME[typeName]
    end
    local panelElement = panelItem:getChild("panel_element")
    for i = 1, panelElement:getChildrenCount() do
        local node = panelElement:getChildByIndex(i - 1)
        if showPanelName == nil then
            node.visible = false
        else
            node.visible = (node.name == showPanelName)
        end
    end
end

---_getPanelByType
---@param panelItem UINode
---@param typeName string
---@return UINode
function PropertyList:_getPanelByType(panelItem, typeName)
    local showPanelName = TYPE_TO_PANEL_NAME[typeName]
    local panelElement = panelItem:getChild("panel_element")
    return panelElement:getChild(showPanelName)
end

function PropertyList:_getTableElementCount()
    return #self._mappingList
end

---_setTableElement
---@param node UINode
---@param index number
function PropertyList:_setTableElement(node, index)
    local mapping = self._mappingList[index]
    local data, dataIndex = mapping[1], mapping[2]
    local name, configID = data[1], data[2]
    local config = self._data.Config[configID]
    local type = config.Type

    self:_resetItemVisibleState(node, type)
    local panel = self:_getPanelByType(node, type)
    local cap = UIText.cast(panel:getChild("cap"))
    cap.text = name
    local subPanel = panel:getChild("sub")
    local listeners = self._elementListeners[type]
    if listeners ~= nil then
        for nodeName, ls in pairs(listeners) do
            local tempNode = subPanel:getChild(nodeName)
            local uiTypeName = tempNode:getTypeName()
            if uiTypeName == "InputField" then
                if ls.OnBeginEditing ~= nil then
                    UIInputField.cast(tempNode):addBeginEditingListener({ ls.OnBeginEditing, self, dataIndex })
                end
                if ls.OnFinishedEditing ~= nil then
                    UIInputField.cast(tempNode):addFinishedEditingListener({ ls.OnFinishedEditing, self, dataIndex })
                end
            end
            if ls.OnTouchBegin ~= nil then
                tempNode:addTouchDownListener({ ls.OnTouchBegin, self, dataIndex })
            end
            if ls.OnTouchEnd ~= nil then
                tempNode:addTouchUpListener({ ls.OnTouchEnd, self, dataIndex })
            end
            if ls.OnCheckEvent ~= nil then
                ls.OnCheckEvent(self, tempNode, dataIndex)
            end
        end
    end
    node:applyMargin(true)
    node:addTouchDownListener({ self._onElementClicked, self })
    UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
end

---@param node UINode
---@param index number
function PropertyList:_recycleTableElement(node, index)

end

function PropertyList:_getMappingIndexByDataIndex(dataIndex)
    for i, mapping in ipairs(self._mappingList) do
        if mapping[2] == dataIndex then
            return i
        end
    end
    return 0
end

function PropertyList:_getType(dataIndex)
    local data = self._data.Children[dataIndex]
    local configID = data[2]
    local config = self._data.Config[configID]
    return config.Type
end

function PropertyList:_getItemTargetNode(dataIndex, targetName)
    local panelItem = UIUtil.getItemAtIndex(self._sv, self:_getMappingIndexByDataIndex(dataIndex))
    local type = self:_getType(dataIndex)
    local panel = self:_getPanelByType(panelItem, type)
    local subPanel = panel:getChild("sub")
    return subPanel:getChild(targetName)
end

---_ensureTargetNode
---@param node UINode
---@param dataIndex number
---@param targetName string
---@return UINode
function PropertyList:_ensureTargetNode(node, dataIndex, targetName)
    if node == nil then
        return self:_getItemTargetNode(dataIndex, targetName)
    end
    return node
end

function PropertyList:_getConfig(dataIndex)
    local data = self._data.Children[dataIndex]
    local configID = data[2]
    return self._data.Config[configID]
end

function PropertyList:_getValue(dataIndex)
    return self._data.Children[dataIndex][3]
end

function PropertyList:_setValue(dataIndex, value)
    self._data.Children[dataIndex][3] = value
end

function PropertyList:_getExParam(dataIndex)
    return self._data.Children[dataIndex][4]
end

---------------------------------------------------------------
--- 勾选框
---------------------------------------------------------------

---@param node UINode
function PropertyList:_onCheckClicked(dataIndex, node, _)
    self:_setValue(dataIndex, not self:_getValue(dataIndex))
    self:_setCheck(node, dataIndex)
end

---@param node UINode
function PropertyList:_setCheck(node, dataIndex)
    node = self:_ensureTargetNode(node, dataIndex, "check")
    local value = self:_getValue(dataIndex)
    local checkBox = UIPanel.cast(node)
    local spriteName = "check_box_false"
    if value then
        spriteName = "check_box_true"
    end
    checkBox.sprite = UISpritePool.getInstance():get(spriteName)
end

---------------------------------------------------------------
--- 下拉框
---------------------------------------------------------------

---@param node UINode
function PropertyList:_onComboClicked(dataIndex, node, _)
    if self._subPopupMenu then
        self:hidePopupMenu()
    else
        local PopupMenu = require("PopupMenu")
        local wx, wy = node.positionInCanvas.x, node.positionInCanvas.y
        self._subPopupMenu = PopupMenu.new(self:getWindow(), self:getWindow():getRoot():getChild("popup_area"),
                self:_getConfig(dataIndex).Children,
                { wx, wy + node.height, node.width }, 0, {
                    clickCallback = {
                        function(self, value)
                            self:_setValue(dataIndex, value)
                            self:_setCombo(nil, dataIndex)
                        end, self
                    }
                })

        self:_setCombo(node, dataIndex)
    end
end

---@param node UINode
function PropertyList:_setCombo(node, dataIndex)
    node = self:_ensureTargetNode(node, dataIndex, "combo")
    local value = self:_getValue(dataIndex)
    local config = self:_getConfig(dataIndex)
    local text = config.Children[value].Text
    local cap = UIText.cast(node:getChild("cap"))
    cap.text = text
end

---------------------------------------------------------------
--- 数字输入框
---------------------------------------------------------------

function PropertyList:_onEditBegin(dataIndex, node)
    --local input = UIInputField.cast(node)
    local sd = node:getParent():getChild("sd")
    sd.visible = true
end

---@param node UINode
function PropertyList:_onEditNumFinished(dataIndex, node, castInt)
    local rawText = UIInputField.cast(node).text
    local num = tonumber(rawText)
    if num == nil then
        num = 0
    else
        if castInt then
            num = math.floor(num)
        end
    end
    local ex = self:_getExParam(dataIndex)
    if ex ~= nil then
        num = math.max(ex[1], math.min(ex[2], num))
    end
    self:_setValue(dataIndex, num)
    self:_setEditNum(node, dataIndex)
end

---@param node UINode
function PropertyList:_onEditIntFinished(dataIndex, node)
    self:_onEditNumFinished(dataIndex, node, true)
end

---@param node UINode
function PropertyList:_onEditFloatFinished(dataIndex, node)
    self:_onEditNumFinished(dataIndex, node, false)
end

---_setEditNum
---@param node UINode
---@param dataIndex number
function PropertyList:_setEditNum(node, dataIndex)
    node = self:_ensureTargetNode(node, dataIndex, "panel_input.in")
    local value = self:_getValue(dataIndex)
    local input = UIInputField.cast(node)
    input.text = tostring(value)

    local sd = node:getParent():getChild("sd")
    sd.visible = false
end

function PropertyList:setSelected(index)
    if self._selectIndex == index then
        return
    end
    self._selectIndex = index
    local nodes = UIUtil.getAllValidElements(self._sv)
    for _, node in ipairs(nodes) do
        UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
    end
end

function PropertyList:_onElementClicked(node, _)
    local index = node.tag
    self:setSelected(index)
end

function PropertyList:hidePopupMenu()
    self:_destroySubPopupMenu()
end

function PropertyList:_onPopupOutsideEvent(_)
    self:hidePopupMenu()
end

function PropertyList:_initElementListener()
    self._elementListeners = {
        [PROPERTY_TYPE.Boolean] = {
            ["check"] = {
                OnTouchEnd = self._onCheckClicked,
                OnCheckEvent = self._setCheck,
            }
        },
        [PROPERTY_TYPE.ComboBox] = {
            ["combo"] = {
                OnTouchBegin = self._onComboClicked,
                OnCheckEvent = self._setCombo,
            }
        },
        [PROPERTY_TYPE.Int] = {
            ["panel_input.in"] = {
                OnFinishedEditing = self._onEditIntFinished,
                OnBeginEditing = self._onEditBegin,
                OnCheckEvent = self._setEditNum,
            }
        },
        [PROPERTY_TYPE.Float] = {
            ["panel_input.in"] = {
                OnFinishedEditing = self._onEditFloatFinished,
                OnBeginEditing = self._onEditBegin,
                OnCheckEvent = self._setEditNum,
            }
        },

    }
end

return PropertyList