local UIData = require("control.data.UIData")

local popupMenuA = {
    {
        Text = "Test...",
    },
    {
        Text = "Test222...",
        Children = {
            {
                Text = "Mod Test1...",
                HotKeys = {
                    "Ctrl", "Shift", "Q"
                }
            },
            {
                Text = "Mod Test123...",
                HotKeys = {
                    "Ctrl", "Shift", "Q"
                }
            },
        }
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Test3333...",
    },
}

local popupMenu = {
    {
        Text = "New Mod...",
    },
    {
        Text = "Open...",
        HotKeys = {
            "Ctrl", "Shift", "Q"
        }
    },
    {
        Text = "Test Some",
        HotKeys = {
            "Ctrl", "Q"
        },
        Children = popupMenuA,

    },
    {
        Text = "Test...",
    },
    {
        Text = "Test222...",
        Children = {
            {
                Text = "ModTest1...",
                HotKeys = {
                    "Ctrl", "Shift", "Q"
                }
            },
            {
                Text = "ModTest123...",
                HotKeys = {
                    "Ctrl", "Shift", "Q"
                }
            },
        }
    },
    {
        Text = "Test3333...",
    },
    {
        Text = "Save",
    },
    {
        Text = "Exit",
        HotKeys = {
            "Ctrl", "R"
        }
    },
}

local menuBar = {
    Children = {
        {
            Text = "File",
            PopupMenu = popupMenu,
        },
        {
            Text = "Edit",
            PopupMenu = popupMenuA,
        },
        {
            Text = "View",
            PopupMenu = popupMenu,
        },
        {
            Text = "Code",
            PopupMenu = popupMenuA,
        },
        {
            Text = "Run",
        },
    }
}

local TestProperty = {
    Config = {
        [1] = {
            Type = "Boolean",
        },
        [2] = {
            Type = "ComboBox",
            Children = {
                {
                    Text = "Blend",
                },
                {
                    Text = "Alpha",
                },
                {
                    Text = "Probe",
                },
                {
                    Text = "Canvas",
                },
            },
        },
        [3] = {
            Type = "Int",
        },
        [4] = {
            Type = "Float",
        },
    },
    Children = {
        {
            "启用", 1, true,
        },
        {
            "设置", 1, false,
        },
        {
            "效果", 2, 2,
        },
        {
            "动画", 3, 1, { 1, 100 }
        },
        {
            "Speed", 4, 3.14159, { 1, 100 }
        },
        --{
        --    "Enable", 1, true,
        --},
        --{
        --    "Flag", 1, false,
        --},
        --{
        --    "ComboBox", 2, 2,
        --},
        --{
        --    "Value", 3, 1, { 1, 100 }
        --},
        --{
        --    "Speed", 4, 3.14159, { 1, 100 }
        --},
        --{
        --    "Enable", 1, true,
        --},
        --{
        --    "Flag", 1, false,
        --},
        --{
        --    "ComboBox", 2, 2,
        --},
        --{
        --    "Value", 3, 1, { 1, 100 }
        --},
        --{
        --    "Speed", 4, 3.14159, { 1, 100 }
        --},
        --{
        --    "Enable", 1, true,
        --},
        --{
        --    "Flag", 1, false,
        --},
        --{
        --    "ComboBox", 2, 2,
        --},
        --{
        --    "Value", 3, 1, { 1, 100 }
        --},
        --{
        --    "Speed", 4, 3.14159, { 1, 100 }
        --},
        --{
        --    "Enable", 1, true,
        --},
        --{
        --    "Flag", 1, false,
        --},
        --{
        --    "ComboBox", 2, 2,
        --},
        --{
        --    "Value", 3, 1, { 1, 100 }
        --},
        --{
        --    "Speed", 4, 3.14159, { 1, 100 }
        --},
    },
}

local TestTree = {
    IconList = {
        "icon_16_go",
        "icon_16_go",
    },
    Children = {
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                    Children = {
                        {
                            Text = "Hat1",
                        },
                        {
                            Text = "Hat2",
                        },
                        {
                            Text = "Hat3",
                        },
                        {
                            Text = "Hat4",
                        },
                    }
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
            }
        },
    },
}

local TestTree2 = {
    Children = {
        {
            Text = "GameObject",
            Children = {
                {
                    Text = "Cup",
                },
                {
                    Text = "Cup2",
                    CanExpand = true,
                },
                {
                    Text = "Cup3",
                },
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

local TestRenderTarget = {

}

local ContainerT = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "Editor",
                Icon = "icon_level",
            },
            Container = {
                RenderTargetView = TestRenderTarget,
            },
        },
        {
            Tab = {
                Text = "Game",
                Icon = "icon_level",
            },
            Container = {
                RenderTargetView = TestRenderTarget,
            },
        },
    },
}

local ContainerLT = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "Hierarchy",
                Icon = "icon_level",
            },
            Container = {
                TreeView = TestTree,
            },
        },
    },
}

local ContainerB = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "Resource",
                Icon = "icon_folder_16",
            },
            Container = {
                Containers = {
                    {
                        Place = { 1, 4 },
                        Container = ContainerLT,
                    },
                    {
                        Place = { 2, 3, 5, 6 },
                        Container = {
                            GridView = TestGrid,
                        },
                    },
                }
            },
        },
    },
}

local ContainerR = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "Inspector",
                Icon = "icon_inspector",
            },
            Container = {
                PropertyList = TestProperty,
            },
        },
        {
            Tab = {
                Text = "Class",
                Icon = "icon_16_go",
            },
            Container = {
                TreeView = TestTree2,
            },
        },
    },
}

local windowOld = {
    MenuBar = menuBar,
    Containers = {
        {
            Place = { 1 },
            Container = ContainerLT,
        },
        {
            Place = { 4, 5 },
            Container = ContainerB,
        },
        {
            Place = { 3, 6 },
            Container = ContainerR,
        },
        {
            Place = { 2 },
            Container = ContainerT,
        },
    }
}

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
        { text = "@File", icon = "icon_16_folder", popupMenu = PopupMenu, },
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

local CM = require("command.CommandManager")
local TestPropertyElement = {
    text = "动画", configIndex = 3, value = 1, params = { 1, 100 }
}
TestPropertyElement._post = function(data, t, mem)
    if mem == "value" then
        data:setValue(t[mem])
    end
end
TestPropertyElement._postAll = function(t, mm)
    if t._postDataList == nil then
        return
    end
    for _, d in ipairs(t._postDataList) do
        t._post(d, t, mm)
    end
end
TestPropertyElement._request = function(data, mem, v)
    if mem == "value" then
        CM.runChangeInt(TestPropertyElement, "value", v, function(_mem, _v)
            TestPropertyElement._post(data, _mem, _v)
        end)
    end
end

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
        TestPropertyElement,
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

local EditorWindowData = {
    menuBar = MenuBarData,
    --layouts = {
    --    { place = { 1 }, container = EditorLeft, },
    --    { place = { 4, 5 }, container = EditorBottom, },
    --    { place = { 3, 6 }, container = EditorRight, },
    --    {
    --        place = { 2 },
    --        container = {
    --            -- menuBar = MenuBarData,
    --            -- layouts = {
    --            --     { place = { 1 }, container = EditorLeft, },
    --            --     { place = { 4, 5 }, container = EditorBottom, },
    --            --     { place = { 3, 6 }, container = EditorRight, },
    --            --     {
    --            --         place = { 2 },
    --            --         container = EditorLeft,
    --            --     },
    --            -- },
    --            renderTarget = {
    --                text = "123"
    --            },
    --        }
    --    },
    --},
    renderTarget = {
        text = "123"
    },
}

return EditorWindowData