local BaseWidget = require("BaseWidget")
---@class TCE.Container:TCE.BaseWidget
local Container = class("Container", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    isSide = BaseWidget.newPropDef({ false }),
    menuBar = BaseWidget.newPropDef({ nil, "MenuBar" }),
    tree = BaseWidget.newPropDef({ nil, "Tree" }),
    tab = BaseWidget.newPropDef({ nil, "Tab" }),
    grid = BaseWidget.newPropDef({ nil, "Grid" }),
    propertyList = BaseWidget.newPropDef({ nil, "PropertyList" }),
    renderTarget = BaseWidget.newPropDef({ nil, "RenderTarget" }),
    layouts = BaseWidget.newPropDef({ {}, "ContainerLayout", "list" }),
}

function Container:__init()
    Container.super.__init(self, DataDefine, PropertyDefines)
end

---@param isSide boolean
function Container:setIsSide(isSide)
    self:_set("isSide", isSide)
end

---@return boolean
function Container:getIsSide()
    return self["isSide"]
end

---@param menuBar TCE.MenuBar
function Container:setMenuBar(menuBar)
    self:_set("menuBar", menuBar)
end

---@return TCE.MenuBar
function Container:getMenuBar()
    return self["menuBar"]
end

---@param tree TCE.Tree
function Container:setTree(tree)
    self:_set("tree", tree)
end

---@return TCE.Tree
function Container:getTree()
    return self["tree"]
end

---@param tab TCE.Tab
function Container:setTab(tab)
    self:_set("tab", tab)
end

---@return TCE.Tab
function Container:getTab()
    return self["tab"]
end

---@param grid TCE.Grid
function Container:setGrid(grid)
    self:_set("grid", grid)
end

---@return TCE.Grid
function Container:getGrid()
    return self["grid"]
end

---@param propertyList TCE.PropertyList
function Container:setPropertyList(propertyList)
    self:_set("propertyList", propertyList)
end

---@return TCE.PropertyList
function Container:getPropertyList()
    return self["propertyList"]
end

---@param renderTarget TCE.RenderTarget
function Container:setRenderTarget(renderTarget)
    self:_set("renderTarget", renderTarget)
end

---@return TCE.RenderTarget
function Container:getRenderTarget()
    return self["renderTarget"]
end

---@return TCE.ContainerLayout[]
function Container:getLayouts()
    return self["layouts"]
end

---@param widget TCE.ContainerLayout
function Container:layoutsAdd(widget)
    self:_propertyListAdd("layouts", widget)
end

---@param index number
---@param widget TCE.ContainerLayout
function Container:layoutsInsert(index, widget)
    self:_propertyListInsert("layouts", index, widget)
end

---@param widget TCE.ContainerLayout
function Container:layoutsRemove(widget)
    self:_propertyListRemove("layouts", widget)
end

---@param index number
function Container:layoutsRemoveAt(index)
    self:_propertyListRemoveAt("layouts", index)
end

function Container:layoutsClear()
    self:_propertyListClear("layouts")
end

return Container