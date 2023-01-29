---@class TCE.ContainerData:TCE.BaseData
local ContainerData = class("ContainerData", require("BaseData"))
local DataMembers = {
    isSide = { false },
    menuBar = { nil, "MenuBarData" },
    tree = { nil, "TreeData" },
    tab = { nil, "TabData" },
    grid = { nil, "GridData" },
    propertyList = { nil, "PropertyListData" },
    renderTarget = { nil, "RenderTargetData" },
    layouts = { {}, "ContainerLayoutData", "list" },
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

---@param value TCE.TabData
function ContainerData:setTab(value)
    self:_set("tab", value)
end

---@return TCE.TabData
function ContainerData:getTab()
    return self:_get("tab")
end

---@param value TCE.GridData
function ContainerData:setGrid(value)
    self:_set("grid", value)
end

---@return TCE.GridData
function ContainerData:getGrid()
    return self:_get("grid")
end

---@param value TCE.PropertyListData
function ContainerData:setPropertyList(value)
    self:_set("propertyList", value)
end

---@return TCE.PropertyListData
function ContainerData:getPropertyList()
    return self:_get("propertyList")
end

---@param value TCE.RenderTargetData
function ContainerData:setRenderTarget(value)
    self:_set("renderTarget", value)
end

---@return TCE.RenderTargetData
function ContainerData:getRenderTarget()
    return self:_get("renderTarget")
end

---@param value table
function ContainerData:setLayouts(value)
    self:_set("layouts", value)
end

---@return TCE.ContainerLayoutData[]
function ContainerData:getLayouts()
    return self:_get("layouts")
end

---@param element TCE.ContainerLayoutData
function ContainerData:addToLayouts(element)
    self:_listAppend("layouts", element)
end

---@param value table
function ContainerData:addCfgToLayouts(value)
    self:_listAppendCfg("layouts", value)
end

---@param values table
function ContainerData:addCfgsToLayouts(values)
    self:_listAppendCfgs("layouts", values)
end

function ContainerData:clearLayouts()
    self:_listClear("layouts")
end

return ContainerData