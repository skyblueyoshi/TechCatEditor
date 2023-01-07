---@class TCE.GridView:TCE.ScrollContainer
local GridView = class("GridView", require("ScrollContainer"))
---@class TCE.GridViewElement:TCE.ScrollContainer
local GridViewElement = class("GridViewElement", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local UISpritePool = require("core.UISpritePool")
local ThemeUtil = require("core.ThemeUtil")

function GridViewElement:__init(root, parent, data, index)
    GridViewElement.super.__init(self, "", parent, nil, data)
    self._root = root
    self._index = index
    self:_initContent()
end

---@return TCE.GridElementData
function GridViewElement:getData()
    return self._data
end

function GridViewElement:_initContent()
    self:adjustLayout(true)
    self._root:addMousePointedEnterListener({ self._onElementMouseEnter, self })
    self._root:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
    self._root:addTouchDownListener({ self._onElementClicked, self })

    --if self._index == 1 then
    --    UIRenderTargetNode.cast(self._root:getChild("rt")):addRenderTargetListener({ self._testRT, self })
    --end
end

function GridViewElement:adjustLayout(isInitializing, _)
    local data = self:getData()
    local cap = UIText.cast(self._root:getChild("cap"))
    cap.text = data:getText()

    if isInitializing then
        self._root:getChild("sd").visible = false
    end

    self._root:applyMargin(true)

    UIUtil.setPanelDisplay(self._root, self._index == self._parent:getSelectedIndex(), false)

    self._root:getChild("img"):getPostDrawLayer(0):removeSpriteAnimation()
    --if data.OnCreated ~= nil then
    --    data.OnCreated[1](node, index, table.unpack(data.OnCreated[2]))
    --end
end

function GridViewElement:_onElementMouseEnter(_, _)
    self:_updateSelectedState(true)
end

function GridViewElement:_onElementMouseLeave(_, _)
    self:_updateSelectedState(false)
end

function GridViewElement:_updateSelectedState(pointed)
    UIUtil.setPanelDisplay(self._root, self._index == self._parent:getSelectedIndex(),
            pointed, nil, "A")
end

function GridViewElement:_onElementClicked(_, _)
    self._parent:setSelected(self._index)
end

function GridView:__init(name, parent, parentRoot, data, location)
    GridView.super.__init(self, name, parent, parentRoot, data, {
        isItemFillWidth = false,
        isGrid = true,
    })
    self:_initContent(location)
end

function GridView:onDestroy()
    GridView.super.onDestroy(self)
end

---@return TCE.GridData
function GridView:getData()
    return self._data
end

function GridView:_initContent(location)
    self:adjustLayout(true, location)
end

function GridView:adjustLayout(isInitializing, location)
    self:_adjustLayoutBegin(isInitializing, location)
    self:_adjustLayoutEnd(isInitializing)
end

function GridView:_onEnsurePanelItem()
    local panelItem = self:_ensureDefaultPanelItem(96, 120)
    UIUtil.ensurePanel(panelItem, "sd", nil, {
        layout = "FULL",
        bgColor = "BD",
    }, false, false)
    panelItem:getChild("sd").visible = false

    local img = UIUtil.ensurePanel(panelItem, "img", { 0, 8, 64, 64 }, {
        layout = "CENTER_W",
    }, false, false)
    img.sprite = UISpritePool.getInstance():get("icon_folder")
    img.sprite.color = ThemeUtil.getColor("ICON_COLOR")

    UIUtil.ensureText(panelItem, "cap", { 0, 80, 32, 32 }, "1", {
        layout = "CENTER_W",
    })

    --local rt = UIRenderTargetNode.new("rt", 0, 0, 32, 32)
    --rt.visible = true
    --panelItem:addChild(rt)

    return panelItem
end

function GridView:_testRT(n, w, h)
    --GraphicsDevice.drawRect2D(RectFloat.new(0, 0, w, h), Color.Blue)
    Sprite.beginBatch()
    Sprite.draw(UISpritePool.getInstance():get("check_box_true").textureLocation, Vector2.new(8, 8), Rect.new(0, 0, 16, 16), Color.White, 0)
    Sprite.endBatch()
end

function GridView:_getTableElementCount()
    return #self:getData():getElements()
end

function GridView:_onCreateElement(node, index)
    local data = self:getData():getElements()[index]
    return GridViewElement.new(node, self, data, index)
end

---_setTableElement
---@param node UINode
---@param index number
--function GridView:_setTableElement(node, index)
--    --print("GridView:_setTableElement", index, node.position, node.size)
--    local data = self._mappingList[index]
--    local cap = UIText.cast(node:getChild("cap"))
--    cap.text = data.Text
--
--    node:getChild("sd").visible = false
--
--    node:applyMargin(true)
--    node:addMousePointedEnterListener({ self._onElementMouseEnter, self })
--    node:addMousePointedLeaveListener({ self._onElementMouseLeave, self })
--    node:addTouchDownListener({ self._onElementClicked, self })
--
--    if index == 1 then
--        UIRenderTargetNode.cast(node:getChild("rt")):addRenderTargetListener({ self._testRT, self })
--    end
--
--    --local treeNode = TreeNode.new(self, node, {}, {0,0})
--    UIUtil.setPanelDisplay(node, node.tag == self._selectIndex, false)
--
--    node:getChild("img"):getPostDrawLayer(0):removeSpriteAnimation()
--    if data.OnCreated ~= nil then
--        data.OnCreated[1](node, index, table.unpack(data.OnCreated[2]))
--    end
--end

return GridView