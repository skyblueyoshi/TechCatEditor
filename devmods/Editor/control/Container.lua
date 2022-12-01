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
                data.TreeView, { 0, 0, 200, 200 }
        )
        self:addMap("TreeView", treeView)
    end

    local containers = data.Containers
    if containers then
        local LT = containers.LT
        local LB = containers.LB
        local R = containers.R
        local CB = containers.CB
        local CT = containers.CT

        local SIDE_WIDTH = 200
        if LT then
            local container = Container.new(self, self._root, LT, { 0, areaTop, SIDE_WIDTH, 32 })
            UIUtil.setMarginsTB(container:getRoot(), areaTop, 300)
            self:addMap("LT", container)
        end
        if R then
            local container = Container.new(self, self._root,R, { 0, areaTop, SIDE_WIDTH, 32 })
            UIUtil.setMargins(container:getRoot(), nil, areaTop, 0, 0, false, true)
            self:addMap("R", container)
        end
    end
end

return Container