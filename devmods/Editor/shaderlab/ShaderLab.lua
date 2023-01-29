local Enum = require("ShaderLabEnum")

local Operation = Enum.Operation
local OperationMappings = Enum.OperationMappings
local ValueType = Enum.ValueType
local ValueTypeMappings = Enum.ValueTypeMappings
local ChannelCode = { "r", "g", "b", "a" }

local OperationStartupConfig = {
    [Operation.VertexPosition] = {
        outputs = { { "Position", ValueType.Float3 }, },
    },
    [Operation.VertexColor] = {
        outputs = { { "Color", ValueType.Float4 }, },
    },
    [Operation.VertexTextureCoordinate] = {
        outputs = { { "TextureCoordinate", ValueType.Float2 }, },
    },
    [Operation.TextureSampler2D] = {
        inputs = { { "Texture", ValueType.Sampler2D }, { "UV", ValueType.Float2 }, },
        outputs = { { "RGBA", ValueType.Float4 }, { "R", ValueType.Float }, { "G", ValueType.Float }, { "B", ValueType.Float }, { "A", ValueType.Float }, },
    },
    [Operation.VertexShaderOutput] = {
        inputs = { { "Position", ValueType.Float3 }, { "VaryingValue", ValueType.Float2 }, },
    },
    [Operation.Parameter] = {
        outputs = { { "Texture", ValueType.Sampler2D }, },
    },
    [Operation.Dot] = {
        inputs = { { "A", ValueType.Float3 }, { "B", ValueType.Float3 }, },
        outputs = { { "Out", ValueType.Float }, },
    },
}

local ValueTypeToGlslType = {
    [ValueType.Float] = "float",
    [ValueType.Float2] = "vec2",
    [ValueType.Float3] = "vec3",
    [ValueType.Float4] = "vec4",
    [ValueType.Sampler2D] = "sampler2D",
}

local ValueTransformCodes = {
    [ValueType.Float] = {
        [ValueType.Float2] = function(s) return string.format("vec2(%s)", s) end,
        [ValueType.Float3] = function(s) return string.format("vec3(%s)", s) end,
        [ValueType.Float4] = function(s) return string.format("vec4(%s)", s) end,
    },
    [ValueType.Float2] = {
        [ValueType.Float] = function(s) return string.format("%s.r", s) end,
        [ValueType.Float3] = function(s) return string.format("vec3(%s, 0.0)", s) end,
        [ValueType.Float4] = function(s) return string.format("vec4(%s, 0.0, 0.0)", s) end,
    },
    [ValueType.Float3] = {
        [ValueType.Float] = function(s) return string.format("%s.r",s) end,
        [ValueType.Float2] = function(s) return string.format("%s.rg",s) end,
        [ValueType.Float4] = function(s) return string.format("vec4(%s, 0.0)", s) end,
    },
    [ValueType.Float4] = {
        [ValueType.Float] = function(s) return string.format("%s.r",s) end,
        [ValueType.Float2] = function(s) return string.format("%s.rg",s) end,
        [ValueType.Float3] = function(s) return string.format("%s.rgb",s) end,
    },
}

---@class TCE.ShaderNodeSlot:TCE.BlueprintSlot
local ShaderNodeSlot = class("ShaderNodeSlot", require("blueprint.BlueprintSlot"))

function ShaderNodeSlot:__init(isInput, valueType, name, defaultValue)
    ShaderNodeSlot.super.__init(self, isInput)
    self.valueType = valueType
    self.name = name
    self.defaultValue = defaultValue
end

---@class TCE.ShaderNode:TCE.BlueprintNode
local ShaderNode = class("ShaderNode", require("blueprint.BlueprintNode"))

function ShaderNode:__init(op, graph, pos)
    ShaderNode.super.__init(self, graph, pos)
    self.op = op
    print("node:", OperationMappings[op], self._guid)
    self:_initSlots()
end

function ShaderNode:_initSlots()
    local function _setupSlots(_cfgList, _slots, isInput)
        if _cfgList == nil then
            return
        end
        for i, e in ipairs(_cfgList) do
            _slots[i] = ShaderNodeSlot.new(isInput, e[2], e[1], "")
        end
    end
    local cfg = OperationStartupConfig[self.op]
    _setupSlots(cfg.inputs, self.inputs, true)
    _setupSlots(cfg.outputs, self.outputs, false)
    self:updateLocation()
end

function ShaderNode:addInputSlot(valueType, name, defaultValue)
    defaultValue = defaultValue or ""
    table.insert(self.inputs, ShaderNodeSlot.new(true, valueType, name, defaultValue))
    return #self.inputs
end

---@class TCE.ShaderGraphCache
local ShaderGraphCache = class("ShaderGraphCache")

function ShaderGraphCache:__init(totalNodes)
    self.attrDict = {}
    self.uniformDict = {}
    self.varyingDict = {}
    self.defCodeArea = {}
    self.mainCodeArea = {}
    self._curVarIndex = 0
    self._curMainCodeIndex = 0

    for i = 1, totalNodes + 2 do
        self.mainCodeArea[i] = {}
    end
end

function ShaderGraphCache:toCode()
    local resList = { "\n" }
    for _, code in ipairs(self.defCodeArea) do
        table.insert(resList, code)
    end
    for _, codes in ipairs(self.mainCodeArea) do
        for _, code in ipairs(codes) do
            table.insert(resList, code)
        end
    end

    return table.concat(resList)
end

function ShaderGraphCache:trySetAttr(valueType, name)
    if self:_shouldSet(self.attrDict, name) then
        self:addDefStatement("attribute %s %s;", ValueTypeToGlslType[valueType], name)
    end
end

function ShaderGraphCache:trySetUniform(valueType, name)
    if self:_shouldSet(self.uniformDict, name) then
        self:addDefStatement("uniform %s %s;", ValueTypeToGlslType[valueType], name)
    end
end

function ShaderGraphCache:trySetVarying(valueType, name)
    if self:_shouldSet(self.varyingDict, name) then
        self:addDefStatement("varying %s %s;", ValueTypeToGlslType[valueType], name)
    end
end

function ShaderGraphCache:addDefCode(code)
    table.insert(self.defCodeArea, code)
end

function ShaderGraphCache:addMainCode(code)
    table.insert(self.mainCodeArea[self._curMainCodeIndex + 1], code)
end

function ShaderGraphCache:addDefStatement(code, ...)
    self:addDefCode(string.format(code, ...))
    self:addDefCode("\n")
end

function ShaderGraphCache:addMainStatement(code, ...)
    self:addMainCode("    ")
    self:addMainCode(string.format(code, ...))
    self:addMainCode("\n")
end

function ShaderGraphCache.toTempVarStr(varIndex)
    return string.format("_v%d", varIndex)
end

function ShaderGraphCache.toParameterVarStr(inputName)
    return string.format("u_%s", inputName)
end

function ShaderGraphCache.toCastExpr(toType, fromType, varName)
    local res = varName
    if toType ~= fromType then
        local fs = ValueTransformCodes[fromType]
        local f = fs[toType]
        if f ~= nil then
            res = f(varName)
        end
    end
    return res
end

function ShaderGraphCache:declareTempVar(valueType, setter)
    self._curVarIndex = self._curVarIndex + 1
    local code = string.format("%s %s", ValueTypeToGlslType[valueType], self.toTempVarStr(self._curVarIndex))
    if setter ~= nil then
        local setterType = setter[1]
        local setterVar = setter[2]
        local setterCode = ShaderGraphCache.toCastExpr(valueType, setterType, setterVar)
        code = code .. string.format(" = %s", setterCode)
    end
    code = code .. ";"
    self:addMainStatement(code)
    return self._curVarIndex
end

function ShaderGraphCache:_shouldSet(dict, varName)
    if dict[varName] ~= nil then
        return false
    end
    dict[varName] = true
    return true
end

---@class TCE.ShaderGraph:TCE.BlueprintGraph
local ShaderGraph = class("ShaderGraph", require("blueprint.BlueprintGraph"))

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
---@param nodeCache TCE.BlueprintNodeCache
function ShaderGraph.declareTempVars(node, cache, nodeCache)
    local function _doDeclare(_slots, slotData, isIn)
        local resList = {}
        for i = 1, #_slots do
            local valueType = _slots[i].valueType
            if valueType == ValueType.Sampler2D then
                assert(isIn and slotData[i] ~= nil and slotData[i][1] == valueType)
                resList[i] = slotData[i][2]
            else
                local setter
                if isIn and slotData[i] ~= nil then
                    setter = slotData[i]
                end
                if isIn or (not isIn and slotData[i]) then
                    local id = cache:declareTempVar(valueType, setter)
                    resList[i] = ShaderGraphCache.toTempVarStr(id)
                end
            end
        end
        return resList
    end

    local ins = _doDeclare(node.inputs, nodeCache.inData, true)
    local outs = _doDeclare(node.outputs, nodeCache.outData, false)

    return ins, outs
end

---@param node TCE.ShaderNode
---@param outs number[]
function ShaderGraph.getOutputCacheArray(node, outs)
    local res = {}
    for i = 1, #node.outputs do
        res[i] = { node.outputs[i].valueType, outs[i] }
    end
    return res
end

--------------------------------------------------------------------------------
--- 顶点输入
--------------------------------------------------------------------------------

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
function ShaderGraph.solveVertexInput(node, cache, varName)
    local valueType = node.outputs[1].valueType
    cache:trySetAttr(valueType, varName)
    return { [1] = { valueType, varName } }
end

function ShaderGraph.solveVertexPosition(node, cache)
    return ShaderGraph.solveVertexInput(node, cache, "vs_position")
end

function ShaderGraph.solveVertexColor(node, cache)
    return ShaderGraph.solveVertexInput(node, cache, "vs_color")
end

function ShaderGraph.solveVertexTextureCoordinate(node, cache)
    return ShaderGraph.solveVertexInput(node, cache, "vs_uv")
end

--------------------------------------------------------------------------------
--- 参数
--------------------------------------------------------------------------------

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
function ShaderGraph.solveParameter(node, cache)
    local valueType = node.outputs[1].valueType
    local varName = ShaderGraphCache.toParameterVarStr(node.outputs[1].name)
    cache:trySetUniform(valueType, varName)
    return { [1] = { valueType, varName } }
end

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
function ShaderGraph.solveTextureSampler2D(node, cache, nodeCache)
    local ins, outs = ShaderGraph.declareTempVars(node, cache, nodeCache)
    cache:addMainStatement("%s = texture2D(%s, %s);", outs[1], ins[1], ins[2])

    for i = 1, 4 do
        if outs[i + 1] then
            cache:addMainStatement("%s = %s." .. ChannelCode[i] .. ";", outs[i + 1], outs[1])
        end
    end

    return ShaderGraph.getOutputCacheArray(node, outs)
end

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
function ShaderGraph.solveDot(node, cache, nodeCache)
    local ins, outs = ShaderGraph.declareTempVars(node, cache, nodeCache)
    cache:addMainStatement("%s = dot(%s, %s);", outs[1], ins[1], ins[2])

    return ShaderGraph.getOutputCacheArray(node, outs)
end

---@param node TCE.ShaderNode
---@param cache TCE.ShaderGraphCache
---@param nodeCache TCE.BlueprintNodeCache
function ShaderGraph.solveVertexShaderOutput(node, cache, nodeCache)
    for k, v in pairs(nodeCache.inData) do
        if k == 1 then
            cache:addMainStatement("gl_Position = %s;", v[2])
        else
            local varyingType = node.inputs[k].valueType
            local varyingName = node.inputs[k].name
            local setterCode = ShaderGraphCache.toCastExpr(varyingType, v[1], v[2])
            cache:trySetVarying(varyingType, varyingName)
            cache:addMainStatement("%s = %s;", varyingName, setterCode)
        end
    end
    return {}
end

local SolveFuncDict = {
    [Operation.VertexPosition] = ShaderGraph.solveVertexPosition,
    [Operation.VertexColor] = ShaderGraph.solveVertexColor,
    [Operation.VertexTextureCoordinate] = ShaderGraph.solveVertexTextureCoordinate,
    [Operation.Parameter] = ShaderGraph.solveParameter,
    [Operation.TextureSampler2D] = ShaderGraph.solveTextureSampler2D,
    [Operation.Dot] = ShaderGraph.solveDot,
    [Operation.VertexShaderOutput] = ShaderGraph.solveVertexShaderOutput,
}

function ShaderGraph:__init()
    ShaderGraph.super.__init(self)
    self.cache = nil
end

---@param op number
---@param pos Vector2
function ShaderGraph:addNode(op, pos)
    local node = ShaderNode.new(op, self, pos)
    self:_addNode(node)
    return node
end

function ShaderGraph:_beginSolve()
    self.cache = ShaderGraphCache.new(self._totalNodes)
    self.cache:addMainCode("void main() {\n")
end

function ShaderGraph:_solveNode(i, node, nodeCache)
    self.cache._curMainCodeIndex = i
    return SolveFuncDict[node.op](node, self.cache, nodeCache)
end

function ShaderGraph:_endSolve()
	self.cache._curMainCodeIndex = self._totalNodes + 1
    self.cache:addMainCode("}")

    local code = self.cache:toCode()
    self.cache = nil
    return code
end

return ShaderGraph