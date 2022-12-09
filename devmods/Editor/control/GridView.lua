---@class TCE.GridView:TCE.ScrollContainer
local GridView = class("GridView", require("ScrollContainer"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")
local UISpritePool = require("core.UISpritePool")

--[[
GridNode：{
    str Text  描述文字
}
--]]

function GridView:__init(parent, parentRoot, data, location)
    GridView.super.__init(self, parent, parentRoot, data, {
        isItemFillWidth = false,
        isGrid = true,
    })
    self._mappingList = {}
    self._selectIndex = 0
    self:_initContent(location)
end

function GridView:onDestroy()
    self._mappingList = {}
    GridView.super.onDestroy(self)
end

function GridView:_reloadMappingList()
    self._mappingList = {}
    if #self._data.Children > 0 then
        for _, subData in ipairs(self._data.Children) do
            table.insert(self._mappingList, subData)
        end
    end
end

function GridView:_initContent(location)
    self:_preInitScrollContainer(location)

    self:_reloadMappingList()
    self:_postInitScrollContainer()
end

function GridView:_onCreatePanelItem()
    local panelItem = self:_makeDefaultPanelItem(96, 120)
    UIUtil.newPanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    local img = UIUtil.newPanel(panelItem, "img", { 0, 8, 64, 64 }, {
        layout = "CENTER_W",
    }, false, false)
    img.sprite = UISpritePool.getInstance():get("icon_folder")
    img.sprite.color = Color.new(130, 160, 210)

    local text = UIUtil.newText(panelItem, "cap", { 0, 80, 32, 32 }, "1", {
        layout = "CENTER_W",
    })

    return panelItem
end

function GridView:_getTableElementCount()
    return #self._mappingList
end

---_setTableElement
---@param node UINode
---@param index number
function GridView:_setTableElement(node, index)
    --print("GridView:_setTableElement", index, node.position, node.size)
    local data = self._mappingList[index]
    local cap = UIText.cast(node:getChild("cap"))
    cap.text = data.Text

    node:getChild("sd").visible = false

    node:applyMargin(true)
    node:addMousePointedEnterListener({ self._onElementMouseEnter, self })
    node:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
    node:addTouchDownListener({ self._onElementClicked, self })

    --local treeNode = TreeNode.new(self, node, {}, {0,0})
    UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
end

function GridView:setSelected(index)
    if self._selectIndex == index then
        return
    end
    self._selectIndex = index
    local nodes = UIUtil.getAllValidElements(self._sv)
    for _, node in ipairs(nodes) do
        UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
    end
end

function GridView:_onElementMouseEnter(node, _)
    local index = node.tag
    UIUtil.setPanelDisplay(node, index == self._selectIndex, true, nil, "A")
end

function GridView:_onElementMouseLeave(node, _)
    local index = node.tag
    UIUtil.setPanelDisplay(node, index == self._selectIndex, false, nil, "A")
end

function GridView:_onElementClicked(node, _)
    local index = node.tag
    self:setSelected(index)
end

return GridView