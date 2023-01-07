---@class TCE.GridElementData:TCE.BaseData
local GridElementData = class("GridElementData", require("BaseData"))
local DataMembers = {
    text = { "" },
}

function GridElementData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value string
function GridElementData:setText(value)
    self:_set("text", value)
end

---@return string
function GridElementData:getText()
    return self:_get("text")
end

return GridElementData