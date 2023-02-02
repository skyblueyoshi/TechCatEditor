---@class TCE.WidgetPool
local WidgetPool = class("WidgetPool")
local WidgetPoolImpl = require("WidgetPoolImpl")

---@return TCE.Button
function WidgetPool.loadButton(data)
    return WidgetPoolImpl.load("Button", data)
end

---@return TCE.MenuBar
function WidgetPool.loadMenuBar(data)
    return WidgetPoolImpl.load("MenuBar", data)
end

---@return TCE.PopupMenuElement
function WidgetPool.loadPopupMenuElement(data)
    return WidgetPoolImpl.load("PopupMenuElement", data)
end

---@return TCE.PopupMenu
function WidgetPool.loadPopupMenu(data)
    return WidgetPoolImpl.load("PopupMenu", data)
end

---@return TCE.TreeElement
function WidgetPool.loadTreeElement(data)
    return WidgetPoolImpl.load("TreeElement", data)
end

---@return TCE.Tree
function WidgetPool.loadTree(data)
    return WidgetPoolImpl.load("Tree", data)
end

---@return TCE.ContainerLayout
function WidgetPool.loadContainerLayout(data)
    return WidgetPoolImpl.load("ContainerLayout", data)
end

---@return TCE.Container
function WidgetPool.loadContainer(data)
    return WidgetPoolImpl.load("Container", data)
end

---@return TCE.TabElement
function WidgetPool.loadTabElement(data)
    return WidgetPoolImpl.load("TabElement", data)
end

---@return TCE.Tab
function WidgetPool.loadTab(data)
    return WidgetPoolImpl.load("Tab", data)
end

---@return TCE.GridElement
function WidgetPool.loadGridElement(data)
    return WidgetPoolImpl.load("GridElement", data)
end

---@return TCE.Grid
function WidgetPool.loadGrid(data)
    return WidgetPoolImpl.load("Grid", data)
end

---@return TCE.PropertyListConfigElement
function WidgetPool.loadPropertyListConfigElement(data)
    return WidgetPoolImpl.load("PropertyListConfigElement", data)
end

---@return TCE.PropertyListConfig
function WidgetPool.loadPropertyListConfig(data)
    return WidgetPoolImpl.load("PropertyListConfig", data)
end

---@return TCE.PropertyListElement
function WidgetPool.loadPropertyListElement(data)
    return WidgetPoolImpl.load("PropertyListElement", data)
end

---@return TCE.PropertyList
function WidgetPool.loadPropertyList(data)
    return WidgetPoolImpl.load("PropertyList", data)
end

---@return TCE.RenderTarget
function WidgetPool.loadRenderTarget(data)
    return WidgetPoolImpl.load("RenderTarget", data)
end

return WidgetPool