local UIData = class("UIData")

local DataDict = {
    ButtonData = require("ButtonData"),
    PopupMenuElementData = require("PopupMenuElementData"),
    PopupMenuData = require("PopupMenuData"),
    MenuBarData = require("MenuBarData"),
    TreeElementData = require("TreeElementData"),
    TreeData = require("TreeData"),
    ContainerData = require("ContainerData"),
}

function UIData.create(uiName, cfg)
    return DataDict[uiName].new(cfg)
end

return UIData