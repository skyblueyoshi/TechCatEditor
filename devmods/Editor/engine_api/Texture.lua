---@API

---@class Texture 描述纹理资源对象。
---@field id number 资源ID。
---@field handleID number 平台相关句柄ID。
---@field isValid boolean 资源对象是否有效（空指针、已被释放则无效）。
---@field width number 纹理像素宽度。
---@field height number 纹理像素高度。
---@field texelWidth number 纹理横向单位。
---@field texelHeight number 纹理纵向单位。
---@field mipmapLevel number Mipmap层数。
---@field isLoaded boolean 当前纹理资源是否已经加载完成。
---@field fromExternalStorage boolean 纹理资源是否来自外部存储空间。
local Texture = {}

---获取当前纹理对象的整个纹理区域。
---@return TextureLocation
function Texture:getTextureLocation()
end

---获取当前纹理对象的资源路径。
function Texture:getFilePath()
end

return Texture