---@class TCE.TreeElementData:TCE.BaseData
local TreeElementData = class("TreeElementData", require("BaseData"))
local DataMembers = {
    text = { "" },
    canExpand = { false },
    elements = { {}, "TreeElementData", "list" },
}

function TreeElementData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value string
function TreeElementData:setText(value)
    self:_set("text", value)
end

---@return string
function TreeElementData:getText()
    return self:_get("text")
end

---@param value boolean
function TreeElementData:setCanExpand(value)
    self:_set("canExpand", value)
end

---@return boolean
function TreeElementData:getCanExpand()
    return self:_get("canExpand")
end

---@param value table
function TreeElementData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.TreeElementData[]
function TreeElementData:getElements()
    return self:_get("elements")
end

---@param element TCE.TreeElementData
function TreeElementData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function TreeElementData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

function TreeElementData:clearElements()
    self:_listClear("elements")
end

return TreeElementData