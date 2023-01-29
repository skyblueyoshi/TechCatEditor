---@class TCE.RenderTargetData:TCE.BaseData
local RenderTargetData = class("RenderTargetData", require("BaseData"))
local DataMembers = {
    text = { "" },
}

function RenderTargetData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value string
function RenderTargetData:setText(value)
    self:_set("text", value)
end

---@return string
function RenderTargetData:getText()
    return self:_get("text")
end

return RenderTargetData