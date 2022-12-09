---@class TCE.Container:TCE.BaseControl
local Container = class("MenuBar", require("BaseControl"))
local UIUtil = require("core.UIUtil")
local Constant = require("config.Constant")

function Container:__init(parent, parentRoot, data, location)
    Container.super.__init(self, parent, parentRoot, data)
    self.isContainer = true
    self:_initContent(location)
end

function Container:_initContent(location)
    local data = self._data
    local name = "container"
    local cfg = {
        bgColor = "C",
    }
    if data.IsSide then
        cfg.bgColor = "B"
    end
    if location == nil then
        cfg.layout = "FULL"
    end
    self._root = UIUtil.newPanel(self._parentRoot, name, location, cfg, true)
    self:getRoot():applyMargin(true)

    local areaTop, areaLeft = 0, 0
    if data.MenuBar then
        local menuBar = require("MenuBar").new(self, self._root,
                data.MenuBar, { 0, 0, Constant.ELEMENT_MIN_WIDTH, Constant.DEFAULT_BAR_HEIGHT })
        self:addMap("MenuBar", menuBar)
        areaTop = areaTop + menuBar:getRoot().height
    end

    if data.TreeView then
        local treeView = require("TreeView").new(self, self._root,
                data.TreeView, { 0, 0, 32, 32 }
        )
        self:addMap("TreeView", treeView)
    end

    if data.TabView then
        local tabView = require("TabView").new(self, self._root,
                data.TabView, { 0, 0, 32, 32 }
        )
        self:addMap("TabView", tabView)
    end

    local splitLeftX = 250
    local splitRightX = 250
    local splitTopY = 400

    local containers = data.Containers
    if containers then
        local function _hasPlace(_place, targetPlace)
            for _, place in ipairs(_place) do
                if place == targetPlace then
                    return true
                end
            end
            return false
        end

        for _, data in ipairs(containers) do
            local place = data.Place
            local l, r, t, b
            local w, h = 0, 0
            local key = ""
            local hasLT = _hasPlace(place, 1)
            if hasLT then
                key = key .. "1"
            end
            local hasCT = _hasPlace(place, 2)
            if hasCT then
                key = key .. "2"
            end
            local hasRT = _hasPlace(place, 3)
            if hasRT then
                key = key .. "3"
            end
            local hasLB = _hasPlace(place, 4)
            if hasLB then
                key = key .. "4"
            end
            local hasCB = _hasPlace(place, 5)
            if hasCB then
                key = key .. "5"
            end
            local hasRB = _hasPlace(place, 6)
            if hasRB then
                key = key .. "6"
            end
            if hasLT or hasLB then
                w = splitLeftX
                l = 0
                if not (hasLT and hasLB) then
                    if hasLT then
                        h = splitTopY
                    else
                        t = splitTopY
                    end
                end
            end
            if hasRT or hasRB then
                w = splitRightX
                r = 0
                if not (hasRB and hasRT) then
                    if hasRT then
                        h = splitTopY
                    else
                        t = splitTopY
                    end
                else
                    t = 0
                    b = 0
                    h = 0
                end
            end
            if hasLB and hasCB then
                l = 0
                t = splitTopY
                r = splitRightX
                b = 0
                w = 0
                h = 0
            end

            if t ~= nil then
                t = t + areaTop
            end

            local container = Container.new(self, self._root, data.Container, { 0, areaTop, 32, 32 })
            --UIUtil.setMarginsTB(container:getRoot(), areaTop, 300)
            UIUtil.setMargins(container:getRoot(), l, t, r, b, w == 0, h == 0)

            if w > 0 then
                container:getRoot().width = w
            end
            if h > 0 then
                container:getRoot().height = h
            end
            self:addMap(key, container)
        end

        --local LT = containers.LT
        --local LB = containers.LB
        --local R = containers.R
        --local CB = containers.CB
        --local CT = containers.CT
        --
        --local SIDE_WIDTH = 200
        --if LT then
        --    local container = Container.new(self, self._root, LT, { 0, areaTop, SIDE_WIDTH, 32 })
        --    UIUtil.setMarginsTB(container:getRoot(), areaTop, 300)
        --    self:addMap("LT", container)
        --end
        --if R then
        --    local container = Container.new(self, self._root, R, { 0, areaTop, SIDE_WIDTH, 32 })
        --    UIUtil.setMargins(container:getRoot(), nil, areaTop, 0, 0, false, true)
        --    self:addMap("R", container)
        --end
    end
end

return Container