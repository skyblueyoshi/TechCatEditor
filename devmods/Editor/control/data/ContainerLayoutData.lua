---@class TCE.ContainerLayoutData:TCE.BaseData
local ContainerLayoutData = class("ContainerLayoutData", require("BaseData"))
local DataMembers = {
    place = { {} },
    container = { nil, "ContainerData" },
}

function ContainerLayoutData:__init(cfg)
    self:initData(DataMembers, cfg, true)
end

---@param value table
function ContainerLayoutData:setPlace(value)
    self:_set("place", value)
end

---@return table
function ContainerLayoutData:getPlace()
    return self:_get("place")
end

---@param value TCE.ContainerData
function ContainerLayoutData:setContainer(value)
    self:_set("container", value)
end

---@return TCE.ContainerData
function ContainerLayoutData:getContainer()
    return self:_get("container")
end

return ContainerLayoutData