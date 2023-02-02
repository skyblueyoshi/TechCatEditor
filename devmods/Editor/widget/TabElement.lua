local BaseWidget = require("BaseWidget")
---@class TCE.TabElement:TCE.BaseWidget
local TabElement = class("TabElement", BaseWidget)
local DataDefine = { notifyParent = false, }
local PropertyDefines = {
    tabButton = BaseWidget.newPropDef({ nil, "Button" }),
    container = BaseWidget.newPropDef({ nil, "Container" }),
}

function TabElement:__init()
    TabElement.super.__init(self, DataDefine, PropertyDefines)
end

---@param tabButton TCE.Button
function TabElement:setTabButton(tabButton)
    self:_set("tabButton", tabButton)
end

---@return TCE.Button
function TabElement:getTabButton()
    return self["tabButton"]
end

---@param container TCE.Container
function TabElement:setContainer(container)
    self:_set("container", container)
end

---@return TCE.Container
function TabElement:getContainer()
    return self["container"]
end

return TabElement