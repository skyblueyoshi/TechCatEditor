---@class TCE.TreeData:TCE.BaseData
local TreeData = class("TreeData", require("BaseData"))
local DataMembers = {
    iconList = { {} },
    elements = { {}, "TreeElementData", "list" },
}

function TreeData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value table
function TreeData:setIconList(value)
    self:_set("iconList", value)
end

---@return table
function TreeData:getIconList()
    return self:_get("iconList")
end

---@param value table
function TreeData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.TreeElementData[]
function TreeData:getElements()
    return self:_get("elements")
end

---@param element TCE.TreeElementData
function TreeData:addToElements(element)
    self:_listAppend("elements", element)
end

function TreeData:clearElements()
    self:_listClear("elements")
end

return TreeData