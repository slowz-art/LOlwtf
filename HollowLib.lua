-- HollowLib | Made by hollowoodz
-- Red & Dark Theme | Left Sidebar | Two Column Layout | Mobile Support

local HollowLib = {}
HollowLib.__index = HollowLib
HollowLib.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local Theme = {
    Background  = Color3.fromRGB(10, 10, 12),
    Sidebar     = Color3.fromRGB(14, 14, 17),
    GroupBG     = Color3.fromRGB(18, 18, 22),
    GroupHeader = Color3.fromRGB(22, 22, 27),
    ItemBG      = Color3.fromRGB(24, 24, 30),
    Accent      = Color3.fromRGB(220, 30, 30),
    AccentDark  = Color3.fromRGB(160, 20, 20),
    Text        = Color3.fromRGB(240, 240, 240),
    TextDim     = Color3.fromRGB(160, 160, 170),
    TextDisabled= Color3.fromRGB(90, 90, 100),
    Border      = Color3.fromRGB(35, 35, 42),
    BorderBright= Color3.fromRGB(55, 55, 65),
    Toggle      = Color3.fromRGB(30, 30, 38),
    ToggleOn    = Color3.fromRGB(220, 30, 30),
    SliderBG    = Color3.fromRGB(25, 25, 32),
    SliderFill  = Color3.fromRGB(220, 30, 30),
    DropBG      = Color3.fromRGB(20, 20, 26),
    DropOpen    = Color3.fromRGB(16, 16, 20),
    ScrollBar   = Color3.fromRGB(60, 60, 75),
    TabActive   = Color3.fromRGB(220, 30, 30),
    TabInactive = Color3.fromRGB(14, 14, 17),
    TabHover    = Color3.fromRGB(30, 20, 22),
    Watermark   = Color3.fromRGB(14, 14, 17),
}

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function MakeCorner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 6) c.Parent = p return c end
local function MakeStroke(p, c, t) local s = Instance.new("UIStroke") s.Color = c or Theme.Border s.Thickness = t or 1 s.Parent = p return s end
local function MakePadding(p, t, b, l, r) local u = Instance.new("UIPadding") u.PaddingTop = UDim.new(0, t or 6) u.PaddingBottom = UDim.new(0, b or 6) u.PaddingLeft = UDim.new(0, l or 8) u.PaddingRight = UDim.new(0, r or 8) u.Parent = p end
local function MakeList(p, pad, fill) local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, pad or 4) l.FillDirection = fill or Enum.FillDirection.Vertical l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p return l end

local function MakeLabel(p, txt, sz, c, f, xa)
    local l = Instance.new("TextLabel")
    l.Text = txt or "" l.TextSize = sz or 13 l.TextColor3 = c or Theme.Text
    l.Font = f or Enum.Font.GothamMedium l.BackgroundTransparency = 1
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Size = UDim2.new(1, 0, 0, (sz or 13) + 4) l.Parent = p return l
end

local function MakeFrame(p, s, pos, c, tr)
    local f = Instance.new("Frame")
    f.Size = s or UDim2.new(1,0,0,30) f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = c or Theme.Background f.BackgroundTransparency = tr or 0
    f.BorderSizePixel = 0 f.Parent = p return f
end

local function MakeButton(p, s, pos, c)
    local b = Instance.new("TextButton")
    b.Size = s or UDim2.new(1,0,0,30) b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundColor3 = c or Theme.ItemBG b.BorderSizePixel = 0
    b.Text = "" b.AutoButtonColor = false b.Parent = p return b
end

local function MakeImage(p, id, s, pos)
    local i = Instance.new("ImageLabel") i.Image = id or ""
    i.Size = s or UDim2.new(0,16,0,16) i.Position = pos or UDim2.new(0,0,0,0)
    i.BackgroundTransparency = 1 i.Parent = p return i
end

-- Dragging with lock
local function MakeDraggable(bar, win, getLocked)
    local drag, di, ds, sp = false
    bar.InputBegan:Connect(function(i)
        if getLocked and getLocked() then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true ds = i.Position sp = win.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    bar.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and drag then
            local d = i.Position - ds
            win.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HollowLib" ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

function HollowLib:CreateWindow(config)
    local Window = {}
    local Tabs = {}
    local ActiveTab = nil
    local uiVisible = true
    local uiLocked = false
    local hideKey = config.HideKey or Enum.KeyCode.RightControl
    local curW, curH = 620, 420
    local minW, minH = 400, 300

    -- Main Frame
    local Main = MakeFrame(ScreenGui, UDim2.new(0,curW,0,curH), UDim2.new(0.5,-curW/2,0.5,-curH/2), Theme.Background)
    Main.Name = "HollowWindow" Main.ClipsDescendants = false
    MakeCorner(Main, 8) MakeStroke(Main, Theme.Border, 1)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://6014261993" Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.5 Shadow.Size = UDim2.new(1,40,1,40)
    Shadow.Position = UDim2.new(0,-20,0,-20) Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = -1 Shadow.Parent = Main

    -- Topbar
    local Topbar = MakeFrame(Main, UDim2.new(1,0,0,36), nil, Theme.Sidebar)
    MakeCorner(Topbar, 8)
    MakeFrame(Topbar, UDim2.new(1,0,0.5,0), UDim2.new(0,0,0.5,0), Theme.Sidebar)

    -- Logo
    local LogoContainer = MakeFrame(Topbar, UDim2.new(0,28,0,28), UDim2.new(0,8,0.5,-14), Color3.fromRGB(20,20,24))
    MakeCorner(LogoContainer, 6)
    local LogoStroke = Instance.new("UIStroke") LogoStroke.Color = Theme.Accent LogoStroke.Thickness = 1 LogoStroke.Parent = LogoContainer
    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Image = "rbxassetid://109250647122928"
    LogoImg.Size = UDim2.new(1,0,1,0)
    LogoImg.Position = UDim2.new(0,0,0,0)
    LogoImg.BackgroundTransparency = 1
    LogoImg.ScaleType = Enum.ScaleType.Fit
    LogoImg.ImageColor3 = Color3.fromRGB(255,255,255)
    LogoImg.Parent = LogoContainer

    -- Title
    local TitleLabel = MakeLabel(Topbar, config.Title or "HollowLib", 13, Theme.Text, Enum.Font.GothamBold)
    TitleLabel.Size = UDim2.new(1, isMobile and -140 or -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 46, 0, 0) TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Topbar buttons helper
    local topBtnOffset = -32
    local function makeTopBtn(sym, color)
        local b = MakeButton(Topbar, UDim2.new(0,28,0,28), UDim2.new(1,topBtnOffset,0.5,-14), Theme.Sidebar)
        MakeCorner(b, 6)
        local l = MakeLabel(b, sym, 14, color or Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        l.Size = UDim2.new(1,0,1,0) l.TextYAlignment = Enum.TextYAlignment.Center
        b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3=Theme.GroupBG}, 0.15) end)
        b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3=Theme.Sidebar}, 0.15) end)
        topBtnOffset = topBtnOffset - 34
        return b, l
    end

    -- Close
    local CloseBtn, CloseL = makeTopBtn("×")
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,{BackgroundColor3=Theme.AccentDark},0.15) Tween(CloseL,{TextColor3=Theme.Text},0.15) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,{BackgroundColor3=Theme.Sidebar},0.15) Tween(CloseL,{TextColor3=Theme.TextDim},0.15) end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main,{Size=UDim2.new(0,curW,0,0),Position=UDim2.new(0.5,-curW/2,0.5,0)},0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        task.wait(0.35) ScreenGui:Destroy()
    end)

    -- Minimize
    local MinBtn, MinL = makeTopBtn("−")
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(Main, {Size=UDim2.new(0,curW,0,minimized and 36 or curH)}, 0.3)
    end)

    -- Mobile only buttons
    if isMobile then
        -- Toggle UI visibility
        local TogBtn, TogL = makeTopBtn("👁")
        TogBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            local Content = Main:FindFirstChild("HollowContent")
            if Content then Content.Visible = uiVisible end
            Tween(Main, {Size=UDim2.new(0,curW,0,uiVisible and curH or 36)}, 0.25)
            Tween(TogBtn, {BackgroundColor3 = uiVisible and Theme.Sidebar or Theme.AccentDark}, 0.15)
            Tween(TogL, {TextColor3 = uiVisible and Theme.TextDim or Theme.Text}, 0.15)
        end)

        -- Lock UI
        local LockBtn, LockL = makeTopBtn("🔓")
        LockBtn.MouseButton1Click:Connect(function()
            uiLocked = not uiLocked
            LockL.Text = uiLocked and "🔒" or "🔓"
            Tween(LockBtn, {BackgroundColor3 = uiLocked and Theme.AccentDark or Theme.Sidebar}, 0.15)
            Tween(LockL, {TextColor3 = uiLocked and Theme.Text or Theme.TextDim}, 0.15)
            Window:Notify(uiLocked and "UI Locked" or "UI Unlocked", 2)
        end)
    end

    MakeDraggable(Topbar, Main, function() return uiLocked end)

    -- Hide/show keybind (desktop)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == hideKey then
            uiVisible = not uiVisible
            Main.Visible = uiVisible
            Watermark.Visible = uiVisible
        end
    end)

    -- Content
    local Content = MakeFrame(Main, UDim2.new(1,0,1,-36), UDim2.new(0,0,0,36), Theme.Background)
    Content.Name = "HollowContent"

    -- Sidebar
    local Sidebar = MakeFrame(Content, UDim2.new(0,130,1,0), nil, Theme.Sidebar)
    MakeStroke(Sidebar, Theme.Border, 1)

    local SideTitle = MakeLabel(Sidebar, "NAVIGATION", 9, Theme.TextDisabled, Enum.Font.GothamBold)
    SideTitle.Size = UDim2.new(1,-16,0,20) SideTitle.Position = UDim2.new(0,8,0,8)

    local TabList = MakeFrame(Sidebar, UDim2.new(1,0,1,-44), UDim2.new(0,0,0,30), Theme.Sidebar)
    TabList.ClipsDescendants = true
    MakeList(TabList, 2) MakePadding(TabList, 4, 4, 6, 6)

    -- Player info
    local PlayerInfo = MakeFrame(Sidebar, UDim2.new(1,0,0,40), UDim2.new(0,0,1,-40), Theme.Sidebar)
    MakeStroke(PlayerInfo, Theme.Border, 1) MakePadding(PlayerInfo, 6, 6, 8, 8)
    local PlayerAvatar = MakeImage(PlayerInfo, "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=48&height=48&format=png", UDim2.new(0,24,0,24), UDim2.new(0,0,0.5,-12))
    MakeCorner(PlayerAvatar, 12)
    local PlayerName = MakeLabel(PlayerInfo, LocalPlayer.DisplayName, 11, Theme.Text, Enum.Font.GothamMedium)
    PlayerName.Size = UDim2.new(1,-32,0,14) PlayerName.Position = UDim2.new(0,30,0,6)
    local PlayerUser = MakeLabel(PlayerInfo, "@"..LocalPlayer.Name, 9, Theme.TextDisabled, Enum.Font.Gotham)
    PlayerUser.Size = UDim2.new(1,-32,0,12) PlayerUser.Position = UDim2.new(0,30,0,21)

    -- Tab content area
    local TabContent = MakeFrame(Content, UDim2.new(1,-130,1,0), UDim2.new(0,130,0,0), Theme.Background)
    TabContent.ClipsDescendants = true

    -- ===== RESIZE HANDLE =====
    -- Looks like a grid of dots in corner
    local ResizeHandle = MakeButton(Main, UDim2.new(0,18,0,18), UDim2.new(1,-18,1,-18), Theme.Background)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.ZIndex = 10

    -- Draw 3x3 dot grid for resize icon
    local dotPositions = {
        {10,2},{14,2},{18,2},
        {10,6},{14,6},{18,6},
        {10,10},{14,10},{18,10},
    }
    for i, pos in ipairs(dotPositions) do
        -- skip top-left dots to make it look like a corner grip
        if i > 3 or pos[1] > 10 then
            local dot = MakeFrame(ResizeHandle, UDim2.new(0,2,0,2), UDim2.new(1,-pos[1],1,-pos[2]), Theme.TextDisabled)
            MakeCorner(dot, 1) dot.ZIndex = 11
        end
    end

    local resizing = false
    local resizeStart, startW, startH

    ResizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true resizeStart = i.Position
            startW = Main.AbsoluteSize.X startH = Main.AbsoluteSize.Y
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - resizeStart
            curW = math.max(minW, startW + d.X)
            curH = math.max(minH, startH + d.Y)
            Main.Size = UDim2.new(0, curW, 0, minimized and 36 or curH)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    -- ===== WATERMARK =====
    -- Style: "hollowoodz | TB3 | 60 fps | 65 ms" with toggle/lock buttons for mobile
    local Watermark = MakeFrame(ScreenGui, UDim2.new(0, isMobile and 160 or 220, 0, 24), UDim2.new(0,12,0,12), Theme.Watermark)
    MakeCorner(Watermark, 5) MakeStroke(Watermark, Theme.Border, 1)

    local WMBar = MakeFrame(Watermark, UDim2.new(0,3,0,14), UDim2.new(0,0,0.5,-7), Theme.Accent)
    MakeCorner(WMBar, 2)

    local WatermarkText = MakeLabel(Watermark, "hollowoodz | 0fps | 0ms", 11, Theme.TextDim, Enum.Font.GothamMedium)
    WatermarkText.Size = UDim2.new(1,-12,1,0) WatermarkText.Position = UDim2.new(0,10,0,0)
    WatermarkText.TextYAlignment = Enum.TextYAlignment.Center

    local frameCount, frameTimer, fps = 0, tick(), 60
    local statsOk, stats = pcall(function() return game:GetService("Stats") end)
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - frameTimer >= 1 then fps = frameCount frameCount = 0 frameTimer = tick() end
        local ping = 0
        pcall(function()
            if statsOk and stats then ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end
        end)
        WatermarkText.Text = "hollowoodz | "..math.floor(fps).."fps | "..ping.."ms"
    end)

    -- Open animation
    Main.Size = UDim2.new(0,curW,0,0) Main.Position = UDim2.new(0.5,-curW/2,0.5,0)
    Tween(Main, {Size=UDim2.new(0,curW,0,curH),Position=UDim2.new(0.5,-curW/2,0.5,-curH/2)}, 0.4, Enum.EasingStyle.Quint)

    -- ==================
    -- ADD TAB
    -- ==================
    function Window:AddTab(name, icon)
        local Tab = {}
        local isActive = false

        local TabBtn = MakeButton(TabList, UDim2.new(1,0,0,32), nil, Theme.TabInactive)
        MakeCorner(TabBtn, 6)

        local TabIndicator = MakeFrame(TabBtn, UDim2.new(0,3,0,16), UDim2.new(0,0,0.5,-8), Theme.Accent)
        TabIndicator.BackgroundTransparency = 1 MakeCorner(TabIndicator, 2)

        local TabIcon = MakeLabel(TabBtn, icon or "", 13, Theme.TextDim, Enum.Font.GothamMedium)
        TabIcon.Size = UDim2.new(0,20,1,0) TabIcon.Position = UDim2.new(0,8,0,0)
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center

        local TabLabel = MakeLabel(TabBtn, name, 12, Theme.TextDim, Enum.Font.GothamMedium)
        TabLabel.Size = UDim2.new(1,-36,1,0) TabLabel.Position = UDim2.new(0,28,0,0)

        -- Tab page with TWO COLUMN layout (fixed - no UIGridLayout)
        local TabPage = MakeFrame(TabContent, UDim2.new(1,0,1,0), nil, Theme.Background)
        TabPage.Visible = false TabPage.ClipsDescendants = true

        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Size = UDim2.new(1,0,1,0)
        TabScroll.BackgroundTransparency = 1 TabScroll.BorderSizePixel = 0
        TabScroll.ScrollBarThickness = 3 TabScroll.ScrollBarImageColor3 = Theme.ScrollBar
        TabScroll.CanvasSize = UDim2.new(0,0,0,0) TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabScroll.Parent = TabPage
        MakePadding(TabScroll, 8, 8, 8, 8)

        -- Two column container
        local ColHolder = MakeFrame(TabScroll, UDim2.new(1,0,0,0), nil, Theme.Background, 1)
        ColHolder.AutomaticSize = Enum.AutomaticSize.Y

        local ColLayout = Instance.new("UIListLayout")
        ColLayout.FillDirection = Enum.FillDirection.Horizontal
        ColLayout.Padding = UDim.new(0, 6)
        ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        ColLayout.Parent = ColHolder

        local LeftCol = MakeFrame(ColHolder, UDim2.new(0.5,-3,0,0), nil, Theme.Background, 1)
        LeftCol.AutomaticSize = Enum.AutomaticSize.Y
        MakeList(LeftCol, 6)

        local RightCol = MakeFrame(ColHolder, UDim2.new(0.5,-3,0,0), nil, Theme.Background, 1)
        RightCol.AutomaticSize = Enum.AutomaticSize.Y
        MakeList(RightCol, 6)

        local function Activate()
            if ActiveTab and ActiveTab ~= Tab then ActiveTab:_deactivate() end
            isActive = true ActiveTab = Tab TabPage.Visible = true
            Tween(TabBtn, {BackgroundColor3=Theme.TabHover}, 0.15)
            Tween(TabLabel, {TextColor3=Theme.Text}, 0.15)
            Tween(TabIcon, {TextColor3=Theme.Accent}, 0.15)
            Tween(TabIndicator, {BackgroundTransparency=0}, 0.15)
        end

        function Tab:_deactivate()
            isActive = false TabPage.Visible = false
            Tween(TabBtn, {BackgroundColor3=Theme.TabInactive}, 0.15)
            Tween(TabLabel, {TextColor3=Theme.TextDim}, 0.15)
            Tween(TabIcon, {TextColor3=Theme.TextDim}, 0.15)
            Tween(TabIndicator, {BackgroundTransparency=1}, 0.15)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isActive then Tween(TabBtn, {BackgroundColor3=Color3.fromRGB(22,18,18)}, 0.15) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not isActive then Tween(TabBtn, {BackgroundColor3=Theme.TabInactive}, 0.15) end
        end)
        TabBtn.MouseButton1Click:Connect(Activate)
        if #Tabs == 0 then Activate() end
        table.insert(Tabs, Tab)

        -- ==================
        -- ADD GROUPBOX
        -- ==================
        local function AddGroupInternal(name, col)
            local Group = {}
            local collapsed = false

            local GroupFrame = MakeFrame(col, UDim2.new(1,0,0,0), nil, Theme.GroupBG)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            MakeCorner(GroupFrame, 7) MakeStroke(GroupFrame, Theme.Border, 1)
            GroupFrame.ClipsDescendants = false

            local Header = MakeButton(GroupFrame, UDim2.new(1,0,0,30), nil, Theme.GroupHeader)
            MakeCorner(Header, 7)
            MakeFrame(Header, UDim2.new(1,0,0.5,0), UDim2.new(0,0,0.5,0), Theme.GroupHeader)

            local AccentLine = MakeFrame(Header, UDim2.new(0,3,0,14), UDim2.new(0,8,0.5,-7), Theme.Accent)
            MakeCorner(AccentLine, 2)

            local GroupTitle = MakeLabel(Header, name, 11, Theme.Text, Enum.Font.GothamBold)
            GroupTitle.Size = UDim2.new(1,-50,1,0) GroupTitle.Position = UDim2.new(0,18,0,0)
            GroupTitle.TextYAlignment = Enum.TextYAlignment.Center

            local Arrow = MakeLabel(Header, "▾", 14, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            Arrow.Size = UDim2.new(0,20,1,0) Arrow.Position = UDim2.new(1,-24,0,0)
            Arrow.TextYAlignment = Enum.TextYAlignment.Center

            local ItemContainer = MakeFrame(GroupFrame, UDim2.new(1,0,0,0), UDim2.new(0,0,0,30), Theme.GroupBG)
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            MakeCorner(ItemContainer, 7) MakePadding(ItemContainer, 4, 6, 6, 6)
            MakeList(ItemContainer, 3)

            Header.MouseButton1Click:Connect(function()
                collapsed = not collapsed
                Tween(Arrow, {Rotation=collapsed and -90 or 0}, 0.2)
                ItemContainer.Visible = not collapsed
            end)

            -- ADD TOGGLE
            function Group:AddToggle(id, cfg)
                local Toggle = {}
                local state = cfg.Default or false
                local callback = cfg.Callback or function() end

                local Row = MakeFrame(ItemContainer, UDim2.new(1,0,0,28), nil, Theme.ItemBG)
                MakeCorner(Row, 5) MakePadding(Row, 0, 0, 8, 8)

                local RowBtn = MakeButton(Row, UDim2.new(1,0,1,0), nil, Theme.ItemBG)
                RowBtn.BackgroundTransparency = 1

                local ToggleLabel = MakeLabel(Row, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                ToggleLabel.Size = UDim2.new(1,-46,1,0) ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center

                local ToggleBG = MakeFrame(Row, UDim2.new(0,36,0,18), UDim2.new(1,-38,0.5,-9), Theme.Toggle)
                MakeCorner(ToggleBG, 9) MakeStroke(ToggleBG, Theme.Border, 1)

                local ToggleCircle = MakeFrame(ToggleBG, UDim2.new(0,14,0,14), UDim2.new(0,2,0.5,-7), Theme.TextDisabled)
                MakeCorner(ToggleCircle, 7)

                local function SetState(newState, skipCb)
                    state = newState
                    if state then
                        Tween(ToggleBG, {BackgroundColor3=Theme.ToggleOn}, 0.2)
                        Tween(ToggleCircle, {Position=UDim2.new(1,-16,0.5,-7),BackgroundColor3=Theme.Text}, 0.2)
                    else
                        Tween(ToggleBG, {BackgroundColor3=Theme.Toggle}, 0.2)
                        Tween(ToggleCircle, {Position=UDim2.new(0,2,0.5,-7),BackgroundColor3=Theme.TextDisabled}, 0.2)
                    end
                    if not skipCb then callback(state) end
                end

                SetState(state, true)
                RowBtn.MouseButton1Click:Connect(function() SetState(not state) end)
                RowBtn.MouseEnter:Connect(function() Tween(Row, {BackgroundColor3=Theme.GroupHeader}, 0.1) end)
                RowBtn.MouseLeave:Connect(function() Tween(Row, {BackgroundColor3=Theme.ItemBG}, 0.1) end)

                function Toggle:SetValue(v) SetState(v, false) end
                function Toggle:GetValue() return state end
                function Toggle:AddColorPicker(pid, pcfg) return Group:AddColorPicker(pid, pcfg) end

                if cfg.Flag then HollowLib.Flags[cfg.Flag] = Toggle end
                return Toggle
            end

            -- ADD SLIDER
            function Group:AddSlider(id, cfg)
                local Slider = {}
                local min = cfg.Min or 0 local max = cfg.Max or 100
                local value = math.clamp(cfg.Default or min, min, max)
                local rounding = cfg.Rounding or 0 local suffix = cfg.Suffix or ""
                local callback = cfg.Callback or function() end
                local dragging = false

                local Container = MakeFrame(ItemContainer, UDim2.new(1,0,0,42), nil, Theme.ItemBG)
                MakeCorner(Container, 5) MakePadding(Container, 6, 6, 8, 8)

                local TopRow = MakeFrame(Container, UDim2.new(1,0,0,16), nil, Theme.ItemBG)

                local SliderLabel = MakeLabel(TopRow, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                SliderLabel.Size = UDim2.new(0.7,0,1,0)

                local ValueLabel = MakeLabel(TopRow, tostring(value)..suffix, 11, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                ValueLabel.Size = UDim2.new(0.3,0,1,0) ValueLabel.Position = UDim2.new(0.7,0,0,0)

                local SliderBG = MakeFrame(Container, UDim2.new(1,0,0,6), UDim2.new(0,0,1,-10), Theme.SliderBG)
                MakeCorner(SliderBG, 3) MakeStroke(SliderBG, Theme.Border, 1)

                local alpha = (value-min)/(max-min)
                local SliderFill = MakeFrame(SliderBG, UDim2.new(alpha,0,1,0), nil, Theme.SliderFill)
                MakeCorner(SliderFill, 3)

                local SliderKnob = MakeFrame(SliderBG, UDim2.new(0,12,0,12), UDim2.new(alpha,-6,0.5,-6), Theme.Text)
                MakeCorner(SliderKnob, 6) MakeStroke(SliderKnob, Theme.Accent, 1)

                local SliderBtn = MakeButton(SliderBG, UDim2.new(1,0,1,0), nil, Theme.Background)
                SliderBtn.BackgroundTransparency = 1 SliderBtn.ZIndex = 2

                local function UpdateSlider(input)
                    local rel = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    value = min + (max-min) * rel
                    value = rounding == 0 and math.floor(value) or math.floor(value*(10^rounding)+0.5)/(10^rounding)
                    value = math.clamp(value, min, max)
                    local a = (value-min)/(max-min)
                    Tween(SliderFill, {Size=UDim2.new(a,0,1,0)}, 0.05)
                    Tween(SliderKnob, {Position=UDim2.new(a,-6,0.5,-6)}, 0.05)
                    ValueLabel.Text = tostring(value)..suffix
                    callback(value)
                end

                SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
                SliderBtn.TouchTap:Connect(function(touches) if touches[1] then UpdateSlider(touches[1]) end end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then UpdateSlider(i) end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
                end)

                Container.MouseEnter:Connect(function() Tween(Container, {BackgroundColor3=Theme.GroupHeader}, 0.1) end)
                Container.MouseLeave:Connect(function() Tween(Container, {BackgroundColor3=Theme.ItemBG}, 0.1) end)

                function Slider:SetValue(v)
                    value = math.clamp(v,min,max) local a=(value-min)/(max-min)
                    Tween(SliderFill,{Size=UDim2.new(a,0,1,0)},0.15)
                    Tween(SliderKnob,{Position=UDim2.new(a,-6,0.5,-6)},0.15)
                    ValueLabel.Text=tostring(value)..suffix callback(value)
                end
                function Slider:GetValue() return value end

                if cfg.Flag then HollowLib.Flags[cfg.Flag] = Slider end
                return Slider
            end

            -- ADD BUTTON
            function Group:AddButton(cfg)
                local text = cfg.Text or "Button"
                local callback = cfg.Func or cfg.Callback or function() end

                local Btn = MakeButton(ItemContainer, UDim2.new(1,0,0,28), nil, Theme.ItemBG)
                MakeCorner(Btn, 5) MakeStroke(Btn, Theme.Border, 1)

                local BtnLabel = MakeLabel(Btn, text, 12, Theme.Text, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                BtnLabel.Size = UDim2.new(1,0,1,0) BtnLabel.TextYAlignment = Enum.TextYAlignment.Center

                local AccentLeft = MakeFrame(Btn, UDim2.new(0,3,0,14), UDim2.new(0,0,0.5,-7), Theme.Accent)
                MakeCorner(AccentLeft, 2) AccentLeft.BackgroundTransparency = 1

                Btn.MouseEnter:Connect(function()
                    Tween(Btn,{BackgroundColor3=Theme.GroupHeader},0.1)
                    Tween(AccentLeft,{BackgroundTransparency=0},0.1)
                    Tween(BtnLabel,{TextColor3=Theme.Accent},0.1)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn,{BackgroundColor3=Theme.ItemBG},0.1)
                    Tween(AccentLeft,{BackgroundTransparency=1},0.1)
                    Tween(BtnLabel,{TextColor3=Theme.Text},0.1)
                end)
                Btn.MouseButton1Down:Connect(function() Tween(Btn,{BackgroundColor3=Theme.AccentDark},0.1) end)
                Btn.MouseButton1Up:Connect(function() Tween(Btn,{BackgroundColor3=Theme.GroupHeader},0.1) end)
                Btn.MouseButton1Click:Connect(callback)

                return Btn
            end

            -- ADD DROPDOWN
            function Group:AddDropdown(id, cfg)
                local Dropdown = {}
                local values = cfg.Values or {}
                local selected = cfg.Default or ""
                local multi = cfg.Multi or false
                local multiSelected = {}
                local open = false
                local callback = cfg.Callback or function() end

                if type(selected) == "number" and values[selected] then selected = values[selected] end

                local Container = MakeFrame(ItemContainer, UDim2.new(1,0,0,0), nil, Theme.ItemBG)
                Container.AutomaticSize = Enum.AutomaticSize.Y
                MakeCorner(Container, 5) MakePadding(Container, 4, 4, 8, 8)

                local Header = MakeButton(Container, UDim2.new(1,0,0,26), nil, Theme.DropBG)
                MakeCorner(Header, 5) MakeStroke(Header, Theme.Border, 1)

                local DropLabel = MakeLabel(Header, cfg.Text or id, 11, Theme.TextDim, Enum.Font.Gotham)
                DropLabel.Size = UDim2.new(1,-30,0,12) DropLabel.Position = UDim2.new(0,8,0,2)

                local SelectedLabel = MakeLabel(Header, tostring(selected), 11, Theme.Text, Enum.Font.GothamMedium)
                SelectedLabel.Size = UDim2.new(1,-30,0,12) SelectedLabel.Position = UDim2.new(0,8,0,13)

                local DropArrow = MakeLabel(Header, "▾", 14, Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                DropArrow.Size = UDim2.new(0,20,1,0) DropArrow.Position = UDim2.new(1,-22,0,0)
                DropArrow.TextYAlignment = Enum.TextYAlignment.Center

                local OptionList = MakeFrame(Container, UDim2.new(1,0,0,0), UDim2.new(0,0,0,34), Theme.DropOpen)
                OptionList.AutomaticSize = Enum.AutomaticSize.Y OptionList.ClipsDescendants = true
                OptionList.Visible = false OptionList.ZIndex = 10
                MakeCorner(OptionList, 5) MakeStroke(OptionList, Theme.Border, 1)
                MakePadding(OptionList, 4, 4, 4, 4) MakeList(OptionList, 2)

                local function BuildOptions()
                    for _, c in pairs(OptionList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, val in ipairs(values) do
                        local isSel = (multi and multiSelected[val]) or (not multi and selected == val)
                        local Opt = MakeButton(OptionList, UDim2.new(1,0,0,24), nil, isSel and Theme.AccentDark or Theme.DropBG)
                        MakeCorner(Opt, 4)
                        local OptLabel = MakeLabel(Opt, tostring(val), 11, isSel and Theme.Text or Theme.TextDim, Enum.Font.GothamMedium)
                        OptLabel.Size = UDim2.new(1,-8,1,0) OptLabel.Position = UDim2.new(0,8,0,0)
                        OptLabel.TextYAlignment = Enum.TextYAlignment.Center

                        if multi and isSel then
                            local Check = MakeLabel(Opt, "✓", 11, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                            Check.Size = UDim2.new(0,20,1,0) Check.Position = UDim2.new(1,-22,0,0)
                            Check.TextYAlignment = Enum.TextYAlignment.Center
                        end

                        Opt.MouseEnter:Connect(function() if not isSel then Tween(Opt,{BackgroundColor3=Theme.GroupHeader},0.1) end end)
                        Opt.MouseLeave:Connect(function() if not isSel then Tween(Opt,{BackgroundColor3=Theme.DropBG},0.1) end end)
                        Opt.MouseButton1Click:Connect(function()
                            if multi then
                                multiSelected[val] = not multiSelected[val]
                                local result = {} for k,v in pairs(multiSelected) do if v then table.insert(result,k) end end
                                SelectedLabel.Text = #result>0 and table.concat(result,", ") or "None"
                                callback(result)
                            else
                                selected = val SelectedLabel.Text = tostring(val) callback(val)
                                open = false OptionList.Visible = false Tween(DropArrow,{Rotation=0},0.2)
                            end
                            BuildOptions()
                        end)
                    end
                end

                Header.MouseButton1Click:Connect(function()
                    open = not open OptionList.Visible = open
                    Tween(DropArrow, {Rotation=open and 180 or 0}, 0.2) BuildOptions()
                end)
                BuildOptions()

                function Dropdown:SetValues(v) values=v BuildOptions() end
                function Dropdown:SetValue(v) selected=v SelectedLabel.Text=tostring(v) callback(v) BuildOptions() end
                function Dropdown:GetValue()
                    if multi then local r={} for k,v in pairs(multiSelected) do if v then table.insert(r,k) end end return r end
                    return selected
                end

                if cfg.Flag then HollowLib.Flags[cfg.Flag] = Dropdown end
                return Dropdown
            end

            -- ADD LABEL
            function Group:AddLabel(text, richText)
                local Label = MakeFrame(ItemContainer, UDim2.new(1,0,0,22), nil, Theme.ItemBG)
                MakeCorner(Label, 5) MakePadding(Label, 0, 0, 8, 8)
                local LabelText = MakeLabel(Label, text, 11, Theme.TextDim, Enum.Font.Gotham)
                LabelText.Size = UDim2.new(1,0,1,0) LabelText.TextYAlignment = Enum.TextYAlignment.Center
                LabelText.RichText = richText or false LabelText.TextWrapped = true
                return LabelText
            end

            -- ADD DIVIDER
            function Group:AddDivider()
                local Div = MakeFrame(ItemContainer, UDim2.new(1,0,0,8), nil, Theme.ItemBG)
                local Line = MakeFrame(Div, UDim2.new(1,-16,0,1), UDim2.new(0,8,0.5,0), Theme.Border)
                MakeCorner(Line, 1)
                return Div
            end

            -- ADD COLOR PICKER
            function Group:AddColorPicker(id, cfg)
                local ColorPicker = {}
                local color = cfg.Default or Color3.fromRGB(255,255,255)
                local callback = cfg.Callback or function() end
                local pickerOpen = false

                local Container = MakeFrame(ItemContainer, UDim2.new(1,0,0,28), nil, Theme.ItemBG)
                MakeCorner(Container, 5) MakePadding(Container, 0, 0, 8, 8)

                local PickerLabel = MakeLabel(Container, cfg.Title or id, 12, Theme.Text, Enum.Font.GothamMedium)
                PickerLabel.Size = UDim2.new(1,-46,1,0) PickerLabel.TextYAlignment = Enum.TextYAlignment.Center

                local ColorBtn = MakeButton(Container, UDim2.new(0,36,0,18), UDim2.new(1,-38,0.5,-9), color)
                MakeCorner(ColorBtn, 5) MakeStroke(ColorBtn, Theme.BorderBright, 1)

                local PickerPopup = MakeFrame(ScreenGui, UDim2.new(0,200,0,220), UDim2.new(0,0,0,0), Theme.GroupBG)
                PickerPopup.Visible = false PickerPopup.ZIndex = 100
                MakeCorner(PickerPopup, 8) MakeStroke(PickerPopup, Theme.BorderBright, 1)
                MakePadding(PickerPopup, 10, 10, 10, 10) MakeList(PickerPopup, 6)

                local PickerTitle = MakeLabel(PickerPopup, cfg.Title or "Color Picker", 12, Theme.Text, Enum.Font.GothamBold)
                PickerTitle.Size = UDim2.new(1,0,0,16)

                local HueLabel = MakeLabel(PickerPopup, "Hue", 10, Theme.TextDim, Enum.Font.Gotham) HueLabel.Size = UDim2.new(1,0,0,12)
                local HueBG = MakeFrame(PickerPopup, UDim2.new(1,0,0,14), nil, Theme.SliderBG) HueBG.ZIndex=101 MakeCorner(HueBG,3)
                local HueGrad = Instance.new("UIGradient")
                HueGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))})
                HueGrad.Parent = HueBG
                local HueKnob = MakeFrame(HueBG,UDim2.new(0,10,1,4),UDim2.new(0,-5,0,-2),Theme.Text) MakeCorner(HueKnob,3) MakeStroke(HueKnob,Theme.Border,1) HueKnob.ZIndex=102

                local SatLabel = MakeLabel(PickerPopup,"Saturation",10,Theme.TextDim,Enum.Font.Gotham) SatLabel.Size=UDim2.new(1,0,0,12)
                local SatBG = MakeFrame(PickerPopup,UDim2.new(1,0,0,14),nil,Theme.SliderBG) SatBG.ZIndex=101 MakeCorner(SatBG,3)
                local SatFill = MakeFrame(SatBG,UDim2.new(1,0,1,0),nil,Theme.Accent) MakeCorner(SatFill,3)
                local SatKnob = MakeFrame(SatBG,UDim2.new(0,10,1,4),UDim2.new(1,-5,0,-2),Theme.Text) MakeCorner(SatKnob,3) MakeStroke(SatKnob,Theme.Border,1) SatKnob.ZIndex=102

                local ValLabel = MakeLabel(PickerPopup,"Value",10,Theme.TextDim,Enum.Font.Gotham) ValLabel.Size=UDim2.new(1,0,0,12)
                local ValBG = MakeFrame(PickerPopup,UDim2.new(1,0,0,14),nil,Theme.SliderBG) ValBG.ZIndex=101 MakeCorner(ValBG,3)
                local ValFill = MakeFrame(ValBG,UDim2.new(1,0,1,0),nil,Theme.Text) MakeCorner(ValFill,3)
                local ValKnob = MakeFrame(ValBG,UDim2.new(0,10,1,4),UDim2.new(1,-5,0,-2),Theme.Text) MakeCorner(ValKnob,3) MakeStroke(ValKnob,Theme.Border,1) ValKnob.ZIndex=102

                local hue, sat, val = Color3.toHSV(color)

                local function UpdateColor()
                    color = Color3.fromHSV(hue,sat,val) ColorBtn.BackgroundColor3=color
                    SatFill.BackgroundColor3=Color3.fromHSV(hue,1,1)
                    HueKnob.Position=UDim2.new(hue,-5,0,-2) SatKnob.Position=UDim2.new(sat,-5,0,-2) ValKnob.Position=UDim2.new(val,-5,0,-2)
                    callback(color)
                end

                local function MakeSliderDrag(bg, knob, onChange)
                    local drag = false
                    local dragBtn = MakeButton(bg, UDim2.new(1,0,1,0), nil, Theme.Background)
                    dragBtn.BackgroundTransparency=1 dragBtn.ZIndex=103
                    dragBtn.MouseButton1Down:Connect(function() drag=true end)
                    UserInputService.InputChanged:Connect(function(input)
                        if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                            local rel=math.clamp((input.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
                            onChange(rel) UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then drag=false end
                    end)
                end

                MakeSliderDrag(HueBG, HueKnob, function(v) hue=v end)
                MakeSliderDrag(SatBG, SatKnob, function(v) sat=v end)
                MakeSliderDrag(ValBG, ValKnob, function(v) val=v end)

                ColorBtn.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen PickerPopup.Visible = pickerOpen
                    if pickerOpen then
                        local ap = ColorBtn.AbsolutePosition
                        PickerPopup.Position = UDim2.new(0,ap.X-210,0,ap.Y-10)
                    end
                end)

                UpdateColor()

                function ColorPicker:SetValue(c) color=c hue,sat,val=Color3.toHSV(c) UpdateColor() end
                function ColorPicker:GetValue() return color end

                if cfg.Flag then HollowLib.Flags[cfg.Flag] = ColorPicker end
                return ColorPicker
            end

            -- ADD KEYBIND PICKER
            function Group:AddKeybindPicker(id, cfg)
                local KB = {}
                local key = cfg.Default or Enum.KeyCode.RightControl
                local callback = cfg.Callback or function() end
                local listening = false

                local Row = MakeFrame(ItemContainer, UDim2.new(1,0,0,28), nil, Theme.ItemBG)
                MakeCorner(Row, 5) MakePadding(Row, 0, 0, 8, 8)

                local KBLabel = MakeLabel(Row, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                KBLabel.Size = UDim2.new(1,-80,1,0) KBLabel.TextYAlignment = Enum.TextYAlignment.Center

                local KBBtn = MakeButton(Row, UDim2.new(0,72,0,20), UDim2.new(1,-74,0.5,-10), Theme.DropBG)
                MakeCorner(KBBtn, 5) MakeStroke(KBBtn, Theme.Border, 1)

                local KBText = MakeLabel(KBBtn, tostring(key.Name), 10, Theme.Accent, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                KBText.Size = UDim2.new(1,0,1,0) KBText.TextYAlignment = Enum.TextYAlignment.Center

                KBBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true KBText.Text = "..." KBText.TextColor3 = Theme.Text
                    Tween(KBBtn, {BackgroundColor3=Theme.AccentDark}, 0.15)
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                KBText.Text = tostring(key.Name) KBText.TextColor3 = Theme.Accent
                                Tween(KBBtn, {BackgroundColor3=Theme.DropBG}, 0.15)
                                listening = false conn:Disconnect() return
                            end
                            key = input.KeyCode KBText.Text = tostring(key.Name) KBText.TextColor3 = Theme.Accent
                            Tween(KBBtn, {BackgroundColor3=Theme.DropBG}, 0.15)
                            listening = false callback(key)
                            if cfg.IsHideKey then
                                hideKey = key Window:Notify("Hide key: "..tostring(key.Name), 2)
                            end
                            conn:Disconnect()
                        end
                    end)
                end)

                KBBtn.MouseEnter:Connect(function() if not listening then Tween(KBBtn,{BackgroundColor3=Theme.GroupHeader},0.1) end end)
                KBBtn.MouseLeave:Connect(function() if not listening then Tween(KBBtn,{BackgroundColor3=Theme.DropBG},0.1) end end)

                function KB:SetValue(k) key=k KBText.Text=tostring(k.Name) if cfg.IsHideKey then hideKey=k end end
                function KB:GetValue() return key end

                if cfg.Flag then HollowLib.Flags[cfg.Flag] = KB end
                return KB
            end

            return Group
        end

        function Tab:AddLeftGroupbox(name) return AddGroupInternal(name, LeftCol) end
        function Tab:AddRightGroupbox(name) return AddGroupInternal(name, RightCol) end
        function Tab:AddGroupbox(name) return AddGroupInternal(name, LeftCol) end

        return Tab
    end

    -- Notify
    local notifStack = {}
    function Window:Notify(text, duration)
        duration = duration or 3
        if type(text) == "table" then text = (text.Title or "")..": "..(text.Description or "") end

        -- shift existing notifs up
        for _, nf in ipairs(notifStack) do
            local cur = nf.Position
            Tween(nf, {Position=UDim2.new(cur.X.Scale,cur.X.Offset,cur.Y.Scale,cur.Y.Offset-44)}, 0.2)
        end

        local NotifFrame = MakeFrame(ScreenGui, UDim2.new(0,220,0,40), UDim2.new(1,10,1,-60), Theme.GroupBG)
        MakeCorner(NotifFrame, 7) MakeStroke(NotifFrame, Theme.Border, 1)
        local NotifBar = MakeFrame(NotifFrame, UDim2.new(0,3,1,-8), UDim2.new(0,0,0,4), Theme.Accent) MakeCorner(NotifBar, 2)
        local NotifText = MakeLabel(NotifFrame, text, 11, Theme.Text, Enum.Font.GothamMedium)
        NotifText.Size = UDim2.new(1,-14,1,0) NotifText.Position = UDim2.new(0,10,0,0)
        NotifText.TextYAlignment = Enum.TextYAlignment.Center NotifText.TextWrapped = true

        table.insert(notifStack, 1, NotifFrame)
        Tween(NotifFrame, {Position=UDim2.new(1,-230,1,-60)}, 0.3)

        task.delay(duration, function()
            Tween(NotifFrame, {Position=UDim2.new(1,10,1,-60)}, 0.3)
            task.wait(0.35)
            for i, v in ipairs(notifStack) do if v == NotifFrame then table.remove(notifStack, i) break end end
            NotifFrame:Destroy()
        end)
    end

    function Window:SetWatermark(text) WatermarkText.Text = text end
    function Window:SetWatermarkVisibility(visible) Watermark.Visible = visible end
    function Window:Unload()
        ScreenGui:Destroy()
        if getgenv()._HollowUnload then getgenv()._HollowUnload() end
    end
    function Window:OnUnload(callback) getgenv()._HollowUnload = callback end

    return Window
end

return HollowLib
