---@class TCE.Listener
local Listener = class("Listener")

---@param func function
---@param params table
function Listener:__init(func, params)
    if type(func) == "function" then
        self._func = func
        self._params = params
    elseif #func > 0 then
        self._func = func[1]
        self._params = {}
        for i = 2, #func do
            table.insert(self._params, func[i])
        end
        for i = 1, #params do
            table.insert(self._params, params[i])
        end
    end
end

---@return any
function Listener:run(...)
    if self._func == nil then
        return nil
    end
    if self._params == nil or #self._params == 0 then
        return self._func(...)
    end
    local params = {}
    for _, v in ipairs(self._params) do
        table.insert(params, v)
    end
    local argList = { ... }
    for _, v in ipairs(argList) do
        table.insert(params, v)
    end
    return self._func(table.unpack(params))
end

return Listener