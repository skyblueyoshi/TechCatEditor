---@class TCE.BaseView
local BaseView = class("BaseView")
local EventManager = require("core.EventManager")

local SHOW_DEBUG = false

function BaseView:__init(key, widget, parent, parentRoot)
    self._name = ""
    self._key = key
    self._widget = widget  ---@type TCE.BaseWidget
    self._parent = parent  ---@type TCE.BaseView
    self._parentRoot = parentRoot  ---@type UINode
    self._root = nil  ---@type UINode
    self._children = {}  ---@type TCE.BaseView[]

    self._eventListeners = {}
    self._destroying = false
    self._destroyed = false

    self.isWindow = self._parent == nil

    self:_initParams()
end

function BaseView:destroy()
    if self._destroying then
        return
    end
    self._destroying = true
    if SHOW_DEBUG then
        print("destroy:", self:getFullName())
    end
    self:_onDestroy()
end

function BaseView:_onDestroy()
    self:_removeAllEventListeners()
    self:removeAllChildren()
    if self._widget ~= nil then
        self._widget:removeView(self)
    end
    if self._parentRoot ~= nil then
        self._parentRoot:removeChild(self._root)
        self._parentRoot = nil
    end
    if self._parent ~= nil then
        self._parent:removeChild(self._key)
        self._parent = nil
    end
    self._widget = nil
    self._root = nil
    assert(not self._destroyed)
    self._destroyed = true
    self._destroying = false
end

function BaseView:_initParams()
    -- 名称
    if type(self._key) == "number" then
        self._name = "v_" .. tostring(self._key)
    else
        self._name = self._key
    end
    -- 父节点
    local autoAdaptParentRoot = false
    if self._parentRoot == "None" then
        self._parentRoot = nil
        autoAdaptParentRoot = true
    end
    if self._parent ~= nil then
        assert(self._parent ~= self)
        if self._parentRoot == nil and not autoAdaptParentRoot then
            self._parentRoot = self._parent:getRoot()
        end
        -- 加入到父节点
        self._parent:_addChild(self._key, self)
    end
    -- 当前视图添加监听到控件
    if self._widget ~= nil then
        self._widget:addView(self)
    end

    if SHOW_DEBUG then
        print("new:" .. (autoAdaptParentRoot and "(auto)" or ""), self:getFullName())
    end
end

---添加一个事件监听。
function BaseView:addEventListener(eventID, callback)
    local listener = EventManager.getInstance():addListener(eventID, callback)
    table.insert(self._eventListeners, listener)
end

---触发事件。
function BaseView:triggerEvent(eventID, args)
    EventManager.getInstance():triggerEvent(eventID, args)
end

---移除所有事件监听。
function BaseView:_removeAllEventListeners()
    local eventManager = EventManager.getInstance()
    for _, id in ipairs(self._eventListeners) do
        eventManager:removeListener(id)
    end
    self._eventListeners = {}
end

---添加孩子，子节点构造函数内自动添加。
function BaseView:_addChild(key, child)
    assert(self._children[key] == nil)
    self._children[key] = child
end

---移除一个孩子。
function BaseView:removeChild(key)
    local child = self._children[key]
    assert(child ~= nil, self:getFullName() .. " cannot remove key: " .. tostring(key))
    child:destroy()
    self._children[key] = nil
end

function BaseView:tryRemoveChild(key)
    if self:hasChild(key) then
        self:removeChild(key)
    end
end

function BaseView:hasChild(key)
    return self._children[key] ~= nil
end

---移除全部孩子，析构函数自动调用。
function BaseView:removeAllChildren()
    local allChildren = {}
    for _, child in pairs(self._children) do
        table.insert(allChildren, child)
    end
    for _, child in ipairs(allChildren) do
        child:destroy()
    end
    self._children = {}
end

---获取视图节点。
function BaseView:getRoot()
    return self._root
end

---获取视图所在窗口。
function BaseView:getWindow()
    if self.isWindow then
        return self
    end
    return self._parent:getWindow()
end

---获取视图在窗口的位置。
function BaseView:getPositionInWindow()
    if self.isWindow then
        return 0, 0
    end
    local topX, topY = self._parent:getPositionInWindow()
    return topX + self._root.positionX, topY + self._root.positionY
end

function BaseView:getFullName()
    if self._parent == nil then
        return self._name
    else
        return self._parent:getFullName() .. "." .. self._name
    end
end

---向上级视图请求修正布局。
function BaseView:requestParentChangeLayout(key)
    if self._parent.onChildLayoutChanged ~= nil then
        self._parent:onChildLayoutChanged(key)
    end
end

---重载
---@param widget TCE.BaseWidget
---@param changedNames table
function BaseView:onNotifyChanges(widget, changedNames)
end

---重载
function BaseView:adjustLayout(isInitializing, location)
end

return BaseView