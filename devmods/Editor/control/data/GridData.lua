---@class TCE.GridData:TCE.BaseData
local GridData = class("GridData", require("BaseData"))
local DataMembers = {
    elements = { {}, "GridElementData", "list" },
}

function GridData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value table
function GridData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.GridElementData[]
function GridData:getElements()
    return self:_get("elements")
end

---@param element TCE.GridElementData
function GridData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function GridData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

---@param values table
function GridData:addCfgsToElements(values)
    self:_listAppendCfgs("elements", values)
end

function GridData:clearElements()
    self:_listClear("elements")
end

return GridData