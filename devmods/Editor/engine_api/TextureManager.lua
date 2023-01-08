---@API

---@class TextureManager 纹理管理器
local TextureManager = {}

---从assets中加载纹理，为降低GPU显存占用，默认调用TextureManager.loadAsynchronousWhenAwake。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.load(filePath)
end

---从assets中立即加载纹理。主线程将会阻塞直到纹理加载完成。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadImmediately(filePath)
end

---从assets中异步加载纹理。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadAsynchronous(filePath)
end

---从assets中仅纹理被使用时，异步加载纹理。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadAsynchronousWhenAwake(filePath)
end

---从文件系统中加载纹理，为降低GPU显存占用，默认调用TextureManager.loadAsynchronousWhenAwake。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadFromFile(filePath)
end

---从文件系统中立即加载纹理。主线程将会阻塞直到纹理加载完成。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadFromFileImmediately(filePath)
end

---从文件系统中异步加载纹理。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadFromFileAsynchronous(filePath)
end

---从文件系统中仅纹理被使用时，异步加载纹理。
---@param filePath string 资源路径。
---@return TextureLocation 纹理位置。
function TextureManager.loadFromFileAsynchronousWhenAwake(filePath)
end

---获取指定纹理位置所指向的纹理。如果纹理位置描述的是单独的纹理，则返回整个纹理对象；如果纹理位置描述的是图集里的区域，则返回这个图集的纹理对象。
---@param textureLocation TextureLocation 纹理位置。
---@return Texture 纹理对象。
function TextureManager.getTargetTextureByLocation(textureLocation)
end

---由资源ID获取纹理对象。
---@param resourceID number 资源ID。
---@return Texture 纹理对象。
function TextureManager.getTextureByID(resourceID)
end

---释放指定资源ID的纹理对象。
---@param resourceID number 资源ID。
function TextureManager.releaseTextureByID(resourceID)
end

---获取指定纹理位置在实际纹理中的裁切区域。如果纹理位置描述的是单独的纹理，则返回整个纹理区域；如果纹理位置描述的是图集里的区域，则返回这个图集中的区域。
---@field textureLocation TextureLocation 纹理位置。
---@return Rect 在实际纹理中的裁切区域。
function TextureManager.getSourceRect(textureLocation)
end

---返回是否允许回收长时间未使用的贴图。
---@return boolean
function TextureManager.isGcEnabled()
end

---设置是否允许回收长时间未使用的贴图。
---@param enabled boolean
function TextureManager.setGcEnabled(enabled)
end

return TextureManager