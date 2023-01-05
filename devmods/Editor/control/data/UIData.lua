local UIData = class("UIData")

local DataDict = {
    Button = require("ButtonData"),
    PopupMenuElement = require("PopupMenuElementData"),
    PopupMenu = require("PopupMenuData"),
    MenuBar = require("MenuBarData"),
}

function UIData.create(uiName, cfg)
    return DataDict[uiName].new(cfg)
end

return UIData