-- HollowLib | Made by hollowoodz
-- A clean, top tier Roblox UI Library
-- Red & Dark Theme | Left Sidebar | Mobile Support

local HollowLib = {}
HollowLib.__index = HollowLib

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    Sidebar = Color3.fromRGB(14, 14, 17),
    GroupBG = Color3.fromRGB(18, 18, 22),
    GroupHeader = Color3.fromRGB(22, 22, 27),
    ItemBG = Color3.fromRGB(24, 24, 30),
    Accent = Color3.fromRGB(220, 30, 30),
    AccentDark = Color3.fromRGB(160, 20, 20),
    AccentHover = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(160, 160, 170),
    TextDisabled = Color3.fromRGB(90, 90, 100),
    Border = Color3.fromRGB(35, 35, 42),
    BorderBright = Color3.fromRGB(55, 55, 65),
    Toggle = Color3.fromRGB(30, 30, 38),
    ToggleOn = Color3.fromRGB(220, 30, 30),
    SliderBG = Color3.fromRGB(25, 25, 32),
    SliderFill = Color3.fromRGB(220, 30, 30),
    DropBG = Color3.fromRGB(20, 20, 26),
    DropOpen = Color3.fromRGB(16, 16, 20),
    ScrollBar = Color3.fromRGB(60, 60, 75),
    TabActive = Color3.fromRGB(220, 30, 30),
    TabInactive = Color3.fromRGB(14, 14, 17),
    TabHover = Color3.fromRGB(30, 20, 22),
    Shadow = Color3.fromRGB(0, 0, 0),
    Watermark = Color3.fromRGB(14, 14, 17),
}

-- Utility
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style, dir), props):Play()
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function MakePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 6)
    p.PaddingBottom = UDim.new(0, bottom or 6)
    p.PaddingLeft = UDim.new(0, left or 8)
    p.PaddingRight = UDim.new(0, right or 8)
    p.Parent = parent
    return p
end

local function MakeList(parent, padding, fillDir)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, padding or 4)
    l.FillDirection = fillDir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function MakeLabel(parent, text, size, color, font, xalign)
    local l = Instance.new("TextLabel")
    l.Text = text or ""
    l.TextSize = size or 13
    l.TextColor3 = color or Theme.Text
    l.Font = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Size = UDim2.new(1, 0, 0, size and size + 4 or 18)
    l.Parent = parent
    return l
end

local function MakeFrame(parent, size, pos, color, trans)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1, 0, 0, 30)
    f.Position = pos or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = color or Theme.Background
    f.BackgroundTransparency = trans or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

local function MakeButton(parent, size, pos, color)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1, 0, 0, 30)
    b.Position = pos or UDim2.new(0, 0, 0, 0)
    b.BackgroundColor3 = color or Theme.ItemBG
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = parent
    return b
end

local function MakeImage(parent, id, size, pos)
    local i = Instance.new("ImageLabel")
    i.Image = id or ""
    i.Size = size or UDim2.new(0, 16, 0, 16)
    i.Position = pos or UDim2.new(0, 0, 0, 0)
    i.BackgroundTransparency = 1
    i.Parent = parent
    return i
end

local function AutoSize(frame, list)
    list.Changed:Connect(function()
        frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, list.AbsoluteContentSize.Y + 12)
    end)
end

-- Dragging
local function MakeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HollowLib"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- ==================
-- WINDOW
-- ==================
function HollowLib:CreateWindow(config)
    local Window = {}
    local Tabs = {}
    local ActiveTab = nil

    -- Main Frame
    local Main = MakeFrame(ScreenGui, UDim2.new(0, 620, 0, 420), UDim2.new(0.5, -310, 0.5, -210), Theme.Background)
    Main.Name = "HollowWindow"
    MakeCorner(Main, 8)
    MakeStroke(Main, Theme.Border, 1)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = -1
    Shadow.Parent = Main

    -- Topbar
    local Topbar = MakeFrame(Main, UDim2.new(1, 0, 0, 36), nil, Theme.Sidebar)
    MakeCorner(Topbar, 8)
    local TopFix = MakeFrame(Topbar, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), Theme.Sidebar)

 
    
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(0, 28, 0, 28)
    LogoContainer.Position = UDim2.new(0, 10, 0.5, -14)
    LogoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    LogoContainer.BorderSizePixel = 0
    LogoContainer.Parent = Topbar

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoContainer

    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = Color3.fromRGB(220, 30, 30) -- red accent
    LogoStroke.Thickness = 1
    LogoStroke.Parent = LogoContainer

    -- Actual Image
    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Image = "rbxassetid://109250647122928"
    LogoImg.Size = UDim2.new(1, -6, 1, -6)
    LogoImg.Position = UDim2.new(0, 3, 0, 3)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Parent = LogoContainer
    
    -- Optional texture overlay
    LogoImg.ScaleType = Enum.ScaleType.Fit



    -- Title
    local TitleLabel = MakeLabel(Topbar, config.Title or "HollowLib", 13, Theme.Text, Enum.Font.GothamBold)
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 26, 0, 0)
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Close button
    local CloseBtn = MakeButton(Topbar, UDim2.new(0, 28, 0, 28), UDim2.new(1, -32, 0.5, -14), Theme.Sidebar)
    MakeCorner(CloseBtn, 6)
    local CloseX = MakeLabel(CloseBtn, "×", 18, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    CloseX.Size = UDim2.new(1, 0, 1, 0)
    CloseX.TextYAlignment = Enum.TextYAlignment.Center

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
        Tween(CloseX, {TextColor3 = Theme.Text}, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Sidebar}, 0.15)
        Tween(CloseX, {TextColor3 = Theme.TextDim}, 0.15)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 620, 0, 0), Position = UDim2.new(0.5, -310, 0.5, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.35)
        ScreenGui:Destroy()
    end)

    -- Minimize button
    local MinBtn = MakeButton(Topbar, UDim2.new(0, 28, 0, 28), UDim2.new(1, -64, 0.5, -14), Theme.Sidebar)
    MakeCorner(MinBtn, 6)
    local MinLabel = MakeLabel(MinBtn, "−", 16, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    MinLabel.Size = UDim2.new(1, 0, 1, 0)
    MinLabel.TextYAlignment = Enum.TextYAlignment.Center

    local minimized = false
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.GroupBG}, 0.15) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.Sidebar}, 0.15) end)
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, {Size = UDim2.new(0, 620, 0, 36)}, 0.3)
        else
            Tween(Main, {Size = UDim2.new(0, 620, 0, 420)}, 0.3)
        end
    end)

    MakeDraggable(Topbar, Main)

    -- Content area
    local Content = MakeFrame(Main, UDim2.new(1, 0, 1, -36), UDim2.new(0, 0, 0, 36), Theme.Background)

    -- Sidebar
    local Sidebar = MakeFrame(Content, UDim2.new(0, 130, 1, 0), nil, Theme.Sidebar)
    MakeStroke(Sidebar, Theme.Border, 1)

    -- Sidebar title
    local SideTitle = MakeLabel(Sidebar, "NAVIGATION", 9, Theme.TextDisabled, Enum.Font.GothamBold)
    SideTitle.Size = UDim2.new(1, -16, 0, 20)
    SideTitle.Position = UDim2.new(0, 8, 0, 8)
    SideTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Sidebar tab list
    local TabList = MakeFrame(Sidebar, UDim2.new(1, 0, 1, -36), UDim2.new(0, 0, 0, 30), Theme.Sidebar)
    TabList.ClipsDescendants = true
    local TabListLayout = MakeList(TabList, 2)
    MakePadding(TabList, 4, 4, 6, 6)

    -- Player info at bottom of sidebar
    local PlayerInfo = MakeFrame(Sidebar, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 1, -40), Theme.Sidebar)
    MakeStroke(PlayerInfo, Theme.Border, 1)
    MakePadding(PlayerInfo, 6, 6, 8, 8)

    local PlayerAvatar = MakeImage(PlayerInfo, "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=48&height=48&format=png", UDim2.new(0, 24, 0, 24), UDim2.new(0, 0, 0.5, -12))
    MakeCorner(PlayerAvatar, 12)

    local PlayerName = MakeLabel(PlayerInfo, LocalPlayer.DisplayName, 11, Theme.Text, Enum.Font.GothamMedium)
    PlayerName.Size = UDim2.new(1, -32, 0, 14)
    PlayerName.Position = UDim2.new(0, 30, 0, 6)

    local PlayerUser = MakeLabel(PlayerInfo, "@"..LocalPlayer.Name, 9, Theme.TextDisabled, Enum.Font.Gotham)
    PlayerUser.Size = UDim2.new(1, -32, 0, 12)
    PlayerUser.Position = UDim2.new(0, 30, 0, 21)

    -- Tab content area
    local TabContent = MakeFrame(Content, UDim2.new(1, -130, 1, 0), UDim2.new(0, 130, 0, 0), Theme.Background)
    TabContent.ClipsDescendants = true

    -- Watermark
    local Watermark = MakeFrame(ScreenGui, UDim2.new(0, 220, 0, 26), UDim2.new(0, 12, 0, 12), Theme.Watermark)
    MakeCorner(Watermark, 6)
    MakeStroke(Watermark, Theme.Border, 1)
    MakePadding(Watermark, 4, 4, 8, 8)

    local WatermarkLeft = MakeFrame(Watermark, UDim2.new(0, 3, 0, 16), UDim2.new(0, 0, 0.5, -8), Theme.Accent)
    MakeCorner(WatermarkLeft, 2)

    local WatermarkText = MakeLabel(Watermark, "hollowoodz | 0 fps | 0ms", 11, Theme.TextDim, Enum.Font.GothamMedium)
    WatermarkText.Size = UDim2.new(1, -12, 1, 0)
    WatermarkText.Position = UDim2.new(0, 10, 0, 0)
    WatermarkText.TextYAlignment = Enum.TextYAlignment.Center

    -- FPS/Ping update
    local frameCount, frameTimer, fps = 0, tick(), 60
    local statsOk, stats = pcall(function() return game:GetService("Stats") end)
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - frameTimer >= 1 then
            fps = frameCount
            frameCount = 0
            frameTimer = tick()
        end
        local ping = 0
        pcall(function()
            if statsOk and stats then
                ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end
        end)
        WatermarkText.Text = "hollowoodz | "..math.floor(fps).." fps | "..ping.."ms"
    end)

    -- Open animation
    Main.Size = UDim2.new(0, 620, 0, 0)
    Main.Position = UDim2.new(0.5, -310, 0.5, 0)
    Tween(Main, {Size = UDim2.new(0, 620, 0, 420), Position = UDim2.new(0.5, -310, 0.5, -210)}, 0.4, Enum.EasingStyle.Quint)

    -- ==================
    -- ADD TAB
    -- ==================
    function Window:AddTab(name, icon)
        local Tab = {}
        local Groups = {}
        local isActive = false

        -- Tab button in sidebar
        local TabBtn = MakeButton(TabList, UDim2.new(1, 0, 0, 32), nil, Theme.TabInactive)
        MakeCorner(TabBtn, 6)

        local TabIndicator = MakeFrame(TabBtn, UDim2.new(0, 3, 0, 16), UDim2.new(0, 0, 0.5, -8), Theme.Accent)
        TabIndicator.BackgroundTransparency = 1
        MakeCorner(TabIndicator, 2)

        local TabIcon = MakeLabel(TabBtn, icon or "", 13, Theme.TextDim, Enum.Font.GothamMedium)
        TabIcon.Size = UDim2.new(0, 20, 1, 0)
        TabIcon.Position = UDim2.new(0, 8, 0, 0)
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center

        local TabLabel = MakeLabel(TabBtn, name, 12, Theme.TextDim, Enum.Font.GothamMedium)
        TabLabel.Size = UDim2.new(1, -36, 1, 0)
        TabLabel.Position = UDim2.new(0, 28, 0, 0)

        -- Tab page
        local TabPage = MakeFrame(TabContent, UDim2.new(1, 0, 1, 0), nil, Theme.Background)
        TabPage.Visible = false
        TabPage.ClipsDescendants = true

        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Size = UDim2.new(1, 0, 1, 0)
        TabScroll.BackgroundTransparency = 1
        TabScroll.BorderSizePixel = 0
        TabScroll.ScrollBarThickness = 3
        TabScroll.ScrollBarImageColor3 = Theme.ScrollBar
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabScroll.Parent = TabPage

        local TabScrollLayout = Instance.new("UIGridLayout")
        TabScrollLayout.CellSize = UDim2.new(0.5, -8, 0, 0)
        TabScrollLayout.CellPadding = UDim2.new(0, 8, 0, 8)
        TabScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabScrollLayout.Parent = TabScroll

        MakePadding(TabScroll, 8, 8, 8, 8)

        -- Activate tab
        local function Activate()
            if ActiveTab and ActiveTab ~= Tab then
                ActiveTab:_deactivate()
            end
            isActive = true
            ActiveTab = Tab
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.TabHover}, 0.15)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.15)
            Tween(TabIcon, {TextColor3 = Theme.Accent}, 0.15)
            Tween(TabIndicator, {BackgroundTransparency = 0}, 0.15)
        end

        function Tab:_deactivate()
            isActive = false
            TabPage.Visible = false
            Tween(TabBtn, {BackgroundColor3 = Theme.TabInactive}, 0.15)
            Tween(TabLabel, {TextColor3 = Theme.TextDim}, 0.15)
            Tween(TabIcon, {TextColor3 = Theme.TextDim}, 0.15)
            Tween(TabIndicator, {BackgroundTransparency = 1}, 0.15)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isActive then
                Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(22, 18, 18)}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not isActive then
                Tween(TabBtn, {BackgroundColor3 = Theme.TabInactive}, 0.15)
            end
        end)
        TabBtn.MouseButton1Click:Connect(Activate)

        if #Tabs == 0 then Activate() end
        table.insert(Tabs, Tab)

        -- ==================
        -- ADD GROUPBOX
        -- ==================
        function Tab:AddGroupbox(name, side)
            local Group = {}
            local Items = {}
            local collapsed = false

            local GroupFrame = MakeFrame(TabScroll, UDim2.new(1, 0, 0, 0), nil, Theme.GroupBG)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            MakeCorner(GroupFrame, 7)
            MakeStroke(GroupFrame, Theme.Border, 1)
            GroupFrame.ClipsDescendants = false

            -- Header
            local Header = MakeButton(GroupFrame, UDim2.new(1, 0, 0, 30), nil, Theme.GroupHeader)
            MakeCorner(Header, 7)
            local HeaderFix = MakeFrame(Header, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), Theme.GroupHeader)

            -- Accent line
            local AccentLine = MakeFrame(Header, UDim2.new(0, 3, 0, 14), UDim2.new(0, 8, 0.5, -7), Theme.Accent)
            MakeCorner(AccentLine, 2)

            local GroupTitle = MakeLabel(Header, name, 11, Theme.Text, Enum.Font.GothamBold)
            GroupTitle.Size = UDim2.new(1, -50, 1, 0)
            GroupTitle.Position = UDim2.new(0, 18, 0, 0)
            GroupTitle.TextYAlignment = Enum.TextYAlignment.Center

            -- Collapse arrow
            local Arrow = MakeLabel(Header, "▾", 14, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -24, 0, 0)
            Arrow.TextYAlignment = Enum.TextYAlignment.Center

            -- Items container
            local ItemContainer = MakeFrame(GroupFrame, UDim2.new(1, 0, 0, 0), UDim2.new(0, 0, 0, 30), Theme.GroupBG)
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            MakeCorner(ItemContainer, 7)
            MakePadding(ItemContainer, 4, 6, 6, 6)
            local ItemLayout = MakeList(ItemContainer, 3)

            Header.MouseButton1Click:Connect(function()
                collapsed = not collapsed
                if collapsed then
                    Tween(Arrow, {Rotation = -90}, 0.2)
                    ItemContainer.Visible = false
                else
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    ItemContainer.Visible = true
                end
            end)

            -- ==================
            -- ADD TOGGLE
            -- ==================
            function Group:AddToggle(id, config)
                local Toggle = {}
                local state = config.Default or false
                local callback = config.Callback or function() end

                local Row = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 28), nil, Theme.ItemBG)
                MakeCorner(Row, 5)
                MakePadding(Row, 0, 0, 8, 8)

                local RowBtn = MakeButton(Row, UDim2.new(1, 0, 1, 0), nil, Color3.fromRGB(0,0,0))
                RowBtn.BackgroundTransparency = 1

                local ToggleLabel = MakeLabel(Row, config.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                ToggleLabel.Size = UDim2.new(1, -46, 1, 0)
                ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center

                local ToggleBG = MakeFrame(Row, UDim2.new(0, 36, 0, 18), UDim2.new(1, -38, 0.5, -9), Theme.Toggle)
                MakeCorner(ToggleBG, 9)
                MakeStroke(ToggleBG, Theme.Border, 1)

                local ToggleCircle = MakeFrame(ToggleBG, UDim2.new(0, 14, 0, 14), UDim2.new(0, 2, 0.5, -7), Theme.TextDisabled)
                MakeCorner(ToggleCircle, 7)

                local function SetState(newState, skipCallback)
                    state = newState
                    if state then
                        Tween(ToggleBG, {BackgroundColor3 = Theme.ToggleOn}, 0.2)
                        Tween(ToggleCircle, {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Theme.Text}, 0.2)
                    else
                        Tween(ToggleBG, {BackgroundColor3 = Theme.Toggle}, 0.2)
                        Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.TextDisabled}, 0.2)
                    end
                    if not skipCallback then callback(state) end
                end

                SetState(state, true)

                RowBtn.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)

                RowBtn.MouseEnter:Connect(function()
                    Tween(Row, {BackgroundColor3 = Theme.GroupHeader}, 0.1)
                end)
                RowBtn.MouseLeave:Connect(function()
                    Tween(Row, {BackgroundColor3 = Theme.ItemBG}, 0.1)
                end)

                function Toggle:SetValue(val)
                    SetState(val, false)
                end

                function Toggle:GetValue()
                    return state
                end

                -- Color picker support
                function Toggle:AddColorPicker(pickerId, pickerConfig)
                    return Group:AddColorPicker(pickerId, pickerConfig)
                end

                if config.Flag then
                    HollowLib.Flags = HollowLib.Flags or {}
                    HollowLib.Flags[config.Flag] = Toggle
                end

                return Toggle
            end

            -- ==================
            -- ADD SLIDER
            -- ==================
            function Group:AddSlider(id, config)
                local Slider = {}
                local value = config.Default or config.Min or 0
                local min = config.Min or 0
                local max = config.Max or 100
                local rounding = config.Rounding or 0
                local suffix = config.Suffix or ""
                local callback = config.Callback or function() end
                local dragging = false

                local Container = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 42), nil, Theme.ItemBG)
                MakeCorner(Container, 5)
                MakePadding(Container, 6, 6, 8, 8)

                local TopRow = MakeFrame(Container, UDim2.new(1, 0, 0, 16), nil, Theme.ItemBG)

                local SliderLabel = MakeLabel(TopRow, config.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                SliderLabel.Size = UDim2.new(0.7, 0, 1, 0)

                local ValueLabel = MakeLabel(TopRow, tostring(value)..suffix, 11, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                ValueLabel.Size = UDim2.new(0.3, 0, 1, 0)
                ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)

                local SliderBG = MakeFrame(Container, UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 1, -10), Theme.SliderBG)
                MakeCorner(SliderBG, 3)
                MakeStroke(SliderBG, Theme.Border, 1)

                local alpha = (value - min) / (max - min)
                local SliderFill = MakeFrame(SliderBG, UDim2.new(alpha, 0, 1, 0), nil, Theme.SliderFill)
                MakeCorner(SliderFill, 3)

                local SliderKnob = MakeFrame(SliderBG, UDim2.new(0, 12, 0, 12), UDim2.new(alpha, -6, 0.5, -6), Theme.Text)
                MakeCorner(SliderKnob, 6)
                MakeStroke(SliderKnob, Theme.Accent, 1)

                local SliderBtn = MakeButton(SliderBG, UDim2.new(1, 0, 1, 0), nil, Color3.fromRGB(0,0,0))
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.ZIndex = 2

                local function UpdateSlider(input)
                    local relative = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * relative
                    if rounding == 0 then
                        value = math.floor(value)
                    else
                        value = math.floor(value * (10^rounding) + 0.5) / (10^rounding)
                    end
                    value = math.clamp(value, min, max)
                    local a = (value - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(a, 0, 1, 0)}, 0.05)
                    Tween(SliderKnob, {Position = UDim2.new(a, -6, 0.5, -6)}, 0.05)
                    ValueLabel.Text = tostring(value)..suffix
                    callback(value)
                end

                SliderBtn.MouseButton1Down:Connect(function()
                    dragging = true
                end)

                SliderBtn.TouchTap:Connect(function(touches)
                    if touches[1] then UpdateSlider(touches[1]) end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                Container.MouseEnter:Connect(function()
                    Tween(Container, {BackgroundColor3 = Theme.GroupHeader}, 0.1)
                end)
                Container.MouseLeave:Connect(function()
                    Tween(Container, {BackgroundColor3 = Theme.ItemBG}, 0.1)
                end)

                function Slider:SetValue(val)
                    value = math.clamp(val, min, max)
                    local a = (value - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(a, 0, 1, 0)}, 0.15)
                    Tween(SliderKnob, {Position = UDim2.new(a, -6, 0.5, -6)}, 0.15)
                    ValueLabel.Text = tostring(value)..suffix
                    callback(value)
                end

                function Slider:GetValue()
                    return value
                end

                if config.Flag then
                    HollowLib.Flags = HollowLib.Flags or {}
                    HollowLib.Flags[config.Flag] = Slider
                end

                return Slider
            end

            -- ==================
            -- ADD BUTTON
            -- ==================
            function Group:AddButton(config)
                local text = config.Text or "Button"
                local callback = config.Func or config.Callback or function() end

                local Btn = MakeButton(ItemContainer, UDim2.new(1, 0, 0, 28), nil, Theme.ItemBG)
                MakeCorner(Btn, 5)
                MakeStroke(Btn, Theme.Border, 1)

                local BtnLabel = MakeLabel(Btn, text, 12, Theme.Text, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                BtnLabel.Size = UDim2.new(1, 0, 1, 0)
                BtnLabel.TextYAlignment = Enum.TextYAlignment.Center

                local AccentLeft = MakeFrame(Btn, UDim2.new(0, 3, 0, 14), UDim2.new(0, 0, 0.5, -7), Theme.Accent)
                MakeCorner(AccentLeft, 2)
                AccentLeft.BackgroundTransparency = 1

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.GroupHeader}, 0.1)
                    Tween(AccentLeft, {BackgroundTransparency = 0}, 0.1)
                    Tween(BtnLabel, {TextColor3 = Theme.Accent}, 0.1)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.ItemBG}, 0.1)
                    Tween(AccentLeft, {BackgroundTransparency = 1}, 0.1)
                    Tween(BtnLabel, {TextColor3 = Theme.Text}, 0.1)
                end)
                Btn.MouseButton1Down:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.AccentDark}, 0.1)
                end)
                Btn.MouseButton1Up:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.GroupHeader}, 0.1)
                end)
                Btn.MouseButton1Click:Connect(callback)

                return Btn
            end

            -- ==================
            -- ADD DROPDOWN
            -- ==================
            function Group:AddDropdown(id, config)
                local Dropdown = {}
                local values = config.Values or {}
                local selected = config.Default or ""
                local multi = config.Multi or false
                local multiSelected = {}
                local open = false
                local callback = config.Callback or function() end

                if type(selected) == "number" and values[selected] then
                    selected = values[selected]
                end

                local Container = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 0), nil, Theme.ItemBG)
                Container.AutomaticSize = Enum.AutomaticSize.Y
                MakeCorner(Container, 5)
                MakePadding(Container, 4, 4, 8, 8)

                local Header = MakeButton(Container, UDim2.new(1, 0, 0, 26), nil, Theme.DropBG)
                MakeCorner(Header, 5)
                MakeStroke(Header, Theme.Border, 1)

                local DropLabel = MakeLabel(Header, config.Text or id, 11, Theme.TextDim, Enum.Font.Gotham)
                DropLabel.Size = UDim2.new(1, -30, 0, 12)
                DropLabel.Position = UDim2.new(0, 8, 0, 2)

                local SelectedLabel = MakeLabel(Header, tostring(selected), 11, Theme.Text, Enum.Font.GothamMedium)
                SelectedLabel.Size = UDim2.new(1, -30, 0, 12)
                SelectedLabel.Position = UDim2.new(0, 8, 0, 13)

                local DropArrow = MakeLabel(Header, "▾", 14, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                DropArrow.Size = UDim2.new(0, 20, 1, 0)
                DropArrow.Position = UDim2.new(1, -22, 0, 0)
                DropArrow.TextYAlignment = Enum.TextYAlignment.Center

                local OptionList = MakeFrame(Container, UDim2.new(1, 0, 0, 0), UDim2.new(0, 0, 0, 34), Theme.DropOpen)
                OptionList.AutomaticSize = Enum.AutomaticSize.Y
                OptionList.ClipsDescendants = true
                OptionList.Visible = false
                MakeCorner(OptionList, 5)
                MakeStroke(OptionList, Theme.Border, 1)
                MakePadding(OptionList, 4, 4, 4, 4)
                MakeList(OptionList, 2)

                local function BuildOptions()
                    for _, c in pairs(OptionList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, val in ipairs(values) do
                        local isSelected = (multi and multiSelected[val]) or (not multi and selected == val)
                        local Opt = MakeButton(OptionList, UDim2.new(1, 0, 0, 24), nil, isSelected and Theme.AccentDark or Theme.DropBG)
                        MakeCorner(Opt, 4)

                        local OptLabel = MakeLabel(Opt, tostring(val), 11, isSelected and Theme.Text or Theme.TextDim, Enum.Font.GothamMedium)
                        OptLabel.Size = UDim2.new(1, -8, 1, 0)
                        OptLabel.Position = UDim2.new(0, 8, 0, 0)
                        OptLabel.TextYAlignment = Enum.TextYAlignment.Center

                        if multi and isSelected then
                            local Check = MakeLabel(Opt, "✓", 11, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                            Check.Size = UDim2.new(0, 20, 1, 0)
                            Check.Position = UDim2.new(1, -22, 0, 0)
                            Check.TextYAlignment = Enum.TextYAlignment.Center
                        end

                        Opt.MouseEnter:Connect(function()
                            if not (not multi and selected == val) and not (multi and multiSelected[val]) then
                                Tween(Opt, {BackgroundColor3 = Theme.GroupHeader}, 0.1)
                            end
                        end)
                        Opt.MouseLeave:Connect(function()
                            if not (not multi and selected == val) and not (multi and multiSelected[val]) then
                                Tween(Opt, {BackgroundColor3 = Theme.DropBG}, 0.1)
                            end
                        end)

                        Opt.MouseButton1Click:Connect(function()
                            if multi then
                                multiSelected[val] = not multiSelected[val]
                                local result = {}
                                for k, v in pairs(multiSelected) do
                                    if v then table.insert(result, k) end
                                end
                                local display = #result > 0 and table.concat(result, ", ") or "None"
                                SelectedLabel.Text = display
                                callback(result)
                            else
                                selected = val
                                SelectedLabel.Text = tostring(val)
                                callback(val)
                                -- Close
                                open = false
                                OptionList.Visible = false
                                Tween(DropArrow, {Rotation = 0}, 0.2)
                            end
                            BuildOptions()
                        end)
                    end
                end

                Header.MouseButton1Click:Connect(function()
                    open = not open
                    OptionList.Visible = open
                    Tween(DropArrow, {Rotation = open and 180 or 0}, 0.2)
                    BuildOptions()
                end)

                BuildOptions()

                function Dropdown:SetValues(newValues)
                    values = newValues
                    BuildOptions()
                end

                function Dropdown:SetValue(val)
                    selected = val
                    SelectedLabel.Text = tostring(val)
                    callback(val)
                    BuildOptions()
                end

                function Dropdown:GetValue()
                    if multi then
                        local result = {}
                        for k, v in pairs(multiSelected) do
                            if v then table.insert(result, k) end
                        end
                        return result
                    end
                    return selected
                end

                if config.Flag then
                    HollowLib.Flags = HollowLib.Flags or {}
                    HollowLib.Flags[config.Flag] = Dropdown
                end

                return Dropdown
            end

            -- ==================
            -- ADD LABEL
            -- ==================
            function Group:AddLabel(text, richText)
                local Label = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 22), nil, Theme.ItemBG)
                MakeCorner(Label, 5)
                MakePadding(Label, 0, 0, 8, 8)

                local LabelText = MakeLabel(Label, text, 11, Theme.TextDim, Enum.Font.Gotham)
                LabelText.Size = UDim2.new(1, 0, 1, 0)
                LabelText.TextYAlignment = Enum.TextYAlignment.Center
                LabelText.RichText = richText or false
                LabelText.TextWrapped = true

                return LabelText
            end

            -- ==================
            -- ADD DIVIDER
            -- ==================
            function Group:AddDivider()
                local Div = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 8), nil, Theme.ItemBG)
                local Line = MakeFrame(Div, UDim2.new(1, -16, 0, 1), UDim2.new(0, 8, 0.5, 0), Theme.Border)
                MakeCorner(Line, 1)
                return Div
            end

            -- ==================
            -- ADD COLOR PICKER
            -- ==================
            function Group:AddColorPicker(id, config)
                local ColorPicker = {}
                local color = config.Default or Color3.fromRGB(255, 255, 255)
                local callback = config.Callback or function() end
                local pickerOpen = false

                local Container = MakeFrame(ItemContainer, UDim2.new(1, 0, 0, 28), nil, Theme.ItemBG)
                MakeCorner(Container, 5)
                MakePadding(Container, 0, 0, 8, 8)

                local PickerLabel = MakeLabel(Container, config.Title or id, 12, Theme.Text, Enum.Font.GothamMedium)
                PickerLabel.Size = UDim2.new(1, -46, 1, 0)
                PickerLabel.TextYAlignment = Enum.TextYAlignment.Center

                local ColorBtn = MakeButton(Container, UDim2.new(0, 36, 0, 18), UDim2.new(1, -38, 0.5, -9), color)
                MakeCorner(ColorBtn, 5)
                MakeStroke(ColorBtn, Theme.BorderBright, 1)

                -- Color picker popup
                local PickerPopup = MakeFrame(ScreenGui, UDim2.new(0, 200, 0, 220), UDim2.new(0, 0, 0, 0), Theme.GroupBG)
                PickerPopup.Visible = false
                PickerPopup.ZIndex = 100
                MakeCorner(PickerPopup, 8)
                MakeStroke(PickerPopup, Theme.BorderBright, 1)
                MakePadding(PickerPopup, 10, 10, 10, 10)
                MakeList(PickerPopup, 6)

                local PickerTitle = MakeLabel(PickerPopup, config.Title or "Color Picker", 12, Theme.Text, Enum.Font.GothamBold)
                PickerTitle.Size = UDim2.new(1, 0, 0, 16)

                -- Hue slider
                local HueLabel = MakeLabel(PickerPopup, "Hue", 10, Theme.TextDim, Enum.Font.Gotham)
                HueLabel.Size = UDim2.new(1, 0, 0, 12)

                local HueBG = MakeFrame(PickerPopup, UDim2.new(1, 0, 0, 14), nil, Theme.SliderBG)
                HueBG.ZIndex = 101
                MakeCorner(HueBG, 3)

                -- Rainbow hue gradient
                local HueGrad = Instance.new("UIGradient")
                HueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
                })
                HueGrad.Parent = HueBG

                local HueKnob = MakeFrame(HueBG, UDim2.new(0, 10, 1, 4), UDim2.new(0, -5, 0, -2), Theme.Text)
                MakeCorner(HueKnob, 3)
                MakeStroke(HueKnob, Theme.Border, 1)
                HueKnob.ZIndex = 102

                -- Sat/Val sliders
                local SatLabel = MakeLabel(PickerPopup, "Saturation", 10, Theme.TextDim, Enum.Font.Gotham)
                SatLabel.Size = UDim2.new(1, 0, 0, 12)

                local SatBG = MakeFrame(PickerPopup, UDim2.new(1, 0, 0, 14), nil, Theme.SliderBG)
                SatBG.ZIndex = 101
                MakeCorner(SatBG, 3)
                local SatFill = MakeFrame(SatBG, UDim2.new(1, 0, 1, 0), nil, Theme.Accent)
                MakeCorner(SatFill, 3)
                local SatKnob = MakeFrame(SatBG, UDim2.new(0, 10, 1, 4), UDim2.new(1, -5, 0, -2), Theme.Text)
                MakeCorner(SatKnob, 3)
                MakeStroke(SatKnob, Theme.Border, 1)
                SatKnob.ZIndex = 102

                local ValLabel = MakeLabel(PickerPopup, "Value", 10, Theme.TextDim, Enum.Font.Gotham)
                ValLabel.Size = UDim2.new(1, 0, 0, 12)

                local ValBG = MakeFrame(PickerPopup, UDim2.new(1, 0, 0, 14), nil, Theme.SliderBG)
                ValBG.ZIndex = 101
                MakeCorner(ValBG, 3)
                local ValFill = MakeFrame(ValBG, UDim2.new(1, 0, 1, 0), nil, Theme.Text)
                MakeCorner(ValFill, 3)
                local ValKnob = MakeFrame(ValBG, UDim2.new(0, 10, 1, 4), UDim2.new(1, -5, 0, -2), Theme.Text)
                MakeCorner(ValKnob, 3)
                MakeStroke(ValKnob, Theme.Border, 1)
                ValKnob.ZIndex = 102

                local hue, sat, val = Color3.toHSV(color)

                local function UpdateColor()
                    color = Color3.fromHSV(hue, sat, val)
                    ColorBtn.BackgroundColor3 = color
                    SatFill.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    HueKnob.Position = UDim2.new(hue, -5, 0, -2)
                    SatKnob.Position = UDim2.new(sat, -5, 0, -2)
                    ValKnob.Position = UDim2.new(val, -5, 0, -2)
                    callback(color)
                end

                local function MakeSliderDrag(bg, knob, onChange)
                    local drag = false
                    local btn = MakeButton(bg, UDim2.new(1, 0, 1, 0), nil, Color3.fromRGB(0,0,0))
                    btn.BackgroundTransparency = 1
                    btn.ZIndex = 103
                    btn.MouseButton1Down:Connect(function() drag = true end)
                    UserInputService.InputChanged:Connect(function(input)
                        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                            onChange(rel)
                            UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            drag = false
                        end
                    end)
                end

                MakeSliderDrag(HueBG, HueKnob, function(v) hue = v end)
                MakeSliderDrag(SatBG, SatKnob, function(v) sat = v end)
                MakeSliderDrag(ValBG, ValKnob, function(v) val = v end)

                ColorBtn.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    PickerPopup.Visible = pickerOpen
                    if pickerOpen then
                        local absPos = ColorBtn.AbsolutePosition
                        PickerPopup.Position = UDim2.new(0, absPos.X - 210, 0, absPos.Y - 10)
                    end
                end)

                UpdateColor()

                function ColorPicker:SetValue(c)
                    color = c
                    hue, sat, val = Color3.toHSV(c)
                    UpdateColor()
                end

                function ColorPicker:GetValue()
                    return color
                end

                if config.Flag then
                    HollowLib.Flags = HollowLib.Flags or {}
                    HollowLib.Flags[config.Flag] = ColorPicker
                end

                return ColorPicker
            end

            -- Shortcuts for left/right groupboxes
            function Tab:AddLeftGroupbox(name)
                return self:AddGroupbox(name, "left")
            end

            function Tab:AddRightGroupbox(name)
                return self:AddGroupbox(name, "right")
            end

            table.insert(Groups, Group)
            return Group
        end

        -- Shortcuts
        function Tab:AddLeftGroupbox(name)
            return self:AddGroupbox(name, "left")
        end

        function Tab:AddRightGroupbox(name)
            return self:AddGroupbox(name, "right")
        end

        return Tab
    end

    -- Notify
    function Window:Notify(text, duration)
        duration = duration or 3
        if type(text) == "table" then
            text = (text.Title or "") .. ": " .. (text.Description or "")
        end

        local NotifFrame = MakeFrame(ScreenGui, UDim2.new(0, 220, 0, 40), UDim2.new(1, -230, 1, -60), Theme.GroupBG)
        MakeCorner(NotifFrame, 7)
        MakeStroke(NotifFrame, Theme.Border, 1)

        local NotifBar = MakeFrame(NotifFrame, UDim2.new(0, 3, 1, -8), UDim2.new(0, 0, 0, 4), Theme.Accent)
        MakeCorner(NotifBar, 2)

        local NotifText = MakeLabel(NotifFrame, text, 11, Theme.Text, Enum.Font.GothamMedium)
        NotifText.Size = UDim2.new(1, -14, 1, 0)
        NotifText.Position = UDim2.new(0, 10, 0, 0)
        NotifText.TextYAlignment = Enum.TextYAlignment.Center
        NotifText.TextWrapped = true

        -- Slide in
        NotifFrame.Position = UDim2.new(1, 10, 1, -60)
        Tween(NotifFrame, {Position = UDim2.new(1, -230, 1, -60)}, 0.3)

        task.delay(duration, function()
            Tween(NotifFrame, {Position = UDim2.new(1, 10, 1, -60)}, 0.3)
            task.wait(0.35)
            NotifFrame:Destroy()
        end)
    end

    function Window:SetWatermark(text)
        WatermarkText.Text = text
    end

    function Window:SetWatermarkVisibility(visible)
        Watermark.Visible = visible
    end

    function Window:Unload()
        ScreenGui:Destroy()
    end

    function Window:OnUnload(callback)
        -- Store callback for when unload is called
        getgenv()._HollowUnload = callback
    end

    return Window
end

return HollowLib
