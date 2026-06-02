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

-- Polyfills for executor compatibility
if not math.clamp then
    math.clamp = function(v, lo, hi) return math.min(math.max(v, lo), hi) end
end
if not getgenv then
    getgenv = function() return _G end
end

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

-- ===== CORNER RADIUS PRESETS =====
local Radius = {
    Window  = 14,
    Group   = 12,
    Item    = 10,
    Button  = 10,
    Toggle  = 10,
    Small   = 8,
    Pill    = 14,
    Dot     = 3,
}

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function MakeCorner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or Radius.Item) c.Parent = p return c end
local function MakeStroke(p, c, t) local s = Instance.new("UIStroke") s.Color = c or Theme.Border s.Thickness = t or 1 s.Parent = p return s end
local function MakePadding(p, t, b, l, r) local u = Instance.new("UIPadding") u.PaddingTop = UDim.new(0, t or 6) u.PaddingBottom = UDim.new(0, b or 6) u.PaddingLeft = UDim.new(0, l or 8) u.PaddingRight = UDim.new(0, r or 8) u.Parent = p end
local function MakeList(p, pad, fill) local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, pad or 3) l.FillDirection = fill or Enum.FillDirection.Vertical l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p return l end

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
    local curW, curH = 580, 400
    local minW, minH = 380, 280

    -- Main Frame
    local Main = MakeFrame(ScreenGui, UDim2.new(0,curW,0,curH), UDim2.new(0.5,-curW/2,0.5,-curH/2), Theme.Background)
    Main.Name = "HollowWindow" Main.ClipsDescendants = false
    Main.BackgroundTransparency = 0.3
    MakeCorner(Main, Radius.Window) MakeStroke(Main, Theme.Border, 1)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://6014261993" Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.5 Shadow.Size = UDim2.new(1,40,1,40)
    Shadow.Position = UDim2.new(0,-20,0,-20) Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = -1 Shadow.Parent = Main

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1,0,0,34)
    Topbar.Position = UDim2.new(0,0,0,0)
    Topbar.BackgroundColor3 = Theme.Sidebar
    Topbar.BackgroundTransparency = 1
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main
    MakeCorner(Topbar, Radius.Window)
    -- Bottom fill to square off bottom corners
    local TopbarFill = Instance.new("Frame")
    TopbarFill.Size = UDim2.new(1,0,0.5,0)
    TopbarFill.Position = UDim2.new(0,0,0.5,0)
    TopbarFill.BackgroundColor3 = Theme.Sidebar
    TopbarFill.BackgroundTransparency = 1
    TopbarFill.BorderSizePixel = 0
    TopbarFill.Parent = Topbar

    -- Logo
    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Name = "Logo"
    LogoImg.Image = config.Logo or "rbxassetid://87465223885645"
    LogoImg.Size = UDim2.new(0,56,0,56)
    LogoImg.Position = UDim2.new(0,2,0.5,-28)
    LogoImg.BackgroundTransparency = 1
    LogoImg.BorderSizePixel = 0
    LogoImg.ScaleType = Enum.ScaleType.Fit
    LogoImg.ZIndex = 5
    LogoImg.Parent = Topbar

    -- Title
    local TitleLabel = MakeLabel(Topbar, config.Title or "HollowLib", 14, Theme.Text, Enum.Font.GothamBold)
    TitleLabel.Size = UDim2.new(1, isMobile and -140 or -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 58, 0, 0) TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Topbar buttons helper
    local topBtnOffset = -30
    local function makeTopBtn(sym, color)
        local b = MakeButton(Topbar, UDim2.new(0,26,0,26), UDim2.new(1,topBtnOffset,0.5,-13), Theme.Sidebar)
        b.BackgroundTransparency = 1
        MakeCorner(b, Radius.Small)
        local l = MakeLabel(b, sym, 14, color or Theme.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        l.Size = UDim2.new(1,0,1,0) l.TextYAlignment = Enum.TextYAlignment.Center
        b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3=Theme.GroupBG}, 0.15) end)
        b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3=Theme.Sidebar}, 0.15) end)
        topBtnOffset = topBtnOffset - 32
        return b, l
    end

    -- Close
    local CloseBtn, CloseL = makeTopBtn("X")
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,{BackgroundColor3=Theme.AccentDark},0.15) Tween(CloseL,{TextColor3=Theme.Text},0.15) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,{BackgroundColor3=Theme.Sidebar},0.15) Tween(CloseL,{TextColor3=Theme.TextDim},0.15) end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main,{Size=UDim2.new(0,curW,0,0),Position=UDim2.new(0.5,-curW/2,0.5,0)},0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        task.wait(0.35) ScreenGui:Destroy()
    end)

    -- Mobile only buttons
    if isMobile then
        local TogBtn, TogL = makeTopBtn("[=]")
        TogBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            local Content = Main:FindFirstChild("HollowContent")
            if Content then Content.Visible = uiVisible end
            Tween(Main, {Size=UDim2.new(0,curW,0,uiVisible and curH or 34)}, 0.25)
            Tween(TogBtn, {BackgroundColor3 = uiVisible and Theme.Sidebar or Theme.AccentDark}, 0.15)
            Tween(TogL, {TextColor3 = uiVisible and Theme.TextDim or Theme.Text}, 0.15)
        end)

        local LockBtn, LockL = makeTopBtn("UL")
        LockBtn.MouseButton1Click:Connect(function()
            uiLocked = not uiLocked
            LockL.Text = uiLocked and "LK" or "UL"
            Tween(LockBtn, {BackgroundColor3 = uiLocked and Theme.AccentDark or Theme.Sidebar}, 0.15)
            Tween(LockL, {TextColor3 = uiLocked and Theme.Text or Theme.TextDim}, 0.15)
            Window:Notify(uiLocked and "UI Locked" or "UI Unlocked", 2)
        end)
    end

    MakeDraggable(Topbar, Main, function() return uiLocked end)

    -- Hide/show keybind (desktop) - set up after Watermark is created
    local hideConnection

    -- Content
    local Content = MakeFrame(Main, UDim2.new(1,0,1,-34), UDim2.new(0,0,0,34), Theme.Background)
    Content.Name = "HollowContent"
    Content.BackgroundTransparency = 1
    Content.ClipsDescendants = true
    MakeCorner(Content, Radius.Window)

    -- Sidebar
    local Sidebar = MakeFrame(Content, UDim2.new(0,124,1,0), nil, Theme.Sidebar)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ClipsDescendants = true
    MakeCorner(Sidebar, Radius.Window)
    MakeStroke(Sidebar, Theme.Border, 1)

    local SideTitle = MakeLabel(Sidebar, "NAVIGATION", 9, Theme.TextDisabled, Enum.Font.GothamBold)
    SideTitle.Size = UDim2.new(1,-20,0,18) SideTitle.Position = UDim2.new(0,12,0,10)

    local TabList = MakeFrame(Sidebar, UDim2.new(1,0,1,-46), UDim2.new(0,0,0,32), Theme.Sidebar)
    TabList.BackgroundTransparency = 1
    TabList.ClipsDescendants = true
    MakeList(TabList, 5) MakePadding(TabList, 4, 6, 10, 10)

    -- Player info
    local PlayerInfo = MakeFrame(Sidebar, UDim2.new(1,0,0,40), UDim2.new(0,0,1,-40), Theme.Sidebar)
    PlayerInfo.BackgroundTransparency = 1
    MakeStroke(PlayerInfo, Theme.Border, 1) MakePadding(PlayerInfo, 6, 6, 10, 10)
    local PlayerAvatar = MakeImage(PlayerInfo, "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=48&height=48&format=png", UDim2.new(0,22,0,22), UDim2.new(0,0,0.5,-11))
    MakeCorner(PlayerAvatar, 11)
    local PlayerName = MakeLabel(PlayerInfo, config.DisplayName or LocalPlayer.DisplayName, 10, Theme.Text, Enum.Font.GothamMedium)
    PlayerName.Size = UDim2.new(1,-30,0,13) PlayerName.Position = UDim2.new(0,28,0,6)
    local PlayerUser = MakeLabel(PlayerInfo, "@"..(config.Username or LocalPlayer.Name), 9, Theme.TextDisabled, Enum.Font.Gotham)
    PlayerUser.Size = UDim2.new(1,-30,0,12) PlayerUser.Position = UDim2.new(0,28,0,20)

    -- Tab content area
    local TabContent = MakeFrame(Content, UDim2.new(1,-124,1,0), UDim2.new(0,124,0,0), Theme.Background)
    TabContent.BackgroundTransparency = 1
    TabContent.ClipsDescendants = true

    -- ===== WATERMARK =====
    local Watermark = MakeFrame(ScreenGui, UDim2.new(0, isMobile and 170 or 240, 0, 28), UDim2.new(0,12,1,-40), Theme.Watermark)
    Watermark.BackgroundTransparency = 0.3
    MakeCorner(Watermark, 10) 
    local WMStroke = MakeStroke(Watermark, Theme.Border, 1)

    -- Left accent bar
    local WMBar = MakeFrame(Watermark, UDim2.new(0,3,0,16), UDim2.new(0,6,0.5,-8), Theme.Accent)
    MakeCorner(WMBar, 2)

    -- Name label
    local WMName = MakeLabel(Watermark, "hollowoodz", 10, Theme.Text, Enum.Font.GothamBold)
    WMName.Size = UDim2.new(0,72,1,0) WMName.Position = UDim2.new(0,14,0,0)
    WMName.TextYAlignment = Enum.TextYAlignment.Center

    -- Separator dot
    local WMDot1 = MakeFrame(Watermark, UDim2.new(0,3,0,3), UDim2.new(0,88,0.5,-1), Theme.TextDisabled)
    MakeCorner(WMDot1, 2)

    -- FPS label
    local WMFps = MakeLabel(Watermark, "60fps", 10, Theme.Accent, Enum.Font.GothamMedium)
    WMFps.Size = UDim2.new(0,40,1,0) WMFps.Position = UDim2.new(0,96,0,0)
    WMFps.TextYAlignment = Enum.TextYAlignment.Center WMFps.TextXAlignment = Enum.TextXAlignment.Center

    -- Separator dot
    local WMDot2 = MakeFrame(Watermark, UDim2.new(0,3,0,3), UDim2.new(0,138,0.5,-1), Theme.TextDisabled)
    MakeCorner(WMDot2, 2)

    -- Ping label
    local WMPing = MakeLabel(Watermark, "0ms", 10, Theme.TextDim, Enum.Font.GothamMedium)
    WMPing.Size = UDim2.new(0,40,1,0) WMPing.Position = UDim2.new(0,146,0,0)
    WMPing.TextYAlignment = Enum.TextYAlignment.Center WMPing.TextXAlignment = Enum.TextXAlignment.Center

    local frameCount, frameTimer, fps = 0, tick(), 60
    local statsOk, stats = pcall(function() return game:GetService("Stats") end)
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - frameTimer >= 1 then fps = frameCount frameCount = 0 frameTimer = tick() end
        local ping = 0
        pcall(function()
            if statsOk and stats then ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end
        end)
        WMFps.Text = math.floor(fps).."fps"
        WMPing.Text = ping.."ms"
        -- Color code fps
        if fps >= 50 then WMFps.TextColor3 = Theme.Accent
        elseif fps >= 30 then WMFps.TextColor3 = Color3.fromRGB(220, 180, 30)
        else WMFps.TextColor3 = Color3.fromRGB(220, 50, 50) end
    end)

    -- Hide/show keybind (now that Watermark exists)
    hideConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == hideKey then
            uiVisible = not uiVisible
            Main.Visible = uiVisible
            Watermark.Visible = uiVisible
        end
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

        local TabBtn = MakeButton(TabList, UDim2.new(1,0,0,30), nil, Theme.TabInactive)
        TabBtn.BackgroundTransparency = 1
        MakeCorner(TabBtn, Radius.Small)

        local TabIndicator = MakeFrame(TabBtn, UDim2.new(0,3,0,10), UDim2.new(0,0,0.5,-5), Theme.Accent)
        TabIndicator.BackgroundTransparency = 1 MakeCorner(TabIndicator, 2)

        local TabIcon = MakeLabel(TabBtn, icon or "", 12, Theme.TextDim, Enum.Font.GothamMedium)
        TabIcon.Size = UDim2.new(0,18,1,0) TabIcon.Position = UDim2.new(0,7,0,0)
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center

        local TabLabel = MakeLabel(TabBtn, name, 11, Theme.TextDim, Enum.Font.GothamMedium)
        TabLabel.Size = UDim2.new(1,-32,1,0) TabLabel.Position = UDim2.new(0,26,0,0)

        -- Tab page with TWO COLUMN layout
        local TabPage = MakeFrame(TabContent, UDim2.new(1,0,1,0), nil, Theme.Background)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false TabPage.ClipsDescendants = true

        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Size = UDim2.new(1,0,1,0)
        TabScroll.BackgroundTransparency = 1 TabScroll.BorderSizePixel = 0
        TabScroll.ScrollBarThickness = 3 TabScroll.ScrollBarImageColor3 = Theme.ScrollBar
        TabScroll.CanvasSize = UDim2.new(0,0,0,0) TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabScroll.Parent = TabPage

        -- Inner wrapper for spacing (no UIPadding - use real frame offsets)
        local InnerWrap = Instance.new("Frame")
        InnerWrap.Size = UDim2.new(1,-38,0,0) -- 14 left + 24 right = 38
        InnerWrap.Position = UDim2.new(0,14,0,14) -- 14px from left, 14px from top
        InnerWrap.BackgroundTransparency = 1
        InnerWrap.BorderSizePixel = 0
        InnerWrap.AutomaticSize = Enum.AutomaticSize.Y
        InnerWrap.Parent = TabScroll

        -- Two column container
        local ColHolder = MakeFrame(InnerWrap, UDim2.new(1,0,0,0), nil, Theme.Background, 1)
        ColHolder.AutomaticSize = Enum.AutomaticSize.Y

        local ColLayout = Instance.new("UIListLayout")
        ColLayout.FillDirection = Enum.FillDirection.Horizontal
        ColLayout.Padding = UDim.new(0, 16)
        ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        ColLayout.Parent = ColHolder

        local LeftCol = MakeFrame(ColHolder, UDim2.new(0.5,-8,0,0), nil, Theme.Background, 1)
        LeftCol.AutomaticSize = Enum.AutomaticSize.Y
        MakeList(LeftCol, 10)

        local RightCol = MakeFrame(ColHolder, UDim2.new(0.5,-8,0,0), nil, Theme.Background, 1)
        RightCol.AutomaticSize = Enum.AutomaticSize.Y
        MakeList(RightCol, 10)

        -- Bottom spacer so scroll canvas has room at the end
        local BottomSpacer = Instance.new("Frame")
        BottomSpacer.Size = UDim2.new(1,0,0,16)
        BottomSpacer.Position = UDim2.new(0,0,0,0)
        BottomSpacer.BackgroundTransparency = 1
        BottomSpacer.LayoutOrder = 9999
        BottomSpacer.Parent = InnerWrap
        
        local WrapLayout = Instance.new("UIListLayout")
        WrapLayout.Padding = UDim.new(0, 0)
        WrapLayout.SortOrder = Enum.SortOrder.LayoutOrder
        WrapLayout.Parent = InnerWrap

        local function Activate()
            if ActiveTab and ActiveTab ~= Tab then ActiveTab:_deactivate() end
            isActive = true ActiveTab = Tab
            TabPage.Visible = true
            TabScroll.CanvasPosition = Vector2.new(0, 0)
            Tween(TabBtn, {BackgroundColor3=Theme.TabHover}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabLabel, {TextColor3=Theme.Text}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabIcon, {TextColor3=Theme.Accent}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabIndicator, {BackgroundTransparency=0, Size=UDim2.new(0,3,0,18)}, 0.25, Enum.EasingStyle.Back)
        end

        function Tab:_deactivate()
            isActive = false TabPage.Visible = false
            Tween(TabBtn, {BackgroundColor3=Theme.TabInactive}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabLabel, {TextColor3=Theme.TextDim}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabIcon, {TextColor3=Theme.TextDim}, 0.2, Enum.EasingStyle.Quint)
            Tween(TabIndicator, {BackgroundTransparency=1, Size=UDim2.new(0,3,0,10)}, 0.2, Enum.EasingStyle.Quint)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isActive then Tween(TabBtn, {BackgroundColor3=Color3.fromRGB(22,18,18)}, 0.2, Enum.EasingStyle.Quint) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not isActive then Tween(TabBtn, {BackgroundColor3=Theme.TabInactive}, 0.2, Enum.EasingStyle.Quint) end
        end)
        TabBtn.MouseButton1Click:Connect(Activate)
        if #Tabs == 0 then Activate() end
        table.insert(Tabs, Tab)

        -- ==================
        -- ADD GROUPBOX
        -- ==================
        local function AddGroupInternal(name, col)
            local Group = {}

            local GroupFrame = MakeFrame(col, UDim2.new(1,0,0,0), nil, Theme.GroupBG)
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
            GroupFrame.BackgroundTransparency = 1
            MakeCorner(GroupFrame, Radius.Group) MakeStroke(GroupFrame, Theme.Border, 1)
            GroupFrame.ClipsDescendants = false

            local Header = MakeFrame(GroupFrame, UDim2.new(1,0,0,28), nil, Theme.GroupHeader)
            Header.BackgroundTransparency = 1
            MakeCorner(Header, Radius.Group)
            local HeaderFill = MakeFrame(Header, UDim2.new(1,0,0.5,0), UDim2.new(0,0,0.5,0), Theme.GroupHeader)
            HeaderFill.BackgroundTransparency = 1

            local AccentLine = MakeFrame(Header, UDim2.new(0,3,0,12), UDim2.new(0,8,0.5,-6), Theme.Accent)
            MakeCorner(AccentLine, 2)

            local GroupTitle = MakeLabel(Header, name, 11, Theme.Text, Enum.Font.GothamBold)
            GroupTitle.Size = UDim2.new(1,-20,1,0) GroupTitle.Position = UDim2.new(0,18,0,0)
            GroupTitle.TextYAlignment = Enum.TextYAlignment.Center

            local ItemContainer = MakeFrame(GroupFrame, UDim2.new(1,0,0,0), UDim2.new(0,0,0,28), Theme.GroupBG)
            ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
            ItemContainer.BackgroundTransparency = 1
            MakeCorner(ItemContainer, Radius.Group) MakePadding(ItemContainer, 6, 8, 6, 6)
            MakeList(ItemContainer, 8)

            -- ADD TOGGLE
            function Group:AddToggle(id, cfg)
                local Toggle = {}
                local state = cfg.Default or false
                local callback = cfg.Callback or function() end

                local Row = MakeFrame(ItemContainer, UDim2.new(1,0,0,32), nil, Theme.ItemBG)
                Row.BackgroundTransparency = 1
                MakeCorner(Row, Radius.Item) MakePadding(Row, 0, 0, 10, 10)

                local RowBtn = MakeButton(Row, UDim2.new(1,0,1,0), nil, Theme.ItemBG)
                RowBtn.BackgroundTransparency = 1

                local ToggleLabel = MakeLabel(Row, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                ToggleLabel.Size = UDim2.new(1,-50,1,0) ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center

                -- Bigger pill toggle
                local ToggleBG = MakeFrame(Row, UDim2.new(0,40,0,22), UDim2.new(1,-42,0.5,-11), Theme.Toggle)
                MakeCorner(ToggleBG, 11)
                local ToggleStroke = MakeStroke(ToggleBG, Theme.Border, 1.5)

                -- Circle with shadow stroke
                local ToggleCircle = MakeFrame(ToggleBG, UDim2.new(0,16,0,16), UDim2.new(0,3,0.5,-8), Theme.TextDisabled)
                MakeCorner(ToggleCircle, 8)
                local CircleStroke = Instance.new("UIStroke")
                CircleStroke.Color = Theme.Border CircleStroke.Thickness = 1
                CircleStroke.Transparency = 0.5 CircleStroke.Parent = ToggleCircle

                local function SetState(newState, skipCb)
                    state = newState
                    if state then
                        Tween(ToggleBG, {BackgroundColor3=Theme.ToggleOn}, 0.25, Enum.EasingStyle.Quint)
                        Tween(ToggleStroke, {Color=Theme.Accent, Transparency=0.3}, 0.25)
                        Tween(ToggleCircle, {Position=UDim2.new(1,-19,0.5,-8), BackgroundColor3=Theme.Text, Size=UDim2.new(0,16,0,16)}, 0.3, Enum.EasingStyle.Back)
                        Tween(CircleStroke, {Color=Theme.Accent, Transparency=0.2}, 0.25)
                    else
                        Tween(ToggleBG, {BackgroundColor3=Theme.Toggle}, 0.25, Enum.EasingStyle.Quint)
                        Tween(ToggleStroke, {Color=Theme.Border, Transparency=0}, 0.25)
                        Tween(ToggleCircle, {Position=UDim2.new(0,3,0.5,-8), BackgroundColor3=Theme.TextDisabled, Size=UDim2.new(0,16,0,16)}, 0.3, Enum.EasingStyle.Back)
                        Tween(CircleStroke, {Color=Theme.Border, Transparency=0.5}, 0.25)
                    end
                    if not skipCb then callback(state) end
                end

                -- Squish on click
                RowBtn.MouseButton1Down:Connect(function()
                    Tween(ToggleCircle, {Size=UDim2.new(0,18,0,14)}, 0.1, Enum.EasingStyle.Quart)
                end)
                RowBtn.MouseButton1Up:Connect(function()
                    Tween(ToggleCircle, {Size=UDim2.new(0,16,0,16)}, 0.15, Enum.EasingStyle.Back)
                end)

                SetState(state, true)
                RowBtn.MouseButton1Click:Connect(function() SetState(not state) end)
                RowBtn.MouseEnter:Connect(function() Tween(ToggleStroke, {Transparency=0}, 0.15) end)
                RowBtn.MouseLeave:Connect(function() if not state then Tween(ToggleStroke, {Transparency=0}, 0.15) end end)

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

                local Container = MakeFrame(ItemContainer, UDim2.new(1,0,0,48), nil, Theme.ItemBG)
                Container.BackgroundTransparency = 1
                MakeCorner(Container, Radius.Item) MakePadding(Container, 8, 8, 10, 10)

                local TopRow = MakeFrame(Container, UDim2.new(1,0,0,16), nil, Theme.ItemBG)
                TopRow.BackgroundTransparency = 1

                local SliderLabel = MakeLabel(TopRow, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                SliderLabel.Size = UDim2.new(0.65,0,1,0)

                local ValueLabel = MakeLabel(TopRow, tostring(value)..suffix, 11, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                ValueLabel.Size = UDim2.new(0.35,0,1,0) ValueLabel.Position = UDim2.new(0.65,0,0,0)

                -- Thicker track
                local SliderBG = MakeFrame(Container, UDim2.new(1,0,0,8), UDim2.new(0,0,1,-12), Theme.SliderBG)
                MakeCorner(SliderBG, 4) MakeStroke(SliderBG, Theme.Border, 1)

                local alpha = (value-min)/(max-min)

                -- Glowing fill
                local SliderFill = MakeFrame(SliderBG, UDim2.new(alpha,0,1,0), nil, Theme.SliderFill)
                MakeCorner(SliderFill, 4)

                -- Bigger knob with accent glow
                local SliderKnob = MakeFrame(SliderBG, UDim2.new(0,14,0,14), UDim2.new(alpha,-7,0.5,-7), Theme.Text)
                MakeCorner(SliderKnob, 7)
                local KnobStroke = Instance.new("UIStroke")
                KnobStroke.Color = Theme.Accent KnobStroke.Thickness = 1.5
                KnobStroke.Transparency = 0.3 KnobStroke.Parent = SliderKnob

                local SliderBtn = MakeButton(SliderBG, UDim2.new(1,0,1,14), UDim2.new(0,0,0,-7), Theme.Background)
                SliderBtn.BackgroundTransparency = 1 SliderBtn.ZIndex = 2

                local function UpdateSlider(input)
                    local rel = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    value = min + (max-min) * rel
                    value = rounding == 0 and math.floor(value) or math.floor(value*(10^rounding)+0.5)/(10^rounding)
                    value = math.clamp(value, min, max)
                    local a = (value-min)/(max-min)
                    Tween(SliderFill, {Size=UDim2.new(a,0,1,0)}, 0.06, Enum.EasingStyle.Quart)
                    Tween(SliderKnob, {Position=UDim2.new(a,-7,0.5,-7)}, 0.06, Enum.EasingStyle.Quart)
                    ValueLabel.Text = tostring(value)..suffix
                    callback(value)
                end

                -- Knob grows when dragging
                SliderBtn.MouseButton1Down:Connect(function()
                    dragging = true
                    Tween(SliderKnob, {Size=UDim2.new(0,16,0,16)}, 0.1, Enum.EasingStyle.Back)
                    Tween(KnobStroke, {Thickness=2, Transparency=0}, 0.1)
                end)
                SliderBtn.TouchTap:Connect(function(touches) if touches[1] then UpdateSlider(touches[1]) end end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then UpdateSlider(i) end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        if dragging then
                            dragging = false
                            Tween(SliderKnob, {Size=UDim2.new(0,14,0,14)}, 0.2, Enum.EasingStyle.Back)
                            Tween(KnobStroke, {Thickness=1.5, Transparency=0.3}, 0.2)
                        end
                    end
                end)

                Container.MouseEnter:Connect(function() Tween(KnobStroke, {Transparency=0.1}, 0.15) end)
                Container.MouseLeave:Connect(function() if not dragging then Tween(KnobStroke, {Transparency=0.3}, 0.15) end end)

                function Slider:SetValue(v)
                    value = math.clamp(v,min,max) local a=(value-min)/(max-min)
                    Tween(SliderFill,{Size=UDim2.new(a,0,1,0)},0.15)
                    Tween(SliderKnob,{Position=UDim2.new(a,-7,0.5,-7)},0.15)
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

                local Btn = MakeButton(ItemContainer, UDim2.new(1,0,0,34), nil, Theme.ItemBG)
                Btn.BackgroundTransparency = 1
                MakeCorner(Btn, Radius.Item)
                local BtnStroke = MakeStroke(Btn, Theme.Border, 1)

                local BtnLabel = MakeLabel(Btn, text, 12, Theme.Text, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                BtnLabel.Size = UDim2.new(1,0,1,0) BtnLabel.TextYAlignment = Enum.TextYAlignment.Center

                -- Bottom accent line (hidden, shows on hover)
                local AccentBottom = MakeFrame(Btn, UDim2.new(0,0,0,2), UDim2.new(0.5,0,1,-3), Theme.Accent)
                MakeCorner(AccentBottom, 1) AccentBottom.AnchorPoint = Vector2.new(0.5, 0)

                Btn.MouseEnter:Connect(function()
                    Tween(BtnStroke, {Color=Theme.BorderBright, Transparency=0}, 0.15)
                    Tween(BtnLabel, {TextColor3=Theme.Accent}, 0.15)
                    Tween(AccentBottom, {Size=UDim2.new(0.5,0,0,2)}, 0.2, Enum.EasingStyle.Quint)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(BtnStroke, {Color=Theme.Border, Transparency=0}, 0.15)
                    Tween(BtnLabel, {TextColor3=Theme.Text}, 0.15)
                    Tween(AccentBottom, {Size=UDim2.new(0,0,0,2)}, 0.2, Enum.EasingStyle.Quint)
                end)
                Btn.MouseButton1Down:Connect(function()
                    Tween(BtnStroke, {Color=Theme.Accent, Transparency=0.2}, 0.08)
                    Tween(BtnLabel, {TextSize=11}, 0.08, Enum.EasingStyle.Quart)
                end)
                Btn.MouseButton1Up:Connect(function()
                    Tween(BtnStroke, {Color=Theme.BorderBright, Transparency=0}, 0.15)
                    Tween(BtnLabel, {TextSize=12}, 0.15, Enum.EasingStyle.Back)
                end)
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
                Container.BackgroundTransparency = 1
                Container.AutomaticSize = Enum.AutomaticSize.Y
                MakeCorner(Container, Radius.Item) MakePadding(Container, 5, 5, 8, 8)

                local Header = MakeButton(Container, UDim2.new(1,0,0,30), nil, Theme.DropBG)
                Header.BackgroundTransparency = 1
                MakeCorner(Header, Radius.Small) MakeStroke(Header, Theme.Border, 1)

                local DropLabel = MakeLabel(Header, cfg.Text or id, 10, Theme.TextDim, Enum.Font.Gotham)
                DropLabel.Size = UDim2.new(1,-30,0,12) DropLabel.Position = UDim2.new(0,10,0,3)

                local SelectedLabel = MakeLabel(Header, tostring(selected), 11, Theme.Text, Enum.Font.GothamMedium)
                SelectedLabel.Size = UDim2.new(1,-30,0,13) SelectedLabel.Position = UDim2.new(0,10,0,15)

                local DropArrow = Instance.new("ImageLabel")
                DropArrow.Size = UDim2.new(0,14,0,14)
                DropArrow.Position = UDim2.new(1,-20,0.5,-7)
                DropArrow.BackgroundTransparency = 1
                DropArrow.Image = "rbxassetid://6031091004"
                DropArrow.ImageColor3 = Theme.TextDim
                DropArrow.ScaleType = Enum.ScaleType.Fit
                DropArrow.Parent = Header

                local OptionList = MakeFrame(Container, UDim2.new(1,0,0,0), UDim2.new(0,0,0,36), Theme.DropOpen)
                OptionList.BackgroundTransparency = 1
                OptionList.AutomaticSize = Enum.AutomaticSize.Y OptionList.ClipsDescendants = true
                OptionList.Visible = false OptionList.ZIndex = 10
                MakeCorner(OptionList, Radius.Small) MakeStroke(OptionList, Theme.Border, 1)
                MakePadding(OptionList, 4, 4, 4, 4) MakeList(OptionList, 3)

                local function BuildOptions()
                    for _, c in pairs(OptionList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, val in ipairs(values) do
                        local isSel = (multi and multiSelected[val]) or (not multi and selected == val)
                        local Opt = MakeButton(OptionList, UDim2.new(1,0,0,28), nil, isSel and Theme.AccentDark or Theme.DropBG)
                        MakeCorner(Opt, Radius.Small)
                        local OptLabel = MakeLabel(Opt, tostring(val), 11, isSel and Theme.Text or Theme.TextDim, Enum.Font.GothamMedium)
                        OptLabel.Size = UDim2.new(1,-10,1,0) OptLabel.Position = UDim2.new(0,10,0,0)
                        OptLabel.TextYAlignment = Enum.TextYAlignment.Center

                        if multi and isSel then
                            local Check = MakeLabel(Opt, "v", 10, Theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                            Check.Size = UDim2.new(0,18,1,0) Check.Position = UDim2.new(1,-20,0,0)
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
                    Tween(DropArrow, {Rotation=open and 180 or 0}, 0.25, Enum.EasingStyle.Quint)
                    if open then
                        DropArrow.ImageColor3 = Theme.Accent
                    else
                        DropArrow.ImageColor3 = Theme.TextDim
                    end
                    BuildOptions()
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
                local Label = MakeFrame(ItemContainer, UDim2.new(1,0,0,28), nil, Theme.ItemBG)
                Label.BackgroundTransparency = 1
                MakeCorner(Label, Radius.Item) MakePadding(Label, 0, 0, 10, 10)
                local LabelText = MakeLabel(Label, text, 11, Theme.TextDim, Enum.Font.Gotham)
                LabelText.Size = UDim2.new(1,0,1,0) LabelText.TextYAlignment = Enum.TextYAlignment.Center
                LabelText.RichText = richText or false LabelText.TextWrapped = true
                return LabelText
            end

            -- ADD DIVIDER
            function Group:AddDivider()
                local Div = MakeFrame(ItemContainer, UDim2.new(1,0,0,10), nil, Theme.GroupBG)
                Div.BackgroundTransparency = 1
                local Line = MakeFrame(Div, UDim2.new(1,-14,0,1), UDim2.new(0,7,0.5,0), Theme.Border)
                MakeCorner(Line, 1)
                return Div
            end

            -- ADD COLOR PICKER (Modern 2D: SV square + Hue bar)
            function Group:AddColorPicker(id, cfg)
                local ColorPicker = {}
                local color = cfg.Default or Color3.fromRGB(255,255,255)
                local callback = cfg.Callback or function() end
                local pickerOpen = false

                local Container = MakeFrame(ItemContainer, UDim2.new(1,0,0,32), nil, Theme.ItemBG)
                Container.BackgroundTransparency = 1
                MakeCorner(Container, Radius.Item) MakePadding(Container, 0, 0, 10, 10)

                local PickerLabel = MakeLabel(Container, cfg.Title or id, 12, Theme.Text, Enum.Font.GothamMedium)
                PickerLabel.Size = UDim2.new(1,-46,1,0) PickerLabel.TextYAlignment = Enum.TextYAlignment.Center

                local ColorBtn = MakeButton(Container, UDim2.new(0,36,0,18), UDim2.new(1,-38,0.5,-9), color)
                MakeCorner(ColorBtn, Radius.Small) MakeStroke(ColorBtn, Theme.BorderBright, 1)

                -- Popup
                local popupW, popupH = 220, 260
                local PickerPopup = MakeFrame(ScreenGui, UDim2.new(0,popupW,0,popupH), UDim2.new(0,0,0,0), Theme.GroupBG)
                PickerPopup.Visible = false PickerPopup.ZIndex = 100
                PickerPopup.BackgroundTransparency = 0.1
                MakeCorner(PickerPopup, Radius.Group) MakeStroke(PickerPopup, Theme.BorderBright, 1)

                local PickerTitle = MakeLabel(PickerPopup, cfg.Title or "Color Picker", 11, Theme.Text, Enum.Font.GothamBold)
                PickerTitle.Size = UDim2.new(1,0,0,20) PickerTitle.Position = UDim2.new(0,10,0,6)

                -- SV Square (saturation X, value Y)
                local svSize = 170
                local SVFrame = MakeFrame(PickerPopup, UDim2.new(0,svSize,0,svSize), UDim2.new(0,10,0,28), Color3.fromHSV(0,1,1))
                SVFrame.ZIndex = 101
                MakeCorner(SVFrame, 6) SVFrame.ClipsDescendants = true

                -- White gradient left to right (saturation)
                local WhiteGrad = MakeFrame(SVFrame, UDim2.new(1,0,1,0), nil, Color3.new(1,1,1))
                WhiteGrad.ZIndex = 102
                local wGrad = Instance.new("UIGradient")
                wGrad.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
                wGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
                wGrad.Parent = WhiteGrad

                -- Black gradient top to bottom (value)
                local BlackGrad = MakeFrame(SVFrame, UDim2.new(1,0,1,0), nil, Color3.new(0,0,0))
                BlackGrad.ZIndex = 103
                local bGrad = Instance.new("UIGradient")
                bGrad.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
                bGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
                bGrad.Rotation = 90
                bGrad.Parent = BlackGrad

                -- SV Cursor (circle)
                local SVCursor = MakeFrame(SVFrame, UDim2.new(0,12,0,12), UDim2.new(0,0,0,0), Color3.new(1,1,1))
                SVCursor.ZIndex = 105
                MakeCorner(SVCursor, 6) MakeStroke(SVCursor, Color3.new(0,0,0), 2)

                -- SV drag button
                local SVBtn = MakeButton(SVFrame, UDim2.new(1,0,1,0), nil, Theme.Background)
                SVBtn.BackgroundTransparency = 1 SVBtn.ZIndex = 104

                -- Hue bar (vertical, right side)
                local HueBar = MakeFrame(PickerPopup, UDim2.new(0,20,0,svSize), UDim2.new(0,svSize+16,0,28), Color3.new(1,0,0))
                HueBar.ZIndex = 101
                MakeCorner(HueBar, 4) HueBar.ClipsDescendants = true
                local HueGrad = Instance.new("UIGradient")
                HueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
                    ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
                    ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),
                    ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),
                    ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),
                    ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
                    ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))
                })
                HueGrad.Rotation = 90
                HueGrad.Parent = HueBar

                -- Hue cursor
                local HueCursor = MakeFrame(HueBar, UDim2.new(1,4,0,6), UDim2.new(0,-2,0,0), Color3.new(1,1,1))
                HueCursor.ZIndex = 106
                MakeCorner(HueCursor, 3) MakeStroke(HueCursor, Color3.new(0,0,0), 1)

                local HueBtn = MakeButton(HueBar, UDim2.new(1,0,1,0), nil, Theme.Background)
                HueBtn.BackgroundTransparency = 1 HueBtn.ZIndex = 105

                -- Hex display row
                local HexRow = MakeFrame(PickerPopup, UDim2.new(0,popupW-20,0,24), UDim2.new(0,10,0,svSize+36), Theme.DropBG)
                HexRow.ZIndex = 101
                MakeCorner(HexRow, 5) MakeStroke(HexRow, Theme.Border, 1)

                local HexLabel = MakeLabel(HexRow, "#ffffff", 10, Theme.Text, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                HexLabel.Size = UDim2.new(0.5,0,1,0) HexLabel.ZIndex = 102
                HexLabel.TextYAlignment = Enum.TextYAlignment.Center

                local RGBLabel = MakeLabel(HexRow, "255, 255, 255", 10, Theme.TextDim, Enum.Font.Gotham, Enum.TextXAlignment.Center)
                RGBLabel.Size = UDim2.new(0.5,0,1,0) RGBLabel.Position = UDim2.new(0.5,0,0,0)
                RGBLabel.ZIndex = 102 RGBLabel.TextYAlignment = Enum.TextYAlignment.Center

                -- Preview swatch
                local PreviewSwatch = MakeFrame(PickerPopup, UDim2.new(0,popupW-20,0,16), UDim2.new(0,10,0,svSize+64), color)
                PreviewSwatch.ZIndex = 101
                MakeCorner(PreviewSwatch, 4) MakeStroke(PreviewSwatch, Theme.Border, 1)

                local hue, sat, val = Color3.toHSV(color)

                local function UpdateColor()
                    color = Color3.fromHSV(hue,sat,val)
                    ColorBtn.BackgroundColor3 = color
                    SVFrame.BackgroundColor3 = Color3.fromHSV(hue,1,1)
                    SVCursor.Position = UDim2.new(sat,-6,(1-val),-6)
                    HueCursor.Position = UDim2.new(0,-2,hue,-3)
                    PreviewSwatch.BackgroundColor3 = color
                    local r = math.floor(color.R*255)
                    local g = math.floor(color.G*255)
                    local b = math.floor(color.B*255)
                    HexLabel.Text = string.format("#%02x%02x%02x", r, g, b)
                    RGBLabel.Text = r..", "..g..", "..b
                    callback(color)
                end

                -- SV drag
                local svDrag = false
                SVBtn.MouseButton1Down:Connect(function() svDrag = true end)
                UserInputService.InputChanged:Connect(function(input)
                    if svDrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                        sat = math.clamp((input.Position.X - SVFrame.AbsolutePosition.X) / SVFrame.AbsoluteSize.X, 0, 1)
                        val = 1 - math.clamp((input.Position.Y - SVFrame.AbsolutePosition.Y) / SVFrame.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then svDrag=false end
                end)

                -- Hue drag
                local hueDrag = false
                HueBtn.MouseButton1Down:Connect(function() hueDrag = true end)
                UserInputService.InputChanged:Connect(function(input)
                    if hueDrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                        hue = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then hueDrag=false end
                end)

                ColorBtn.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen PickerPopup.Visible = pickerOpen
                    if pickerOpen then
                        local ap = ColorBtn.AbsolutePosition
                        PickerPopup.Position = UDim2.new(0, ap.X - popupW - 10, 0, ap.Y - 40)
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

                local Row = MakeFrame(ItemContainer, UDim2.new(1,0,0,32), nil, Theme.ItemBG)
                Row.BackgroundTransparency = 1
                MakeCorner(Row, Radius.Item) MakePadding(Row, 0, 0, 10, 10)

                local KBLabel = MakeLabel(Row, cfg.Text or id, 12, Theme.Text, Enum.Font.GothamMedium)
                KBLabel.Size = UDim2.new(1,-76,1,0) KBLabel.TextYAlignment = Enum.TextYAlignment.Center

                local KBBtn = MakeButton(Row, UDim2.new(0,68,0,22), UDim2.new(1,-70,0.5,-11), Theme.DropBG)
                KBBtn.BackgroundTransparency = 1
                MakeCorner(KBBtn, Radius.Small) MakeStroke(KBBtn, Theme.Border, 1)

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
        local title = "Notice"
        local desc = tostring(text)
        if type(text) == "table" then
            title = text.Title or "Notice"
            desc = text.Description or ""
        end

        -- Push existing notifs up
        for _, nf in ipairs(notifStack) do
            local cur = nf.Position
            Tween(nf, {Position=UDim2.new(cur.X.Scale,cur.X.Offset,cur.Y.Scale,cur.Y.Offset-58)}, 0.35, Enum.EasingStyle.Quint)
        end

        -- Container
        local NF = MakeFrame(ScreenGui, UDim2.new(0,270,0,52), UDim2.new(1,12,1,-66), Theme.Background)
        NF.BackgroundTransparency = 0.15
        NF.ClipsDescendants = true
        MakeCorner(NF, Radius.Group)
        local NFStroke = MakeStroke(NF, Theme.Border, 1)

        -- Left accent bar
        local NBar = MakeFrame(NF, UDim2.new(0,3,1,-12), UDim2.new(0,8,0,6), Theme.Accent)
        MakeCorner(NBar, 2)

        -- Title text
        local NTitle = MakeLabel(NF, title, 11, Theme.Text, Enum.Font.GothamBold)
        NTitle.Size = UDim2.new(1,-28,0,15) NTitle.Position = UDim2.new(0,18,0,7)

        -- Description text
        local NDesc = MakeLabel(NF, desc, 10, Theme.TextDim, Enum.Font.GothamMedium)
        NDesc.Size = UDim2.new(1,-28,0,14) NDesc.Position = UDim2.new(0,18,0,24)
        NDesc.TextWrapped = true

        -- Bottom progress bar (drains over time)
        local NProgress = MakeFrame(NF, UDim2.new(1,0,0,2), UDim2.new(0,0,1,-2), Theme.Accent)
        NProgress.BackgroundTransparency = 0.4

        table.insert(notifStack, 1, NF)

        -- Slide in with bounce
        Tween(NF, {Position=UDim2.new(1,-282,1,-66)}, 0.45, Enum.EasingStyle.Quint)
        Tween(NFStroke, {Color=Theme.BorderBright}, 0.3)

        -- Start draining after slide-in completes
        task.delay(0.5, function()
            Tween(NProgress, {Size=UDim2.new(0,0,0,2)}, duration - 0.5, Enum.EasingStyle.Linear)
        end)

        -- Fade and slide out
        task.delay(duration, function()
            Tween(NF, {Position=UDim2.new(1,12,1,-66), BackgroundTransparency=0.8}, 0.4, Enum.EasingStyle.Quint)
            Tween(NFStroke, {Transparency=0.8}, 0.3)
            task.wait(0.45)
            for i, v in ipairs(notifStack) do if v == NF then table.remove(notifStack, i) break end end
            NF:Destroy()
        end)
    end

    function Window:SetWatermark(text) WMName.Text = text end
    function Window:SetWatermarkVisibility(visible) Watermark.Visible = visible end
    function Window:SetDisplayName(name) PlayerName.Text = name end
    function Window:SetUsername(name) PlayerUser.Text = "@"..name end
    function Window:SetLogo(textureId) LogoImg.Image = "rbxassetid://"..tostring(textureId) end
    function Window:Unload()
        ScreenGui:Destroy()
        if getgenv()._HollowUnload then getgenv()._HollowUnload() end
    end
    function Window:OnUnload(callback) getgenv()._HollowUnload = callback end

    return Window
end

return HollowLib
