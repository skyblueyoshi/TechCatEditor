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
        "icon_go",
        "icon_go",
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
    Children = {
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
        },
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
        },
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
        },
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
        },
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
        },
        {
            Text = "AAA",
        },
        {
            Text = "bbb",
        },
        {
            Text = "cc cc",
        },
        {
            Text = "DDD dd",
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
                Icon = "icon_go",
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
            Place = {2},
            Container = ContainerT,
        },
    }
}

local PopupMenu = {
    elements = {
        {
            text = "Element 0",
        },
        {
            text = "Element 1",
        },
    },
}

local MenuBarData = {
    elements = {
        {
            text = "File",
            popupMenu = PopupMenu,
        },
        {
            text = "Edit",
            popupMenu = PopupMenu,
        },
    }
}

local EditorWindowData = {
    MenuBar = UIData.create("MenuBar", MenuBarData),
}

return EditorWindowData