-- http://asqbtcupid.github.io/hotupdte-implement/

---@class HotfixEngine
local HotfixEngine = class("HotfixEngine")
---@class FileInfo
local FileInfo = class("FileInfo")
---@class ChangedFuncInfo
local ChangedFuncInfo = class("ChangedFuncInfo")

local SilencePrint = true

local function hotfixPrint(...)
    if SilencePrint then
        return
    end
    print(...)
end

---FilePathToLuaPath
---@param moduleName string
---@param filePath string
---@return string
function FileInfo.FilePathToLuaPath(moduleName, filePath)
    local luaPath = string.gsub(filePath:sub(0, #filePath - 4), "/", ".")
    if moduleName ~= nil then
        luaPath = moduleName .. "." .. luaPath
    end
    return luaPath
end

function FileInfo:__init(luaPath, absFilePath, lastWriteTime)
    self.luaPath = luaPath
    self.absFilePath = absFilePath
    self.lastWriteTime = lastWriteTime
end

function ChangedFuncInfo:__init(oldFunc, newFunc, funcName, oldTable)
    self.oldFunc = oldFunc
    self.newFunc = newFunc
    self.funcName = funcName
    self.oldTable = oldTable
end

local g_instance
---@return HotfixEngine
function HotfixEngine.getInstance()
    if g_instance == nil then
        g_instance = HotfixEngine.new()
    end
    return g_instance
end

function HotfixEngine:__init()
    self._fileInfoList = {}  ---@type FileInfo[]

    self._visitedCache = {}  ---@type string[]
    self._changedFuncInfoList = {}  ---@type ChangedFuncInfo[]

    -- fake table and environment for running the compiled new module
    -- when run the new module, everything is not really run
    -- for detail: http://asqbtcupid.github.io/luahotupdate3-global/
    self._fakeEnv = nil
    self._fakeTable = self:initFakeTable()

    -- these table and function will be ignore when replacing
    self._ignores = self:initIgnores()
    self._ignoreNames = {
        __CODE_INFO__ = true,
    }
    self._globalIgnores = {
        __oldreq = true,
        require = true
    }
end

function HotfixEngine:initIgnores()
    local ignores = {}
    ignores[setmetatable] = true
    ignores[pairs] = true
    ignores[ipairs] = true
    ignores[next] = true
    -- we don't ignore "require" function because we want to redirect to the global "require"
    --ignores[require] = true
    ignores[math] = true
    ignores[string] = true
    ignores[table] = true
    ignores[HotfixEngine] = true
    ignores[self._meta] = true
    return ignores
end

function HotfixEngine:initFakeTable()
    local meta = {}
    self._meta = meta
    self._metaMap = {}
    self._requireMap = {}

    local function FakeTable()
        return setmetatable({}, meta)
    end
    local function EmptyFunc()
    end
    local function pairs()
        return EmptyFunc
    end
    local function setmetatable(t, metaT)
        self._metaMap[t] = metaT
        return t
    end
    local function getmetatable(t, metaT)
        return setmetatable({}, t)
    end
    local function require(LuaPath)
        hotfixPrint("[Hotfix]fake require: " .. LuaPath)
        if not self._requireMap[LuaPath] then
            self._requireMap[LuaPath] = FakeTable()
        end
        return self._requireMap[LuaPath]
    end
    function meta.__index(t, k)
        if k == "setmetatable" then
            return setmetatable
        elseif k == "pairs" or k == "ipairs" then
            return pairs
        elseif k == "next" then
            return EmptyFunc
        elseif k == "require" then
            return require
        else
            local _FakeTable = FakeTable()
            rawset(t, k, _FakeTable)
            return _FakeTable
        end
    end
    function meta.__newindex(t, k, v)
        rawset(t, k, v)
    end
    function meta.__call()
        return FakeTable(), FakeTable(), FakeTable()
    end
    function meta.__add()
        return meta.__call()
    end
    function meta.__sub()
        return meta.__call()
    end
    function meta.__mul()
        return meta.__call()
    end
    function meta.__div()
        return meta.__call()
    end
    function meta.__mod()
        return meta.__call()
    end
    function meta.__pow()
        return meta.__call()
    end
    function meta.__unm()
        return meta.__call()
    end
    function meta.__concat()
        return meta.__call()
    end
    function meta.__eq()
        return meta.__call()
    end
    function meta.__lt()
        return meta.__call()
    end
    function meta.__le()
        return meta.__call()
    end
    function meta.__len()
        return meta.__call()
    end
    return FakeTable
end

---get all hotfix-able file and save in self._fileInfoList
---save these data:
---1. the lua path
---2. the abs file path
---3. the last modified time
---@param rootInfoList table
function HotfixEngine:initAllFileInfo(rootInfoList)
    for _, rootInfo in pairs(rootInfoList) do
        local moduleName = rootInfo[1]  ---@type string
        local rootPath = rootInfo[2]
        local absFilePaths = AssetManager.getAllFiles(rootPath, ".lua", false, true, true)

        for _, absFilePath in pairs(absFilePaths) do
            local luaPath = FileInfo.FilePathToLuaPath(moduleName, Path.getRelativePath(rootPath, absFilePath))
            local lastWriteTime = AssetManager.getLastWriteTime(absFilePath)
            table.insert(self._fileInfoList, FileInfo.new(luaPath, absFilePath, lastWriteTime))
        end
    end
end

function HotfixEngine:debugInfo(level, message)
    hotfixPrint("[Hotfix]" .. string.rep("  ", level) .. message)
end

function HotfixEngine:canVisit(oldObject, newObject, name)
    if oldObject == newObject then
        return false
    end
    if self._ignores[oldObject] or self._ignores[newObject] then
        return false
    end
    if self._ignoreNames[name] then
        return false
    end
    -- save two table's pointer to cache
    local flag = tostring(oldObject) .. tostring(newObject)
    if self._visitedCache[flag] then
        return false
    end
    self._visitedCache[flag] = true
    return true
end

function HotfixEngine:doReplaceFromGlobal(object, visits, recursiveLevel)
    if type(object) ~= "function" and type(object) ~= "table" then
        return
    end
    if self._ignores[object] then
        return
    end
    if visits[object] then
        return
    end
    visits[object] = true
    if type(object) == "function" then
        hotfixPrint("[Hotfix]" .. string.rep("  ", recursiveLevel) .. ">> " .. "[func]")
        for i = 1, math.huge do
            local upValueName, upValue = debug.getupvalue(object, i)
            if not upValueName then
                break
            end
            if not self._globalIgnores[upValueName] then
                if type(upValue) == "function" then
                    for _, funcInfo in pairs(self._changedFuncInfoList) do
                        if upValue == funcInfo.oldFunc then
                            hotfixPrint("[Hotfix]" .. string.rep("==", recursiveLevel) ..
                                    ">>replace from global up-value: " .. upValueName .. " with " .. funcInfo.funcName)
                            debug.setupvalue(object, i, funcInfo.newFunc)
                        end
                    end
                end
                self:doReplaceFromGlobal(upValue, visits, recursiveLevel + 1)
            end
        end
    else
        self:doReplaceFromGlobal(debug.getmetatable(object), visits, recursiveLevel + 1)

        local changedIndices
        for k, v in pairs(object) do
            if type(k) == "string" then
                hotfixPrint("[Hotfix]" .. string.rep("  ", recursiveLevel) .. ">> " .. k)
            else
                hotfixPrint("[Hotfix]" .. string.rep("  ", recursiveLevel) .. ">> " .. "[element]")
            end
            self:doReplaceFromGlobal(k, visits, recursiveLevel + 1)
            self:doReplaceFromGlobal(v, visits, recursiveLevel + 1)
            if type(v) == "function" then
                for _, funcInfo in pairs(self._changedFuncInfoList) do
                    if v == funcInfo.oldFunc then
                        hotfixPrint("[Hotfix]" .. string.rep("==", recursiveLevel) .. ">>replace from global with " .. funcInfo.funcName)
                        object[k] = funcInfo.newFunc
                    end
                end
            end
            if type(k) == "function" then
                for index, funcInfo in pairs(self._changedFuncInfoList) do
                    if k == funcInfo.oldFunc then
                        hotfixPrint("[Hotfix]" .. string.rep("==", recursiveLevel) .. ">>replace from global with " .. funcInfo.funcName)
                        changedIndices = changedIndices or {}
                        table.insert(changedIndices, index)
                    end
                end
            end
        end

        if changedIndices ~= nil then
            for _, index in pairs(changedIndices) do
                local funcInfo = self._changedFuncInfoList[index]
                object[funcInfo.newFunc] = object[funcInfo.oldFunc]
                object[funcInfo.oldFunc] = nil
            end
        end
    end
end

function HotfixEngine:replaceFromGlobal()
    local visits = {}
    visits[HotfixEngine] = true

    self:doReplaceFromGlobal(_G, visits, 0)
    self:doReplaceFromGlobal(debug.getregistry(), visits, 0)
end

function HotfixEngine:doSetCurrentEnv(object, name, fromDebugName, recursiveLevel, visits)
    if not object or visits[object] then
        return
    end
    visits[object] = true
    if type(object) == "function" or type(object) == "table" then
        self:debugInfo(recursiveLevel, "doSetCurrentEnv " .. name .. " from " .. fromDebugName)
        if type(object) == "function" then
            xpcall(function()
                setfenv(object, _G)
            end, function(...)
                hotfixPrint(...)
            end)
        elseif type(object) == "table" then
            for k, v in pairs(object) do
                self:doSetCurrentEnv(k, tostring(k) .. "__key",
                        "doSetCurrentEnv", recursiveLevel + 1, visits)
                self:doSetCurrentEnv(v, tostring(k),
                        "doSetCurrentEnv", recursiveLevel + 1, visits)
            end
        end
    end
end

---setCurrentEnv
---@param object any
---@param name string
---@param fromDebugName string
---@param recursiveLevel number
function HotfixEngine:setCurrentEnv(object, name, fromDebugName, recursiveLevel)
    local visits = {}
    self:doSetCurrentEnv(object, name, fromDebugName, recursiveLevel, visits)
end

---replaceUpValue
---@param oldFunc function
---@param newFunc function
---@param funcName string
---@param fromDebugName string
---@param recursiveLevel number
function HotfixEngine:replaceUpValue(oldFunc, newFunc, funcName, fromDebugName, recursiveLevel)
    self:debugInfo(recursiveLevel, "replaceUpValue " .. funcName .. " from " .. fromDebugName)
    if funcName == "require" then
        for i = 1, math.huge do
            local upValueName, _ = debug.getupvalue(newFunc, i)
            if not upValueName then
                break
            end
            if upValueName == "__oldreq" then
                -- set this up-value to global require
                debug.setupvalue(newFunc, i, require)
            end
        end
        return
    end
    local oldUpValues = {}
    local oldUpValueNameExists = {}
    for i = 1, math.huge do
        local upValueName, upValue = debug.getupvalue(oldFunc, i)
        if not upValueName then
            break
        end
        oldUpValues[upValueName] = upValue
        oldUpValueNameExists[upValueName] = true
    end
    for i = 1, math.huge do
        local upValueName, newUpValue = debug.getupvalue(newFunc, i)
        if not upValueName then
            break
        end
        if oldUpValueNameExists[upValueName] then
            local oldUpValue = oldUpValues[upValueName]
            if type(oldUpValue) ~= type(newUpValue) then
                debug.setupvalue(newFunc, i, oldUpValue)
            elseif type(oldUpValue) == "function" then
                self:replaceFunction(oldUpValue, newUpValue, upValueName, nil,
                        "replaceUpValue", recursiveLevel + 1)
            elseif type(oldUpValue) == "table" then
                self:replaceTable(oldUpValue, newUpValue, upValueName,
                        "replaceUpValue", recursiveLevel + 1)
                debug.setupvalue(newFunc, i, oldUpValue)
            else
                debug.setupvalue(newFunc, i, oldUpValue)
            end
        else
            -- new up-value in the new function
            self:setCurrentEnv(newUpValue, upValueName,
                    "replaceUpValue", recursiveLevel + 1)
        end
    end
end

---replaceTable
---@param oldTable table
---@param newTable table
---@param name string
---@param fromDebugName string
---@param recursiveLevel number
function HotfixEngine:replaceTable(oldTable, newTable, name, fromDebugName, recursiveLevel)
    if not self:canVisit(oldTable, newTable, name) then
        return
    end
    self:debugInfo(recursiveLevel, "replaceTable " .. name .. " from " .. fromDebugName)
    for elementName, newElement in pairs(newTable) do
        local oldElement = oldTable[elementName]
        if oldElement ~= nil then
            -- replace all table and function member
            if type(newElement) == "function" then
                self:replaceFunction(oldElement, newElement, elementName, oldTable,
                        "replaceTable", recursiveLevel + 1)
            elseif type(newElement) == "table" then
                self:replaceTable(oldElement, newElement, elementName,
                        "replaceTable", recursiveLevel + 1)
            end
        elseif type(newElement) == "function" then
            -- a new function member is added
            -- use current environment table for this new function
            if pcall(setfenv, newElement, _G) then
                oldTable[elementName] = newElement
            end
        end
    end
    local oldMetaTable = debug.getmetatable(oldTable)
    local newMetaTable = self._metaMap[newTable]
    if type(oldMetaTable) == "table" and type(newMetaTable) == "table" then
        -- replace the meta table
        self:replaceTable(oldMetaTable, newMetaTable, "Meta of " .. name,
                "replaceTable", recursiveLevel + 1)
    end
end

---replaceFunction
---@param oldFunc function
---@param newFunc function
---@param name string
---@param oldTable table
---@param fromDebugName string
---@param recursiveLevel number
function HotfixEngine:replaceFunction(oldFunc, newFunc, name, oldTable, fromDebugName, recursiveLevel)
    if not self:canVisit(oldFunc, newFunc, name) then
        return
    end
    self:debugInfo(recursiveLevel, "replaceFunction " .. name .. " from " .. fromDebugName)
    -- use the old environment table for this new function
    if pcall(debug.setfenv, newFunc, getfenv(oldFunc)) then
        self:replaceUpValue(oldFunc, newFunc, name,
                "replaceFunction", recursiveLevel + 1)
        table.insert(self._changedFuncInfoList, ChangedFuncInfo.new(oldFunc, newFunc, name, oldTable))
    end
end

---replaceModule
---@param oldObject any
---@param newObject any
---@param fileInfo FileInfo
---@param fromDebugName string
function HotfixEngine:replaceModule(oldObject, newObject, fileInfo, fromDebugName)
    if type(oldObject) == type(newObject) then
        if type(newObject) == "table" then
            self:replaceTable(oldObject, newObject, fileInfo.luaPath, fromDebugName, 0)
        elseif type(newObject) == "function" then
            self:replaceFunction(oldObject, newObject, fileInfo.luaPath, nil, fromDebugName, 0)
        end
    end
end

---replaceRequires
---@param oldModule any
---@param fileInfo FileInfo
function HotfixEngine:replaceRequires(oldModule, fileInfo)
    for luaPath, newModule in pairs(self._requireMap) do
        hotfixPrint("[Hotfix] replaceRequires " .. luaPath .. " from " .. fileInfo.luaPath)
        self:replaceModule(oldModule, newModule, luaPath, "replaceRequires")
    end
end

---updateFile
---@param fileInfo FileInfo
function HotfixEngine:updateFile(fileInfo)
    local oldModule = package.loaded[fileInfo.luaPath]
    if oldModule ~= nil then
        -- the old module is already loaded, let's do hotfix
        local lastWriteTime = AssetManager.getLastWriteTime(fileInfo.absFilePath)
        if fileInfo.lastWriteTime == lastWriteTime then
            -- file is not changed, there is no need for hotfix
            return
        end
        local newCode = __get_code(fileInfo.luaPath)
        -- compile the new lua file and get the callable function
        local newFunc = loadstring(newCode)
        if not newFunc then
            -- failed to compile
            print(fileInfo.absFilePath .. " has syntax error and hotfix failed.")
            collectgarbage("collect")
            return
        else
            -- compile success
            local newModule
            local hasError = false

            -- init the fake running environment, which will ignore all global operation
            self._fakeEnv = self._fakeTable()
            self._metaMap = {}
            self._requireMap = {}
            setfenv(newFunc, self._fakeEnv)

            -- run the compiled function
            xpcall(function()
                newModule = newFunc()
            end, function(e)
                hasError = true
                print("Hotfix error: " .. tostring(e))
            end)
            if hasError then
                collectgarbage("collect")
                return
            end
            -- run success
            print(string.format("Hotfix success: %s %s [%s to %s]",
                    fileInfo.luaPath, fileInfo.absFilePath, fileInfo.lastWriteTime, lastWriteTime))
            fileInfo.lastWriteTime = lastWriteTime
            self._visitedCache = {}
            self._changedFuncInfoList = {}

            -- replace all up-value of new module with old module's target up-value
            self:replaceModule(oldModule, newModule, fileInfo, "updateFile")
            self:replaceRequires(oldModule, fileInfo)
            if #self._changedFuncInfoList > 0 then
                self:replaceFromGlobal()
            end
            collectgarbage("collect")
        end
    end
end

function HotfixEngine:update()
    for _, fileInfo in pairs(self._fileInfoList) do
        self:updateFile(fileInfo)
    end
end

---init the hotfix engine, preload all file info
---@param rootInfoList table
function HotfixEngine.init(rootInfoList)
    HotfixEngine.getInstance():initAllFileInfo(rootInfoList)
    HotfixEngine.run()
end

---start hotfix processing
function HotfixEngine.run()
    HotfixEngine.getInstance():update()
end

return HotfixEngine