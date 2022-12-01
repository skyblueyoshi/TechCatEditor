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

local ContainerLT = {
    IsSide = true,
    TreeView = TestTree,
}

local window = {
    MenuBar = menuBar,
    Containers = {
        {
            Place = {1},
            Container = ContainerLT,
        },
        {
            Place = {4, 5},
            Container = ContainerLT,
        },
        {
            Place = {3, 6},
            Container = ContainerLT,
        },
    }
}

return window