function __dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. __dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

---each
---@return number, any
function each(array)
    local index = 0
    local count = array.count
    return function()
        index = index + 1
        if index <= count then
            return index, array[index]
        end
    end
end