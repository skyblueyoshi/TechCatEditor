local Locale = {}

function Locale.reload()
    Locale = require("Chinese")
end

function Locale.get(s)
    if #s <= 1 then
        return s
    end
    if s:sub(1, 1) == "@" then
        local text = string.sub(s, 2)
        local res = Locale[text]
        if res ~= nil then
            return res
        else
            return text
        end
    end
    return s
end

return Locale