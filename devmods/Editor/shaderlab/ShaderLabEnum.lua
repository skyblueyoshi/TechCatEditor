local function GenEnumMapping(EnumClass)
    local d = {}
    local i = 0
    for k, _ in pairs(EnumClass) do
        EnumClass[k] = i
        d[i] = k
        i = i + 1
    end
    return d
end

local Operation = {
  None = 0,

  VertexPosition = 0,
  VertexColor = 0,
  VertexTextureCoordinate = 0,

  Parameter = 0,

  TextureSampler2D = 0,
  Dot = 0,

  VertexShaderOutput = 0,
  PixelShaderOutput = 0,
}
local OperationMappings = GenEnumMapping(Operation)

local ValueType = {
    None = 0,
    Float = 0,
    Float2 = 0,
    Float3 = 0,
    Float4 = 0,
    Sampler2D = 0,
}
local ValueTypeMappings = GenEnumMapping(ValueType)

return {
    Operation = Operation,
    OperationMappings = OperationMappings,
    ValueType = ValueType,
    ValueTypeMappings = ValueTypeMappings,
}