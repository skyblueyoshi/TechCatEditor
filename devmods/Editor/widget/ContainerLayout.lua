local BaseWidget = require("BaseWidget")
---@class TCE.ContainerLayout:TCE.BaseWidget
local ContainerLayout = class("ContainerLayout", BaseWidget)
local DataDefine = { notifyParent = true, }
local PropertyDefines = {
    place = BaseWidget.newPropDef({ {} }),
    container = BaseWidget.newPropDef({ nil, "Container" }),
}

function ContainerLayout:__init()
    ContainerLayout.super.__init(self, DataDefine, PropertyDefines)
end

---@param place table
function ContainerLayout:setPlace(place)
    self:_set("place", place)
end

---@return table
function ContainerLayout:getPlace()
    return self["place"]
end

---@param container TCE.Container
function ContainerLayout:setContainer(container)
    self:_set("container", container)
end

---@return TCE.Container
function ContainerLayout:getContainer()
    return self["container"]
end

return ContainerLayout