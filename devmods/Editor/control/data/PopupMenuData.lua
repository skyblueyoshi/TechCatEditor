---@class TCE.PopupMenuData:TCE.BaseData
local PopupMenuData = class("PopupMenuData", require("BaseData"))
local DataMembers = {
    elements = { {}, "PopupMenuElementData", "list" },
}

function PopupMenuData:__init(cfg)
    self:initData(DataMembers, cfg, false)
end

---@param value table
function PopupMenuData:setElements(value)
    self:_set("elements", value)
end

---@return TCE.PopupMenuElementData[]
function PopupMenuData:getElements()
    return self:_get("elements")
end

---@param element TCE.PopupMenuElementData
function PopupMenuData:addToElements(element)
    self:_listAppend("elements", element)
end

---@param value table
function PopupMenuData:addCfgToElements(value)
    self:_listAppendCfg("elements", value)
end

---@param values table
function PopupMenuData:addCfgsToElements(values)
    self:_listAppendCfgs("elements", values)
end

function PopupMenuData:clearElements()
    self:_listClear("elements")
end

return PopupMenuData