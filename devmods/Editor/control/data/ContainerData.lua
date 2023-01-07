---@class TCE.ContainerData:TCE.BaseData
local ContainerData = class("ContainerData", require("BaseData"))
local DataMembers = {
    isSide = { false },
    menuBar = { nil, "MenuBarData" },
    tree = { nil, "TreeData" },
}

function ContainerData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value boolean
function ContainerData:setIsSide(value)
    self:_set("isSide", value)
end

---@return boolean
function ContainerData:getIsSide()
    return self:_get("isSide")
end

---@param value TCE.MenuBarData
function ContainerData:setMenuBar(value)
    self:_set("menuBar", value)
end

---@return TCE.MenuBarData
function ContainerData:getMenuBar()
    return self:_get("menuBar")
end

---@param value TCE.TreeData
function ContainerData:setTree(value)
    self:_set("tree", value)
end

---@return TCE.TreeData
function ContainerData:getTree()
    return self:_get("tree")
end

return ContainerData