---@class TCE.Container:TCE.BaseControl
local Container = class("MenuBar", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

local KEY_MENU_BAR = "MenuBar"
local KEY_TREE_VIEW = "TreeView"
local KEY_PROPERTY_LIST = "PropertyList"
local KEY_GRID_VIEW = "GridView"
local KEY_TAB_VIEW = "TabView"
local KEY_RENDER_TARGET_VIEW = "RenderTargetView"

local LEFT_AREA_SIZE = 250
local RIGHT_AREA_SIZE = 250
local BOTTOM_AREA_SIZE = 300

function Container:__init(name, parent, parentRoot, data, location)
    Container.super.__init(self, name, parent, parentRoot, data)
    self.isContainer = true
    self._leftAreaSize = LEFT_AREA_SIZE
    self._rightAreaSize = RIGHT_AREA_SIZE
    self._bottomAreaSize = BOTTOM_AREA_SIZE
    self._areaTop = 0

    self._leftAreaSizeDragOrigin = 0
    self._rightAreaSizeDragOrigin = 0
    self._bottomAreaSizeDragOrigin = 0

    self:_initContent(location)
end

---@return TCE.ContainerData
function Container:getData()
    return self._data
end

function Container:_initContent(location)
    self:adjustLayout(true, location)
end

function Container:adjustLayout(isInitializing, location)
    local data = self:getData()
    local cfg = {
        bgColor = "C",
    }
    if data:getIsSide() then
        cfg.bgColor = "B"
    end
    if location == nil or #location == 0 then
        cfg.layout = "FULL"
    end
    self._root = UIUtil.ensurePanel(self._parentRoot, self._name, location, cfg, true)
    self._root:applyMargin(true)

    local function ensureElement(keyName, modName, nodeName, elementData, loc, postFunc)
        if elementData ~= nil then
            ---@type TCE.MenuBar
            local ui = self:getChildFromMap(keyName)
            if ui == nil then
                ui = require(modName).new(nodeName, self, self._root, elementData, loc)
                self:addChildToMap(keyName, ui)
            else
                ui:adjustLayout(false, nil)
            end
            if postFunc ~= nil then
                postFunc()
            end
        else
            self:removeChildFromMap(keyName)
        end
    end

    ensureElement(KEY_MENU_BAR, "MenuBar", "menu_bar", data:getMenuBar(),
            { 0, 0, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT }, function()
                local ui = self:getChildFromMap("MenuBar")
                self._areaTop = self._areaTop + ui:getRoot().height
            end)

    ensureElement(KEY_TREE_VIEW, "TreeView", "tree_view", data:getTree(), { 0, 0, 32, 32 })
    ensureElement(KEY_TAB_VIEW, "TabView", "tab_view", data:getTab(), { 0, 0, 32, 32 })
    ensureElement(KEY_GRID_VIEW, "GridView", "grid", data:getGrid(), { 0, 0, 32, 32 })

    --
    --if data.PropertyList then
    --    local ui = require("PropertyList").new(self, self._root,
    --            data.PropertyList, { 0, 0, 32, 32 }
    --    )
    --    self:addChildToMap(KEY_PROPERTY_LIST, ui)
    --end
    --
    --if data.RenderTargetView then
    --    local ui = require("RenderTargetView").new(self, self._root,
    --            data.RenderTargetView, { 0, 0, 32, 32 }
    --    )
    --    self:addChildToMap(KEY_RENDER_TARGET_VIEW, ui)
    --end
    --

    local layoutEnsureKeys = {}
    for _, layoutData in ipairs(data:getLayouts()) do
        local place = layoutData:getPlace()
        local containerData = layoutData:getContainer()

        local numStr, l, t, r, b, w, h = self:_getPlaceKeyAndLayout(place)
        local key = "Container_" .. numStr
        local dragKey = "Drag_" .. numStr

        layoutEnsureKeys[key] = true
        layoutEnsureKeys[dragKey] = true

        local ui = self:getChildFromMap(key)
        if ui == nil then
            ui = Container.new(key, self, self._root, containerData, { 0, self._areaTop, 32, 32 })
            self:addChildToMap(key, ui)
        end

        local function _makeDrag(targetNumStr, isVertical, func)
            if numStr == targetNumStr then
                local drag = self:getChildFromMap(dragKey)
                if drag == nil then
                    drag = require("DraggableArea").new(dragKey, self, self._root, isVertical, { func, self })
                    self:addChildToMap(dragKey, drag)
                end
            end
        end

        _makeDrag("36", false, self._onDragRightArea)
        _makeDrag("1", false, self._onDragLeftArea)
        _makeDrag("45", true, self._onDragBottomArea)
    end

    local function strStarts(String, Start)
        return string.sub(String, 1, string.len(Start)) == Start
    end

    local keysRemoved = {}
    for keyName, _ in pairs(self:getChildrenMap()) do
        if layoutEnsureKeys[keyName] == nil then
            if strStarts(keyName, "Container_") or strStarts(keyName, "Drag_") then
                table.insert(keysRemoved, keyName)
            end
        end
    end
    for _, keyName in ipairs(keysRemoved) do
        self:removeChildFromMap(keyName)
    end

    self:_updateLayout()
end

function Container:_getPlaceKeyAndLayout(place)
    local function _hasPlace(_place, targetPlace)
        for _, placeElement in ipairs(_place) do
            if placeElement == targetPlace then
                return true
            end
        end
        return false
    end
    local l, r, t, b
    local w, h = 0, 0
    local numStr = ""
    local hasLT = _hasPlace(place, 1)
    if hasLT then
        numStr = numStr .. "1"
    end
    local hasCT = _hasPlace(place, 2)
    if hasCT then
        numStr = numStr .. "2"
    end
    local hasRT = _hasPlace(place, 3)
    if hasRT then
        numStr = numStr .. "3"
    end
    local hasLB = _hasPlace(place, 4)
    if hasLB then
        numStr = numStr .. "4"
    end
    local hasCB = _hasPlace(place, 5)
    if hasCB then
        numStr = numStr .. "5"
    end
    local hasRB = _hasPlace(place, 6)
    if hasRB then
        numStr = numStr .. "6"
    end
    if hasLT or hasLB then
        w = self._leftAreaSize
        l = 0
        if not (hasLT and hasLB) then
            if hasLT then
                t = 0
                b = self._bottomAreaSize + Constant.DRAG_AREA_SIZE
                h = 0
            else
                b = 0
                h = self._bottomAreaSize
            end
        end
    end
    if hasRT or hasRB then
        w = self._rightAreaSize
        r = 0
        if not (hasRB and hasRT) then
            if hasLT then
                b = self._bottomAreaSize + Constant.DRAG_AREA_SIZE
                h = 0
            else
                b = 0
                h = self._bottomAreaSize
            end
        else
            t, b = 0, 0
            h = 0
        end
    end

    -- 底部资源栏
    if hasLB and hasCB then
        l, t, r, b = 0, nil, self._rightAreaSize + Constant.DRAG_AREA_SIZE, 0
        w, h = 0, self._bottomAreaSize
    end

    -- 左侧层级栏
    if hasLT and hasLB and not hasCT then
        l, t, r, b = 0, 0, nil, 0
        w, h = self._leftAreaSize, 0
    end

    -- 通用右侧
    if hasCB and hasCT and hasRB and not hasLT then
        l, t, r, b = self._leftAreaSize, 0, 0, 0
        w, h = 0, 0
    end

    -- 主窗口
    if hasCT and not hasLT and not hasRT and not hasCB then
        l, t, r, b = self._leftAreaSize + Constant.DRAG_AREA_SIZE, 0, self._rightAreaSize + Constant.DRAG_AREA_SIZE, self._bottomAreaSize + Constant.DRAG_AREA_SIZE
        w, h = 0, 0
    end

    if t ~= nil then
        t = t + self._areaTop
    end

    return numStr, l, t, r, b, w, h
end

function Container:_onDragRightArea(move, isBegin)
    if isBegin then
        self._rightAreaSizeDragOrigin = self._rightAreaSize
    end
    self._rightAreaSize = self._rightAreaSizeDragOrigin - move
    self:_updateLayout()
end

function Container:_onDragLeftArea(move, isBegin)
    if isBegin then
        self._leftAreaSizeDragOrigin = self._leftAreaSize
    end
    self._leftAreaSize = self._leftAreaSizeDragOrigin + move
    self:_updateLayout()
end

function Container:_onDragBottomArea(move, isBegin)
    if isBegin then
        self._bottomAreaSizeDragOrigin = self._bottomAreaSize
    end
    self._bottomAreaSize = self._bottomAreaSizeDragOrigin - move
    self:_updateLayout()
end

function Container:_updateLayout()
    local data = self:getData()
    for _, layoutData in ipairs(data:getLayouts()) do
        local place = layoutData:getPlace()

        local numStr, l, t, r, b, w, h = self:_getPlaceKeyAndLayout(place)
        local key = "Container_" .. numStr
        local dragKey = "Drag_" .. numStr

        local container = self:getChildFromMap(key)
        UIUtil.setMargins(container:getRoot(), l, t, r, b, w == 0, h == 0)

        if w > 0 then
            container:getRoot().width = w
        end
        if h > 0 then
            container:getRoot().height = h
        end

        if self:getChildFromMap(dragKey) ~= nil then
            local drag = self:getChildFromMap(dragKey)

            if numStr == "36" then
                UIUtil.setMargins(drag:getRoot(), nil, 0, self._rightAreaSize, 0,
                        false, true)
            elseif numStr == "1" then
                UIUtil.setMargins(drag:getRoot(), self._leftAreaSize, 0, nil, self._bottomAreaSize + Constant.DRAG_AREA_SIZE,
                        false, true)
            elseif numStr == "45" then
                UIUtil.setMargins(drag:getRoot(), 0, nil, self._rightAreaSize + Constant.DRAG_AREA_SIZE, self._bottomAreaSize,
                        true, false)
            end
        end
    end
    self._root:applyMargin(true)
end

return Container