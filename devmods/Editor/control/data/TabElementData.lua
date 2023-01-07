---@class TCE.TabElementData:TCE.BaseData
local TabElementData = class("TabElementData", require("BaseData"))
local DataMembers = {
    tabButton = { nil, "ButtonData" },
    container = { nil, "ContainerData" },
}

function TabElementData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value TCE.ButtonData
function TabElementData:setTabButton(value)
    self:_set("tabButton", value)
end

---@return TCE.ButtonData
function TabElementData:getTabButton()
    return self:_get("tabButton")
end

---@param value TCE.ContainerData
function TabElementData:setContainer(value)
    self:_set("container", value)
end

---@return TCE.ContainerData
function TabElementData:getContainer()
    return self:_get("container")
end

return TabElementData