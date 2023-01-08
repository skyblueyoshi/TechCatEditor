---@class TCE.Deque
local Deque = class("List")

function Deque:__init()
    self.first = 0
    self.last = -1
end

local function _iterFunc(self, k)
    return k <= self.last - self.first and k + 1 or nil, self[self.first + k]
end

function Deque:__pairs()
    return _iterFunc, self, 0
end

function Deque:pushFirst(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end

function Deque:pushLast(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function Deque:popFirst()
    local first = self.first
    if first > self.last then
        error("list is empty")
    end
    local value = self[first]
    self[first] = nil        -- to allow garbage collection
    if first == self.last then
        self.first = 0
        self.last = -1
    else
        self.first = first + 1
    end
    return value
end

function Deque:popLast()
    local last = self.last
    if self.first > last then
        error("list is empty")
    end
    local value = self[last]
    self[last] = nil         -- to allow garbage collection
    if last == self.first then
        self.first = 0
        self.last = -1
    else
        self.last = last - 1
    end
    return value
end

function Deque:empty()
    return (self.first > self.last)
end

function Deque:length()
    return (self.first > self.last) and 0 or (self.last - self.first + 1)
end

-- should not change the self in func
-- func return break or not
function Deque:foreach(func, right_first)
    if right_first then
        for i = self.last, self.first, -1 do
            if func(self[i]) then
                break
            end
        end
    else
        for i = self.first, self.last do
            if func(self[i]) then
                break
            end
        end
    end
end

function Deque:clear()
    if not self:empty() then
        for i = self.first, self.last do
            self[i] = nil
        end
    end
    self.first = 0
    self.last = -1
end

function Deque:left()
    local first = self.first
    if first > self.last then
        error("list is empty")
    end
    return self[first]
end

function Deque:right()
    local last = self.last
    if self.first > last then
        error("list is empty")
    end
    return self[last]
end

function Deque:to_table()
    local res = {}
    for i = self.first, self.last do
        table.insert(res, self[i])
    end
    return res
end

Deque.__ipairs = Deque.__pairs
Deque.len = Deque.length
Deque.size = Deque.length
Deque.push = Deque.pushLast
Deque.pop = Deque.popFirst

return Deque