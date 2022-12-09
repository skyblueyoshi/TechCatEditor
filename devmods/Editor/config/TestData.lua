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

local TestTree = {
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
}

local TestTree2 = {
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

local ContainerLT = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "Level",
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
                Text = "Resouce",
            },
            Container = {
                GridView = TestGrid,
            },
        },
    },
}

local ContainerR = {
    IsSide = true,
    TabView = {
        {
            Tab = {
                Text = "GameObjectList",
            },
            Container = {
                TreeView = TestTree,
            },
        },
        {
            Tab = {
                Text = "BBB",
            },
            Container = {
                TreeView = TestTree2,
            },
        },
    },
}

local window = {
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
    }
}

return window