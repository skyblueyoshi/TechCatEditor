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

local ContainerLT = {
    IsSide = true
}

local window = {
    MenuBar = menuBar,
    Containers = {
        LT = ContainerLT,
        LB = ContainerLT,
        R = ContainerLT,
        CB = ContainerLT,
        CT = ContainerLT,
    }
}

return window