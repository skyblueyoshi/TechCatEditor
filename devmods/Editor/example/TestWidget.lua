

local PopupMenu_Edit = {
    elements = {
        { text = "@Undo",icon = "icon_16_undo", hotKeys = { "Ctrl", "Z" } },
        { text = "@Redo",icon = "icon_16_redo", hotKeys = { "Ctrl", "Y" } },
        { text = "@Cut", icon = "icon_16_cut", hotKeys = { "Ctrl", "X" } },
        { text = "@Copy", icon = "icon_16_copy", hotKeys = { "Ctrl", "C" } },
        { text = "@Paste", icon = "icon_16_paste", hotKeys = { "Ctrl", "V" } },
    },
}

local PopupMenu = {
    elements = {
        { text = "Element 0", },
        { text = "Element 1", },
    },
}

local MenuBarData = {
    elements = {
        { text = "@File", icon = "icon_16_folder", popupMenu = PopupMenu, clickCallback = "CmdTest/hello", },
        { text = "@Edit", icon = "icon_16_copy", popupMenu = PopupMenu_Edit, },
        { text = "Edit22", icon = "icon_16_paste", popupMenu = PopupMenu, },
    }
}


local TreeData = {
    iconList = { "icon_16_go", "icon_16_go" },
    elements = {
        {
            text = "@All Mods",
            elements = {
                { text = "@Items", icon = "icon_16_diamond" },
                { text = "@Blocks", icon = "icon_16_block", canExpand = true, },
                { text = "@Recipes", icon = "icon_16_recipe", },
                { text = "@Npcs", icon = "icon_16_npc", },
                { text = "@Projectiles", icon = "icon_16_projectile", },
                { text = "@Effects", icon = "icon_16_effect", },
                { text = "@Buffs", icon = "icon_16_buff", },
                { text = "@Buildings", icon = "icon_16_building", },
                { text = "@Liquids", icon = "icon_16_liquid", },
                { text = "@Skins", icon = "icon_16_skin", },
                { text = "@Languages", icon = "icon_16_locale", },
                { text = "@Sounds", icon = "icon_16_sound", },
                { text = "@Music", icon = "icon_16_music", },
            }
        },
        {
            text = "TerraCraft",
            elements = {
                { text = "@Items", icon = "icon_16_diamond" },
                { text = "@Blocks", icon = "icon_16_block", canExpand = true, },
                { text = "@Recipes", icon = "icon_16_recipe", },
                { text = "@Npcs", icon = "icon_16_npc", },
                { text = "@Projectiles", icon = "icon_16_projectile", },
                { text = "@Effects", icon = "icon_16_effect", },
                { text = "@Buffs", icon = "icon_16_buff", },
                { text = "@Buildings", icon = "icon_16_building", },
                { text = "@Liquids", icon = "icon_16_liquid", },
                { text = "@Skins", icon = "icon_16_skin", },
                { text = "@Languages", icon = "icon_16_locale", },
                { text = "@Sounds", icon = "icon_16_sound", },
                { text = "@Music", icon = "icon_16_music", },
            }
        },
    }
}

local TestGrid = {
    elements = {
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
        {
            text = "AAA",
        },
        {
            text = "bbb",
        },
        {
            text = "cc cc",
        },
        {
            text = "DDD dd",
        },
    }
}


local PropertyData = {

    config = {
        elements = {
            [1] = { propertyType = "Boolean", },
            [2] = {
                propertyType = "ComboBox",
                popupMenu = {
                    elements = {
                        { text = "Blend", },
                        { text = "Alpha", },
                        { text = "Probe", },
                        { text = "Canvas", },
                    }
                },
            },
            [3] = { propertyType = "Int", params = { limits = { 1, 100 } } },
            [4] = { propertyType = "Float", },
        }
    },
    elements = {
        { text = "启用", configIndex = 1, value = true, },
        { text = "设置", configIndex = 1, value = false, },
        { text = "效果", configIndex = 2, value = 2, },
        { text = "效果", configIndex = 2, value = 3, },
        { text = "Speed", configIndex = 4, value = 3.14159, params = { 1, 100 } },
    }
}

local EditorLeft = {
    isSide = true,
    tab = {
        elements = {
            {
                tabButton = { text = "@Mod Resource", icon = "icon_16_go", },
                container = { tree = TreeData, },
            },
        },
    },
}

local EditorRight = {
    isSide = true,
    tab = {
        elements = {
            {
                tabButton = { text = "Class", icon = "icon_16_go", },
                container = { propertyList = PropertyData, },
            },
        },
    },
}

local EditorBottom = {
    isSide = true,
    tab = {
        elements = {
            {
                tabButton = { text = "Resource", icon = "icon_folder_16", },
                container = {
                    layouts = {
                        { place = { 1, 4 }, container = EditorLeft, },
                        { place = { 2, 3, 5, 6 }, container = { grid = TestGrid, }, },
                    }
                },
            },
            {
                tabButton = { text = "Resource222", icon = "icon_folder_16", },
                container = { grid = TestGrid, }
            },
            {
                tabButton = { text = "qwer", icon = "icon_folder_16", },
                container = { propertyList = PropertyData, },
            },
        },
    },
}

local EditorWindowData = {
    menuBar = MenuBarData,
    layouts = {
        { place = { 1 }, container = { tree = TreeData }, },
        { place = { 4, 5 }, container = EditorBottom, },
        { place = { 3, 6 }, container = EditorRight, },
        { place = { 2 }, container = { renderTarget = {} } },
    }
}

--Input.keyboard:getHotKeys(Keys.P):addListener(function()
--        self:beginNotifyDetect()
--        self:elementsAdd(require("WidgetPool").loadTreeElement({ text = "@Items", icon = "icon_16_diamond" }))
--        self:endNotifyDetect()
--    end)
--    Input.keyboard:getHotKeys(Keys.O):addListener(function()
--        self:beginNotifyDetect()
--        self:elementsRemoveAt(1)
--        self:endNotifyDetect()
--    end)

return EditorWindowData