--[[
     S3xy Hub v3.0  |  Xeno / Solara / Synapse / Delta uyumlu
     gethui() bazlı  —  tam pembe  —  yatay UI
]]

-- ── Servisler ──────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")

-- ── LocalPlayer (güvenli) ──────────────────────────────────
local LP
repeat
    pcall(function() LP = Players.LocalPlayer end)
    if not LP then RunService.Heartbeat:Wait() end
until LP

-- ── GUI Container  (gethui öncelikli) ─────────────────────
local function GetContainer()
    -- gethui()  →  Xeno, Solara, Delta, Wave vb.
    if typeof(gethui) == "function" then
        return gethui()
    end
    -- Fallback sırası
    local targets = {
        function() return game:GetService("CoreGui") end,
        function() return LP:WaitForChild("PlayerGui", 5) end,
    }
    for _, fn in ipairs(targets) do
        local ok, r = pcall(fn)
        if ok and r then return r end
    end
end

-- ── Eski GUI temizle ───────────────────────────────────────
local function CleanOld()
    for _, name in ipairs({"S3xyHub_GUI","S3xyHub"}) do
        for _, container in ipairs({
            pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or nil,
            pcall(function() return LP.PlayerGui end) and LP.PlayerGui or nil,
            (typeof(gethui)=="function") and gethui() or nil,
        }) do
            if container then
                local old = container:FindFirstChild(name)
                if old then pcall(function() old:Destroy() end) end
            end
        end
    end
end
pcall(CleanOld)

-- ── Renkler ───────────────────────────────────────────────
local C = {
    BG       = Color3.fromRGB(240, 15, 110),
    BG2      = Color3.fromRGB(250, 50, 140),
    SIDEBAR  = Color3.fromRGB(210,  5,  92),
    TOPBAR   = Color3.fromRGB(190,  0,  82),
    DARK     = Color3.fromRGB(150,  0,  60),
    SLBG     = Color3.fromRGB(170,  0,  70),
    WHITE    = Color3.new(1, 1, 1),
    TEXT     = Color3.new(1, 1, 1),
    TEXT2    = Color3.fromRGB(255, 195, 218),
    BTNC     = Color3.fromRGB(205,  0,  88),
}

-- ── Yardımcı ──────────────────────────────────────────────
local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function MkStroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color       = col or C.WHITE
    s.Thickness   = th  or 1
    s.Transparency= tr  or 0.5
    s.Parent = p
    return s
end

local function MkLabel(p, txt, sz, col, fnt, xa)
    local l = Instance.new("TextLabel")
    l.Text             = txt
    l.TextSize         = sz  or 13
    l.TextColor3       = col or C.TEXT
    l.Font             = fnt or Enum.Font.GothamSemibold
    l.BackgroundTransparency = 1
    l.TextXAlignment   = xa  or Enum.TextXAlignment.Left
    l.TextYAlignment   = Enum.TextYAlignment.Center
    l.Parent = p
    return l
end

local function Tw(obj, t, props)
    pcall(function()
        TweenService:Create(
            obj,
            TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            props
        ):Play()
    end)
end

-- ══════════════════════════════════════════════════════════
--  KÜTÜPHANE
-- ══════════════════════════════════════════════════════════
local Lib = {}

function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title    or "S3xy Hub"
    local sub   = cfg.SubTitle or ""

    -- ── ScreenGui ────────────────────────────────────────
    local SG = Instance.new("ScreenGui")
    SG.Name            = "S3xyHub_GUI"
    SG.ResetOnSpawn    = false
    SG.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    pcall(function() SG.DisplayOrder  = 999 end)
    pcall(function() SG.IgnoreGuiInset= true end)

    local container = GetContainer()
    if not container then
        warn("[S3xyHub] Container bulunamadi!")
        return
    end
    SG.Parent = container

    -- ── Ana Çerçeve  620×370 ────────────────────────────
    local Main = Instance.new("Frame")
    Main.Name             = "Main"
    Main.Size             = UDim2.new(0, 620, 0, 370)
    Main.Position         = UDim2.new(0.5, -310, 0.5, -185)
    Main.BackgroundColor3 = C.BG
    Main.BorderSizePixel  = 0
    Main.ClipsDescendants = true
    Main.Parent           = SG
    Corner(Main, 14)
    MkStroke(Main, Color3.fromRGB(255,160,200), 2, 0.08)

    -- ── TopBar ──────────────────────────────────────────
    local TB = Instance.new("Frame")
    TB.Name             = "TopBar"
    TB.Size             = UDim2.new(1, 0, 0, 44)
    TB.BackgroundColor3 = C.TOPBAR
    TB.BorderSizePixel  = 0
    TB.ZIndex           = 5
    TB.Parent           = Main
    Corner(TB, 14)

    -- Marka
    local Brand = MkLabel(TB, "S3xy Hub", 20, C.TEXT, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    Brand.Size   = UDim2.new(1, 0, 1, 0)
    Brand.ZIndex = 6

    if sub ~= "" then
        local SubL = MkLabel(TB, sub, 10, C.TEXT2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
        SubL.Size     = UDim2.new(1, 0, 0, 12)
        SubL.Position = UDim2.new(0, 0, 1, -1)
        SubL.ZIndex   = 6
    end

    -- Kapat
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text             = "x"
    CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position         = UDim2.new(1, -34, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 115)
    CloseBtn.TextColor3       = C.WHITE
    CloseBtn.Font             = Enum.Font.GothamBold
    CloseBtn.TextSize         = 13
    CloseBtn.BorderSizePixel  = 0
    CloseBtn.ZIndex           = 7
    CloseBtn.Parent           = TB
    Corner(CloseBtn, 7)

    -- ── Sidebar ─────────────────────────────────────────
    local SB = Instance.new("Frame")
    SB.Size             = UDim2.new(0, 148, 1, -44)
    SB.Position         = UDim2.new(0, 0, 0, 44)
    SB.BackgroundColor3 = C.SIDEBAR
    SB.BorderSizePixel  = 0
    SB.ClipsDescendants = true
    SB.Parent           = Main

    -- Player kutusu
    local PBox = Instance.new("Frame")
    PBox.Size             = UDim2.new(1, -12, 0, 68)
    PBox.Position         = UDim2.new(0, 6, 0, 8)
    PBox.BackgroundColor3 = Color3.fromRGB(175, 0, 72)
    PBox.BackgroundTransparency = 0.2
    PBox.BorderSizePixel  = 0
    PBox.Parent           = SB
    Corner(PBox, 10)

    -- Avatar
    local Av = Instance.new("ImageLabel")
    Av.Size             = UDim2.new(0, 40, 0, 40)
    Av.Position         = UDim2.new(0, 8, 0.5, -20)
    Av.BackgroundColor3 = Color3.fromRGB(255, 130, 185)
    Av.BackgroundTransparency = 0.4
    Av.BorderSizePixel  = 0
    Av.Parent           = PBox
    Corner(Av, 8)
    pcall(function()
        Av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
            ..LP.UserId.."&width=150&height=150&format=png"
    end)

    local dname, uname = "Player", "unknown"
    pcall(function() dname = LP.DisplayName end)
    pcall(function() uname = LP.Name end)

    local NL = MkLabel(PBox, dname, 12, C.TEXT, Enum.Font.GothamBold)
    NL.Size = UDim2.new(1,-54,0,16); NL.Position = UDim2.new(0,52,0,12)
    NL.TextTruncate = Enum.TextTruncate.AtEnd

    local UL = MkLabel(PBox, "@"..uname, 10, C.TEXT2, Enum.Font.Gotham)
    UL.Size = UDim2.new(1,-54,0,14); UL.Position = UDim2.new(0,52,0,30)
    UL.TextTruncate = Enum.TextTruncate.AtEnd

    -- Tab buton listesi
    local TBList = Instance.new("Frame")
    TBList.Size             = UDim2.new(1,-12,1,-88)
    TBList.Position         = UDim2.new(0,6,0,84)
    TBList.BackgroundTransparency = 1
    TBList.ClipsDescendants = true
    TBList.Parent           = SB

    local TBLayout = Instance.new("UIListLayout")
    TBLayout.Padding   = UDim.new(0,5)
    TBLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TBLayout.Parent    = TBList

    -- ── İçerik Alanı ────────────────────────────────────
    local CA = Instance.new("Frame")
    CA.Size             = UDim2.new(1,-154,1,-44)
    CA.Position         = UDim2.new(0,152,0,44)
    CA.BackgroundColor3 = C.BG2
    CA.BorderSizePixel  = 0
    CA.ClipsDescendants = true
    CA.Parent           = Main
    Corner(CA, 10)

    -- ── Drag (sadece TopBar) ─────────────────────────────
    local dragging = false
    local dragOff  = Vector2.new()

    TB.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragOff  = Vector2.new(
                inp.Position.X - Main.AbsolutePosition.X,
                inp.Position.Y - Main.AbsolutePosition.Y
            )
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local vp = Vector2.new(1920,1080)
        pcall(function() vp = workspace.CurrentCamera.ViewportSize end)
        Main.Position = UDim2.new(
            0, math.clamp(inp.Position.X - dragOff.X, 0, vp.X-620),
            0, math.clamp(inp.Position.Y - dragOff.Y, 0, vp.Y-370)
        )
    end)

    -- ── Kapat / Aç ──────────────────────────────────────
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Text             = "S3xy Hub"
    OpenBtn.Size             = UDim2.new(0, 80, 0, 26)
    OpenBtn.Position         = UDim2.new(0, 10, 1, -36)
    OpenBtn.BackgroundColor3 = C.TOPBAR
    OpenBtn.TextColor3       = C.TEXT
    OpenBtn.Font             = Enum.Font.GothamBold
    OpenBtn.TextSize         = 11
    OpenBtn.BorderSizePixel  = 0
    OpenBtn.Visible          = false
    OpenBtn.ZIndex           = 10
    OpenBtn.Parent           = SG
    Corner(OpenBtn, 7)
    MkStroke(OpenBtn, Color3.fromRGB(255,165,200), 1.5, 0.2)

    CloseBtn.MouseButton1Click:Connect(function()
        Tw(Main, 0.25, {
            Size     = UDim2.new(0,0,0,0),
            Position = UDim2.new(0, Main.AbsolutePosition.X+310, 0, Main.AbsolutePosition.Y+185)
        })
        task.delay(0.27, function()
            Main.Visible   = false
            OpenBtn.Visible= true
        end)
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = false
        Main.Visible    = true
        Main.Size       = UDim2.new(0,0,0,0)
        Main.Position   = UDim2.new(0.5,0,0.5,0)
        Tw(Main, 0.45, {Size=UDim2.new(0,620,0,370), Position=UDim2.new(0.5,-310,0.5,-185)})
    end)

    -- ── Açılış animasyonu ────────────────────────────────
    Main.Size     = UDim2.new(0,0,0,0)
    Main.Position = UDim2.new(0.5,0,0.5,0)
    task.spawn(function()
        task.wait(0.05)
        Tw(Main, 0.5, {Size=UDim2.new(0,620,0,370), Position=UDim2.new(0.5,-310,0.5,-185)})
    end)

    -- ════════════════════════════════════════════════════
    --  TAB SİSTEMİ
    -- ════════════════════════════════════════════════════
    local tabs     = {}
    local tabCount = 0

    local function ActivateTab(idx)
        for i, t in ipairs(tabs) do
            if i == idx then
                Tw(t.btn, 0.15, {BackgroundTransparency = 0})
                t.btn.TextColor3 = C.BTNC
                t.page.Visible   = true
            else
                Tw(t.btn, 0.15, {BackgroundTransparency = 0.6})
                t.btn.TextColor3 = C.TEXT
                t.page.Visible   = false
            end
        end
    end

    local Win = {}

    function Win:AddTab(name)
        tabCount = tabCount + 1
        local idx = tabCount

        -- Sidebar butonu
        local TBtn = Instance.new("TextButton")
        TBtn.Text             = name
        TBtn.Size             = UDim2.new(1,0,0,30)
        TBtn.BackgroundColor3 = C.WHITE
        TBtn.BackgroundTransparency = 0.6
        TBtn.TextColor3       = C.TEXT
        TBtn.Font             = Enum.Font.GothamSemibold
        TBtn.TextSize         = 12
        TBtn.BorderSizePixel  = 0
        TBtn.LayoutOrder      = idx
        TBtn.Parent           = TBList
        Corner(TBtn, 7)

        -- Sayfa
        local Page = Instance.new("ScrollingFrame")
        Page.Size             = UDim2.new(1,-8,1,-8)
        Page.Position         = UDim2.new(0,4,0,4)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel  = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(255,175,210)
        Page.CanvasSize       = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible          = false
        Page.Parent           = CA

        local PLL = Instance.new("UIListLayout")
        PLL.Padding   = UDim.new(0,7)
        PLL.SortOrder = Enum.SortOrder.LayoutOrder
        PLL.Parent    = Page

        local PPad = Instance.new("UIPadding")
        PPad.PaddingLeft  = UDim.new(0,4)
        PPad.PaddingRight = UDim.new(0,4)
        PPad.PaddingTop   = UDim.new(0,4)
        PPad.Parent       = Page

        table.insert(tabs, {btn=TBtn, page=Page})
        TBtn.MouseButton1Click:Connect(function() ActivateTab(idx) end)
        if idx == 1 then ActivateTab(1) end

        -- ───────────────────────────────────────────────
        local Tab    = {}
        local eCount = 0

        local function EBox(h)
            eCount = eCount + 1
            local b = Instance.new("Frame")
            b.Size             = UDim2.new(1,-2,0,h)
            b.BackgroundColor3 = C.DARK
            b.BackgroundTransparency = 0.2
            b.BorderSizePixel  = 0
            b.LayoutOrder      = eCount
            b.Parent           = Page
            Corner(b, 8)
            return b
        end

        -- ── AddSlider ───────────────────────────────────
        function Tab:AddSlider(cfg)
            cfg = cfg or {}
            local lbl  = cfg.Name    or "Slider"
            local minV = cfg.Min     or 0
            local maxV = cfg.Max     or 100
            local def  = math.clamp(cfg.Default or 50, cfg.Min or 0, cfg.Max or 100)
            local cb   = cfg.Callback

            local box = EBox(66)

            local TL = MkLabel(box, lbl, 12, C.TEXT, Enum.Font.GothamSemibold)
            TL.Size = UDim2.new(0.65,0,0,18); TL.Position = UDim2.new(0,10,0,6)

            local VL = MkLabel(box, tostring(def), 12, C.TEXT2, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            VL.Size = UDim2.new(0.3,0,0,18); VL.Position = UDim2.new(0.68,0,0,6)

            local Track = Instance.new("Frame")
            Track.Size             = UDim2.new(1,-18,0,7)
            Track.Position         = UDim2.new(0,9,0,38)
            Track.BackgroundColor3 = C.SLBG
            Track.BorderSizePixel  = 0
            Track.Parent           = box
            Corner(Track, 4)

            local Fill = Instance.new("Frame")
            Fill.Size             = UDim2.new((def-minV)/(maxV-minV),0,1,0)
            Fill.BackgroundColor3 = C.WHITE
            Fill.BorderSizePixel  = 0
            Fill.Parent           = Track
            Corner(Fill, 4)

            local Knob = Instance.new("Frame")
            Knob.Size             = UDim2.new(0,15,0,15)
            Knob.AnchorPoint      = Vector2.new(0.5,0.5)
            Knob.Position         = UDim2.new((def-minV)/(maxV-minV),0,0.5,0)
            Knob.BackgroundColor3 = C.WHITE
            Knob.BorderSizePixel  = 0
            Knob.ZIndex           = 4
            Knob.Parent           = Track
            Corner(Knob, 8)
            MkStroke(Knob, Color3.fromRGB(255,100,150), 2, 0.1)

            -- Slider input  ── GUI hareket ETMEZ ──
            local sliding = false

            local function applyX(x)
                local rel = math.clamp(
                    (x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.round(minV + rel*(maxV-minV))
                Fill.Size     = UDim2.new(rel,0,1,0)
                Knob.Position = UDim2.new(rel,0,0.5,0)
                VL.Text       = tostring(val)
                if cb then pcall(cb, val) end
            end

            Track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    applyX(inp.Position.X)
                    Tw(Knob,0.08,{Size=UDim2.new(0,19,0,19)})
                    inp.Changed:Connect(function()
                        if inp.UserInputState == Enum.UserInputState.End then
                            sliding = false
                            Tw(Knob,0.08,{Size=UDim2.new(0,15,0,15)})
                        end
                    end)
                end
            end)

            UserInputService.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch then
                    applyX(inp.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(inp)
                if (inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch) and sliding then
                    sliding = false
                    Tw(Knob,0.08,{Size=UDim2.new(0,15,0,15)})
                end
            end)

            return {
                SetValue = function(v)
                    v = math.clamp(v, minV, maxV)
                    local rel = (v-minV)/(maxV-minV)
                    Fill.Size     = UDim2.new(rel,0,1,0)
                    Knob.Position = UDim2.new(rel,0,0.5,0)
                    VL.Text       = tostring(math.round(v))
                    if cb then pcall(cb,v) end
                end
            }
        end

        -- ── AddToggle ───────────────────────────────────
        function Tab:AddToggle(cfg)
            cfg = cfg or {}
            local lbl  = cfg.Name    or "Toggle"
            local def  = cfg.Default or false
            local cb   = cfg.Callback

            local box   = EBox(44)
            local state = def

            local TL = MkLabel(box, lbl, 12, C.TEXT, Enum.Font.GothamSemibold)
            TL.Size = UDim2.new(0.7,0,1,0); TL.Position = UDim2.new(0,10,0,0)

            local TrK = Instance.new("Frame")
            TrK.Size             = UDim2.new(0,40,0,20)
            TrK.Position         = UDim2.new(1,-48,0.5,-10)
            TrK.BackgroundColor3 = state and C.WHITE or C.SLBG
            TrK.BorderSizePixel  = 0
            TrK.Parent           = box
            Corner(TrK, 10)

            local Thumb = Instance.new("Frame")
            Thumb.Size             = UDim2.new(0,14,0,14)
            Thumb.Position         = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
            Thumb.BackgroundColor3 = state and C.BTNC or C.WHITE
            Thumb.BorderSizePixel  = 0
            Thumb.Parent           = TrK
            Corner(Thumb, 7)

            local function SetState(s)
                state = s
                Tw(TrK,   0.18, {BackgroundColor3 = s and C.WHITE or C.SLBG})
                Tw(Thumb, 0.18, {
                    Position         = s and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
                    BackgroundColor3 = s and C.BTNC or C.WHITE,
                })
                if cb then pcall(cb, s) end
            end

            box.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SetState(not state)
                end
            end)

            return {
                SetValue = function(v) SetState(v) end,
                GetValue = function() return state end,
            }
        end

        -- ── AddButton ───────────────────────────────────
        function Tab:AddButton(cfg)
            cfg = cfg or {}
            local lbl = cfg.Name     or "Buton"
            local cb  = cfg.Callback

            local box = EBox(38)
            box.BackgroundTransparency = 1

            local Btn = Instance.new("TextButton")
            Btn.Text             = lbl
            Btn.Size             = UDim2.new(1,0,1,0)
            Btn.BackgroundColor3 = C.WHITE
            Btn.TextColor3       = C.BTNC
            Btn.Font             = Enum.Font.GothamBold
            Btn.TextSize         = 13
            Btn.BorderSizePixel  = 0
            Btn.LayoutOrder      = eCount
            Btn.Parent           = box
            Corner(Btn, 8)

            Btn.MouseButton1Click:Connect(function()
                Tw(Btn, 0.07, {BackgroundColor3=Color3.fromRGB(255,190,215)})
                task.delay(0.13, function() Tw(Btn,0.1,{BackgroundColor3=C.WHITE}) end)
                if cb then pcall(cb) end
            end)
        end

        -- ── AddLabel ────────────────────────────────────
        function Tab:AddLabel(text)
            local box = EBox(30)
            local l = MkLabel(box, text, 11, C.TEXT2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            l.Size = UDim2.new(1,-14,1,0); l.Position = UDim2.new(0,7,0,0)
        end

        -- ── AddSection ──────────────────────────────────
        function Tab:AddSection(text)
            local box = EBox(22)
            box.BackgroundTransparency = 0.62
            local l = MkLabel(box,"-- "..text.." --",10,C.TEXT2,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
            l.Size = UDim2.new(1,0,1,0)
        end

        return Tab
    end -- AddTab

    return Win
end -- CreateWindow

return Lib

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  XENO'DA TEST  —  Executor'a direk yapistir
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Hub = loadstring(game:HttpGet("RAW_LINK"))()

local Win = Hub:CreateWindow({ Title = "Benim Script" })

local Kar = Win:AddTab("Karakter")
Kar:AddSection("Hareket")
Kar:AddSlider({ Name="Hiz",     Min=1, Max=200, Default=16,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end })
Kar:AddSlider({ Name="Ziplama", Min=1, Max=300, Default=50,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end })
Kar:AddToggle({ Name="Inf Jump", Default=false,
    Callback=function(s)
        if s then
            _G.IJ=game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        elseif _G.IJ then _G.IJ:Disconnect() end
    end})
Kar:AddButton({ Name="Reset", Callback=function()
    game.Players.LocalPlayer.Character.Humanoid.Health=0 end})

local Vis = Win:AddTab("Grafik")
Vis:AddSlider({ Name="FOV",        Min=30,  Max=120, Default=70,
    Callback=function(v) workspace.CurrentCamera.FieldOfView=v end})
Vis:AddSlider({ Name="Yercekimi",  Min=10,  Max=300, Default=196,
    Callback=function(v) workspace.Gravity=v end})
]]
