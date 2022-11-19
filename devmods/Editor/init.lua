local Editor = require("Editor")
local s_editor = nil  ---@type TCE.Editor

function init()
    -- Init default font.
    FontManager.load("mods/Editor/font/msyh.ttf", "msyh")
    s_editor = Editor.new()
    IntegratedClient.main:addOnUpdateListener({ s_editor.update, s_editor })
    IntegratedClient.main:addOnRenderListener({ s_editor.render, s_editor })
end

function start()
    s_editor:start()
end

function exit()
    if s_editor then
        s_editor:destroy()
        s_editor = nil
    end
end