local UIData = class("UIData")

local DataDict = {
    ButtonData = require("ButtonData"),
    PopupMenuElementData = require("PopupMenuElementData"),
    PopupMenuData = require("PopupMenuData"),
    MenuBarData = require("MenuBarData"),
    TreeElementData = require("TreeElementData"),
    TreeData = require("TreeData"),
    ContainerData = require("ContainerData"),
    ContainerLayoutData = require("ContainerLayoutData"),
    TabElementData = require("TabElementData"),
    TabData = require("TabData"),
    GridElementData = require("GridElementData"),
    GridData = require("GridData"),
    PropertyListElementData = require("PropertyListElementData"),
    PropertyListData = require("PropertyListData"),
    PropertyListConfigElementData = require("PropertyListConfigElementData"),
    PropertyListConfigData = require("PropertyListConfigData"),
    RenderTargetData = require("RenderTargetData"),
}

function UIData.create(uiName, cfg)
    if DataDict[uiName] == nil then
        assert(false, "missing data type: " .. uiName)
    end
    return DataDict[uiName].new(cfg)
end

return UIData