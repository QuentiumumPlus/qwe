--[[
╔═══════════════════════════════════════════════════════════╗
║                  S3xy Hub  v4.0                           ║
║  Xeno / Solara / Delta / Synapse uyumlu                   ║
║  gethui()  |  Rayfield tarzı açılış  |  EULA              ║
║  Neon arka plan  |  Player panel  |  Özelleştirme         ║
╚═══════════════════════════════════════════════════════════╝

KULLANIM:
    local Hub = loadstring(game:HttpGet("RAW_LINK"))()
    
    local Win = Hub:CreateWindow({
        Title        = "Benim Script",
        SubTitle     = "v1.0  |  by Sen",
        ConfigFolder = "BenimScript",  -- ayar kaydetme klasoru
    })
    
    local Tab = Win:AddTab("Karakter")
    
    Tab:AddSlider({
        Name="Hiz", Min=1, Max=200, Default=16,
        Callback=function(v)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    })
]]

-- ═══════════════════════════════════════════════════════════
--  SERVİSLER
-- ═══════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UIS              = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

-- ═══════════════════════════════════════════════════════════
--  LOCAL PLAYER  (güvenli)
-- ═══════════════════════════════════════════════════════════
local LP
repeat
    pcall(function() LP = Players.LocalPlayer end)
    if not LP then RunService.Heartbeat:Wait() end
until LP

-- ═══════════════════════════════════════════════════════════
--  CONTAINER  (gethui öncelikli)
-- ═══════════════════════════════════════════════════════════
local function GetContainer()
    if typeof(gethui) == "function" then return gethui() end
    local ok, r = pcall(function() return game:GetService("CoreGui") end)
    if ok and r then return r end
    pcall(function() return LP:WaitForChild("PlayerGui",5) end)
end

-- ═══════════════════════════════════════════════════════════
--  RENK PALETİ
-- ═══════════════════════════════════════════════════════════
local C = {
    -- Ana pembe tonları
    HOT      = Color3.fromRGB(255,  20, 115),
    MID      = Color3.fromRGB(245,  10, 100),
    DEEP     = Color3.fromRGB(200,   0,  85),
    DARK     = Color3.fromRGB(145,   0,  58),
    DARKEST  = Color3.fromRGB( 90,   0,  35),
    -- Metin
    WHITE    = Color3.new(1,1,1),
    TEXT2    = Color3.fromRGB(255, 195, 218),
    -- Neon parlama
    NEON     = Color3.fromRGB(255,  80, 160),
    -- Arka plan dekorasyon
    DECO     = Color3.fromRGB(255, 130, 180),
    -- Buton
    BTNBG    = Color3.new(1,1,1),
    BTNTXT   = Color3.fromRGB(210,   0,  88),
}

-- ═══════════════════════════════════════════════════════════
--  YARDIMCI FONKSİYONLAR
-- ═══════════════════════════════════════════════════════════
local function Cr(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c end
local function St(p,col,th,tr) local s=Instance.new("UIStroke") s.Color=col or C.WHITE s.Thickness=th or 1 s.Transparency=tr or 0.5 s.Parent=p return s end
local function Lbl(p,txt,sz,col,fnt,xa)
    local l=Instance.new("TextLabel")
    l.Text=txt l.TextSize=sz or 13 l.TextColor3=col or C.WHITE
    l.Font=fnt or Enum.Font.GothamSemibold
    l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.Parent=p return l
end
local function Tw(o,t,props)
    pcall(function()
        TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
    end)
end
local function TwBounce(o,t,props)
    pcall(function()
        TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),props):Play()
    end)
end

-- ═══════════════════════════════════════════════════════════
--  KÜTÜPHANe
-- ═══════════════════════════════════════════════════════════
local Lib = {}

function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local winTitle  = cfg.Title        or "S3xy Hub"
    local winSub    = cfg.SubTitle     or "v4.0"
    local cfgFolder = cfg.ConfigFolder or "S3xyHub"

    -- Eski GUI temizle
    pcall(function()
        for _,c in ipairs({gethui and gethui(),
                           pcall(function()return game:GetService("CoreGui")end) and game:GetService("CoreGui"),
                           LP.PlayerGui}) do
            if c then
                local o=c:FindFirstChild("S3xyHub_GUI")
                if o then o:Destroy() end
            end
        end
    end)

    local container = GetContainer()
    if not container then warn("[S3xyHub] Container yok!") return end

    -- ScreenGui
    local SG = Instance.new("ScreenGui")
    SG.Name           = "S3xyHub_GUI"
    SG.ResetOnSpawn   = false
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() SG.DisplayOrder   = 999 end)
    pcall(function() SG.IgnoreGuiInset = true end)
    SG.Parent = container

    -- ══════════════════════════════════════════════════════
    --  ARKA PLAN NEON DEKORASYON  (kalpler, +18, süsler)
    -- ══════════════════════════════════════════════════════
    local BG = Instance.new("Frame")
    BG.Name             = "NeonBG"
    BG.Size             = UDim2.new(1,0,1,0)
    BG.BackgroundColor3 = Color3.fromRGB(12,2,8)
    BG.BackgroundTransparency = 0
    BG.BorderSizePixel  = 0
    BG.ZIndex           = 1
    BG.Parent           = SG

    -- Yayılan neon daire efektleri
    local glowData = {
        {x=0.15, y=0.25, s=260, a=0.55, c=Color3.fromRGB(255,20,110)},
        {x=0.75, y=0.65, s=300, a=0.50, c=Color3.fromRGB(200,0,80)},
        {x=0.50, y=0.50, s=400, a=0.65, c=Color3.fromRGB(130,0,50)},
        {x=0.88, y=0.15, s=180, a=0.60, c=Color3.fromRGB(255,60,140)},
        {x=0.10, y=0.80, s=200, a=0.58, c=Color3.fromRGB(255,40,120)},
    }
    for _,g in ipairs(glowData) do
        local gl = Instance.new("ImageLabel")
        gl.Size             = UDim2.new(0,g.s,0,g.s)
        gl.Position         = UDim2.new(g.x,-g.s/2,g.y,-g.s/2)
        gl.BackgroundTransparency = 1
        gl.Image            = "rbxassetid://5028857084"
        gl.ImageColor3      = g.c
        gl.ImageTransparency= g.a
        gl.ZIndex           = 2
        gl.Parent           = BG
    end

    -- Floating dekoratif semboller (kalpler, +18, yıldız vb.)
    local symbols = {
        -- {text, x, y, size, rot, alpha}
        {"♥",  0.05, 0.08, 42, -15, 0.25},
        {"♥",  0.90, 0.12, 30,  20, 0.30},
        {"♥",  0.18, 0.88, 36,  -8, 0.22},
        {"♥",  0.82, 0.78, 28,  12, 0.28},
        {"♥",  0.50, 0.06, 24, -25, 0.20},
        {"♥",  0.35, 0.93, 32,   5, 0.25},
        {"♥",  0.70, 0.04, 38, -10, 0.22},
        {"18+",0.92, 0.45, 20,   8, 0.18},
        {"18+",0.04, 0.50, 18, -12, 0.15},
        {"18+",0.55, 0.95, 16,   6, 0.16},
        {"★",  0.25, 0.04, 28,  30, 0.18},
        {"★",  0.78, 0.90, 22, -20, 0.18},
        {"★",  0.95, 0.75, 18,  15, 0.15},
        {"✦",  0.12, 0.45, 20,   0, 0.20},
        {"✦",  0.88, 0.55, 16,  45, 0.18},
    }
    for _,s in ipairs(symbols) do
        local sl = Instance.new("TextLabel")
        sl.Text               = s[1]
        sl.TextSize           = s[4]
        sl.TextColor3         = C.NEON
        sl.TextTransparency   = s[6]
        sl.Font               = Enum.Font.GothamBold
        sl.BackgroundTransparency = 1
        sl.Position           = UDim2.new(s[2],0,s[3],0)
        sl.Size               = UDim2.new(0,60,0,40)
        sl.Rotation           = s[5]
        sl.ZIndex             = 3
        sl.Parent             = BG
    end

    -- Subtle grid çizgiler (neon tarzı)
    for i=0,8 do
        local line = Instance.new("Frame")
        line.Size             = UDim2.new(1,0,0,1)
        line.Position         = UDim2.new(0,0, i/8, 0)
        line.BackgroundColor3 = C.NEON
        line.BackgroundTransparency = 0.90
        line.BorderSizePixel  = 0
        line.ZIndex           = 3
        line.Parent           = BG
    end
    for i=0,12 do
        local line = Instance.new("Frame")
        line.Size             = UDim2.new(0,1,1,0)
        line.Position         = UDim2.new(i/12,0,0,0)
        line.BackgroundColor3 = C.NEON
        line.BackgroundTransparency = 0.90
        line.BorderSizePixel  = 0
        line.ZIndex           = 3
        line.Parent           = BG
    end

    -- ══════════════════════════════════════════════════════
    --  EULA EKRANI
    -- ══════════════════════════════════════════════════════
    local EulaFrame = Instance.new("Frame")
    EulaFrame.Name             = "EULA"
    EulaFrame.Size             = UDim2.new(0,440,0,310)
    EulaFrame.Position         = UDim2.new(0.5,-220,0.5,-155)
    EulaFrame.BackgroundColor3 = Color3.fromRGB(18,4,12)
    EulaFrame.BorderSizePixel  = 0
    EulaFrame.ZIndex           = 20
    EulaFrame.Parent           = SG
    Cr(EulaFrame, 16)
    St(EulaFrame, C.NEON, 2, 0.1)

    -- Başlık
    local EulaTitle = Lbl(EulaFrame,"Kullanici Sozlesmesi",17,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    EulaTitle.Size = UDim2.new(1,0,0,42) EulaTitle.ZIndex=21

    -- Ayraç
    local EulaSep = Instance.new("Frame")
    EulaSep.Size=UDim2.new(1,-30,0,1) EulaSep.Position=UDim2.new(0,15,0,42)
    EulaSep.BackgroundColor3=C.NEON EulaSep.BackgroundTransparency=0.5
    EulaSep.BorderSizePixel=0 EulaSep.ZIndex=21 EulaSep.Parent=EulaFrame

    -- Metin
    local EulaTxt = Instance.new("TextLabel")
    EulaTxt.Size             = UDim2.new(1,-30,0,170)
    EulaTxt.Position         = UDim2.new(0,15,0,50)
    EulaTxt.BackgroundTransparency = 1
    EulaTxt.TextColor3       = C.TEXT2
    EulaTxt.Font             = Enum.Font.Gotham
    EulaTxt.TextSize         = 12
    EulaTxt.TextWrapped      = true
    EulaTxt.TextXAlignment   = Enum.TextXAlignment.Left
    EulaTxt.TextYAlignment   = Enum.TextYAlignment.Top
    EulaTxt.ZIndex           = 21
    EulaTxt.Text             = [[Bu yazilimi kullanarak asagidaki kosullari kabul etmis sayilirsiniz:

  1. Bu script yalnizca egitim ve kisisel kullanim amaclıdır.
  2. Baska oyunculara zarar vermek icin kullanmak yasaktır.
  3. Hesabınızın banlanma riskini tamamen siz ustlenirsiniz.
  4. Gelistirici herhangi bir zarardan sorumlu tutulamaz.
  5. Bu script 18+ iceriklere sahiptir; kullanici +18 yasinda olmalidir.
  6. Scripti dagitmak veya satmak kesinlikle yasaktır.

Devam ederek tum kosullari okudugunuzu ve kabul ettiginizi onayliyorsunuz.]]
    EulaTxt.Parent = EulaFrame

    -- Reddet butonu
    local EulaDeny = Instance.new("TextButton")
    EulaDeny.Text             = "Reddet"
    EulaDeny.Size             = UDim2.new(0,120,0,34)
    EulaDeny.Position         = UDim2.new(0.5,-130,1,-48)
    EulaDeny.BackgroundColor3 = Color3.fromRGB(60,10,25)
    EulaDeny.TextColor3       = C.TEXT2
    EulaDeny.Font             = Enum.Font.GothamSemibold
    EulaDeny.TextSize         = 13
    EulaDeny.BorderSizePixel  = 0
    EulaDeny.ZIndex           = 22
    EulaDeny.Parent           = EulaFrame
    Cr(EulaDeny, 8)

    -- Kabul butonu
    local EulaAccept = Instance.new("TextButton")
    EulaAccept.Text             = "Kabul Et"
    EulaAccept.Size             = UDim2.new(0,120,0,34)
    EulaAccept.Position         = UDim2.new(0.5,10,1,-48)
    EulaAccept.BackgroundColor3 = C.HOT
    EulaAccept.TextColor3       = C.WHITE
    EulaAccept.Font             = Enum.Font.GothamBold
    EulaAccept.TextSize         = 13
    EulaAccept.BorderSizePixel  = 0
    EulaAccept.ZIndex           = 22
    EulaAccept.Parent           = EulaFrame
    Cr(EulaAccept, 8)

    EulaDeny.MouseButton1Click:Connect(function()
        Tw(EulaFrame,0.3,{BackgroundTransparency=1})
        task.delay(0.35, function() SG:Destroy() end)
    end)

    -- ══════════════════════════════════════════════════════
    --  AÇILIŞ (SPLASH) EKRANI  — Rayfield tarzı
    -- ══════════════════════════════════════════════════════
    local SplashFrame = Instance.new("Frame")
    SplashFrame.Name             = "Splash"
    SplashFrame.Size             = UDim2.new(0,380,0,200)
    SplashFrame.Position         = UDim2.new(0.5,-190,0.5,-100)
    SplashFrame.BackgroundColor3 = Color3.fromRGB(16,3,10)
    SplashFrame.BorderSizePixel  = 0
    SplashFrame.ZIndex           = 15
    SplashFrame.Visible          = false
    SplashFrame.Parent           = SG
    Cr(SplashFrame, 18)
    St(SplashFrame, C.NEON, 2, 0.05)

    -- Logo / ikon glow
    local SplashGlow = Instance.new("ImageLabel")
    SplashGlow.Size             = UDim2.new(0,110,0,110)
    SplashGlow.Position         = UDim2.new(0.5,-55,0,18)
    SplashGlow.BackgroundTransparency = 1
    SplashGlow.Image            = "rbxassetid://5028857084"
    SplashGlow.ImageColor3      = C.HOT
    SplashGlow.ImageTransparency= 0.2
    SplashGlow.ZIndex           = 16
    SplashGlow.Parent           = SplashFrame

    local SplashIcon = Lbl(SplashFrame,"S",44,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    SplashIcon.Size     = UDim2.new(0,60,0,60)
    SplashIcon.Position = UDim2.new(0.5,-30,0,33)
    SplashIcon.ZIndex   = 17

    -- Marka adı
    local SplashTitle = Lbl(SplashFrame,"S3xy Hub",22,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    SplashTitle.Size     = UDim2.new(1,0,0,28)
    SplashTitle.Position = UDim2.new(0,0,0,128)
    SplashTitle.ZIndex   = 16

    -- Script başlığı
    local SplashSub = Lbl(SplashFrame, winTitle ,13,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
    SplashSub.Size     = UDim2.new(1,0,0,18)
    SplashSub.Position = UDim2.new(0,0,0,156)
    SplashSub.ZIndex   = 16

    -- Loading bar arka plan
    local BarBG = Instance.new("Frame")
    BarBG.Size             = UDim2.new(0,260,0,4)
    BarBG.Position         = UDim2.new(0.5,-130,1,-22)
    BarBG.BackgroundColor3 = C.DARKEST
    BarBG.BorderSizePixel  = 0
    BarBG.ZIndex           = 16
    BarBG.Parent           = SplashFrame
    Cr(BarBG, 2)

    local BarFill = Instance.new("Frame")
    BarFill.Size             = UDim2.new(0,0,1,0)
    BarFill.BackgroundColor3 = C.HOT
    BarFill.BorderSizePixel  = 0
    BarFill.ZIndex           = 17
    BarFill.Parent           = BarBG
    Cr(BarFill, 2)

    -- Loading yazısı
    local LoadingLbl = Lbl(SplashFrame,"Yukleniyor...",10,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
    LoadingLbl.Size     = UDim2.new(1,0,0,14)
    LoadingLbl.Position = UDim2.new(0,0,1,-38)
    LoadingLbl.ZIndex   = 16

    -- ══════════════════════════════════════════════════════
    --  ANA GUI  (EULA kabul edilince açılır)
    -- ══════════════════════════════════════════════════════

    -- Ana çerçeve  580×340  (biraz daha kompakt / yatay)
    local Main = Instance.new("Frame")
    Main.Name             = "Main"
    Main.Size             = UDim2.new(0,580,0,340)
    Main.Position         = UDim2.new(0.5,-290,0.5,-170)
    Main.BackgroundColor3 = Color3.fromRGB(20,4,12)
    Main.BorderSizePixel  = 0
    Main.ClipsDescendants = true
    Main.Visible          = false
    Main.ZIndex           = 10
    Main.Parent           = SG
    Cr(Main, 14)
    St(Main, C.NEON, 2, 0.06)

    -- Arka plan gradient
    local MainGrad = Instance.new("UIGradient")
    MainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(30,5,18)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22,3,13)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(18,2,10)),
    })
    MainGrad.Rotation = 135
    MainGrad.Parent   = Main

    -- ── TopBar ────────────────────────────────────────────
    local TopBar = Instance.new("Frame")
    TopBar.Size             = UDim2.new(1,0,0,38)
    TopBar.BackgroundColor3 = C.DEEP
    TopBar.BorderSizePixel  = 0
    TopBar.ZIndex           = 12
    TopBar.Parent           = Main
    Cr(TopBar, 14)

    local TBGrad = Instance.new("UIGradient")
    TBGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,30,115)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190,0,80)),
    })
    TBGrad.Rotation = 90
    TBGrad.Parent = TopBar

    -- Marka (ortada)
    local BrandLbl = Lbl(TopBar,"S3xy Hub",17,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    BrandLbl.Size   = UDim2.new(1,0,1,0)
    BrandLbl.ZIndex = 13

    -- Kapat butonu
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text             = "x"
    CloseBtn.Size             = UDim2.new(0,26,0,26)
    CloseBtn.Position         = UDim2.new(1,-32,0,6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200,30,80)
    CloseBtn.TextColor3       = C.WHITE
    CloseBtn.Font             = Enum.Font.GothamBold
    CloseBtn.TextSize         = 12
    CloseBtn.BorderSizePixel  = 0
    CloseBtn.ZIndex           = 14
    CloseBtn.Parent           = TopBar
    Cr(CloseBtn, 6)

    -- Küçült butonu
    local MinBtn = Instance.new("TextButton")
    MinBtn.Text             = "-"
    MinBtn.Size             = UDim2.new(0,26,0,26)
    MinBtn.Position         = UDim2.new(1,-62,0,6)
    MinBtn.BackgroundColor3 = C.DARK
    MinBtn.TextColor3       = C.WHITE
    MinBtn.Font             = Enum.Font.GothamBold
    MinBtn.TextSize         = 16
    MinBtn.BorderSizePixel  = 0
    MinBtn.ZIndex           = 14
    MinBtn.Parent           = TopBar
    Cr(MinBtn, 6)

    -- ── Sidebar (sol)  130px ──────────────────────────────
    local SB = Instance.new("Frame")
    SB.Size             = UDim2.new(0,130,1,-38)
    SB.Position         = UDim2.new(0,0,0,38)
    SB.BackgroundColor3 = Color3.fromRGB(14,2,9)
    SB.BorderSizePixel  = 0
    SB.ClipsDescendants = true
    SB.ZIndex           = 11
    SB.Parent           = Main

    -- Sidebar sağ kenara ince çizgi
    local SBLine = Instance.new("Frame")
    SBLine.Size             = UDim2.new(0,1,1,0)
    SBLine.Position         = UDim2.new(1,-1,0,0)
    SBLine.BackgroundColor3 = C.NEON
    SBLine.BackgroundTransparency = 0.6
    SBLine.BorderSizePixel  = 0
    SBLine.ZIndex           = 12
    SBLine.Parent           = SB

    -- ── Player Kutusu ─────────────────────────────────────
    local PBox = Instance.new("Frame")
    PBox.Size             = UDim2.new(1,-10,0,72)
    PBox.Position         = UDim2.new(0,5,0,6)
    PBox.BackgroundColor3 = Color3.fromRGB(30,5,18)
    PBox.BackgroundTransparency = 0.1
    PBox.BorderSizePixel  = 0
    PBox.ZIndex           = 12
    PBox.Parent           = SB
    Cr(PBox, 10)
    St(PBox, C.NEON, 1, 0.55)

    -- Küçük toggle (player kutusunu aç/kapat)
    local PToggle = Instance.new("TextButton")
    PToggle.Text             = "v"
    PToggle.Size             = UDim2.new(0,18,0,14)
    PToggle.Position         = UDim2.new(1,-20,0,4)
    PToggle.BackgroundTransparency = 1
    PToggle.TextColor3       = C.TEXT2
    PToggle.Font             = Enum.Font.GothamBold
    PToggle.TextSize         = 10
    PToggle.BorderSizePixel  = 0
    PToggle.ZIndex           = 13
    PToggle.Parent           = PBox

    local pboxOpen = true

    -- Avatar
    local Av = Instance.new("ImageLabel")
    Av.Size             = UDim2.new(0,36,0,36)
    Av.Position         = UDim2.new(0,6,0.5,-18)
    Av.BackgroundColor3 = C.DARK
    Av.BackgroundTransparency = 0.3
    Av.BorderSizePixel  = 0
    Av.ZIndex           = 13
    Av.Parent           = PBox
    Cr(Av, 7)
    pcall(function()
        Av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
            ..LP.UserId.."&width=150&height=150&format=png"
    end)

    local dname,uname = "Player","unknown"
    pcall(function() dname=LP.DisplayName end)
    pcall(function() uname=LP.Name end)

    local NL = Lbl(PBox,dname,11,C.WHITE,Enum.Font.GothamBold)
    NL.Size=UDim2.new(1,-48,0,15) NL.Position=UDim2.new(0,46,0,14)
    NL.TextTruncate=Enum.TextTruncate.AtEnd NL.ZIndex=13

    local UL = Lbl(PBox,"@"..uname,9,C.TEXT2,Enum.Font.Gotham)
    UL.Size=UDim2.new(1,-48,0,13) UL.Position=UDim2.new(0,46,0,30)
    UL.TextTruncate=Enum.TextTruncate.AtEnd UL.ZIndex=13

    -- Player kutusu aç/kapat
    PToggle.MouseButton1Click:Connect(function()
        pboxOpen = not pboxOpen
        if pboxOpen then
            Tw(PBox,0.2,{Size=UDim2.new(1,-10,0,72)})
            PToggle.Text="v"
        else
            Tw(PBox,0.2,{Size=UDim2.new(1,-10,0,22)})
            PToggle.Text=">"
        end
    end)

    -- Tab buton listesi
    local TBList = Instance.new("Frame")
    TBList.Size             = UDim2.new(1,-10,1,-86)
    TBList.Position         = UDim2.new(0,5,0,82)
    TBList.BackgroundTransparency = 1
    TBList.ClipsDescendants = true
    TBList.ZIndex           = 12
    TBList.Parent           = SB

    local TBLL = Instance.new("UIListLayout")
    TBLL.Padding   = UDim.new(0,4)
    TBLL.SortOrder = Enum.SortOrder.LayoutOrder
    TBLL.Parent    = TBList

    -- ── İçerik Alanı ──────────────────────────────────────
    local CA = Instance.new("Frame")
    CA.Size             = UDim2.new(1,-136,1,-38)
    CA.Position         = UDim2.new(0,134,0,38)
    CA.BackgroundColor3 = Color3.fromRGB(22,4,14)
    CA.BorderSizePixel  = 0
    CA.ClipsDescendants = true
    CA.ZIndex           = 11
    CA.Parent           = Main
    Cr(CA, 10)

    -- ── Drag (sadece TopBar) ──────────────────────────────
    local dragging = false
    local dragOff  = Vector2.new()
    TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragOff=Vector2.new(
                inp.Position.X-Main.AbsolutePosition.X,
                inp.Position.Y-Main.AbsolutePosition.Y)
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement
        and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local vp=Vector2.new(1920,1080)
        pcall(function() vp=workspace.CurrentCamera.ViewportSize end)
        Main.Position=UDim2.new(0,
            math.clamp(inp.Position.X-dragOff.X,0,vp.X-580),0,
            math.clamp(inp.Position.Y-dragOff.Y,0,vp.Y-340))
    end)

    -- ── Küçült / Büyüt ────────────────────────────────────
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tw(Main,0.25,{Size=UDim2.new(0,580,0,38)})
            MinBtn.Text="+"
        else
            Tw(Main,0.3,{Size=UDim2.new(0,580,0,340)})
            MinBtn.Text="-"
        end
    end)

    -- ── Kapat / Aç butonu ─────────────────────────────────
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Text             = "S3xy Hub"
    OpenBtn.Size             = UDim2.new(0,80,0,24)
    OpenBtn.Position         = UDim2.new(0,10,1,-34)
    OpenBtn.BackgroundColor3 = C.DEEP
    OpenBtn.TextColor3       = C.WHITE
    OpenBtn.Font             = Enum.Font.GothamBold
    OpenBtn.TextSize         = 11
    OpenBtn.BorderSizePixel  = 0
    OpenBtn.Visible          = false
    OpenBtn.ZIndex           = 10
    OpenBtn.Parent           = SG
    Cr(OpenBtn, 6)
    St(OpenBtn, C.NEON, 1.5, 0.2)

    CloseBtn.MouseButton1Click:Connect(function()
        Tw(Main,0.25,{Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0,Main.AbsolutePosition.X+290,0,Main.AbsolutePosition.Y+170)})
        task.delay(0.27,function() Main.Visible=false OpenBtn.Visible=true end)
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible=false Main.Visible=true
        Main.Size=UDim2.new(0,0,0,0)
        Main.Position=UDim2.new(0.5,0,0.5,0)
        TwBounce(Main,0.45,{Size=UDim2.new(0,580,0,340),Position=UDim2.new(0.5,-290,0.5,-170)})
    end)

    -- ══════════════════════════════════════════════════════
    --  ÖZELLEŞTIRME PANELI  (tab listesinin altında)
    -- ══════════════════════════════════════════════════════
    -- Gear butonu
    local GearBtn = Instance.new("TextButton")
    GearBtn.Text             = "⚙"
    GearBtn.Size             = UDim2.new(1,-10,0,26)
    GearBtn.Position         = UDim2.new(0,5,1,-30)
    GearBtn.BackgroundColor3 = Color3.fromRGB(25,5,15)
    GearBtn.BackgroundTransparency = 0.3
    GearBtn.TextColor3       = C.TEXT2
    GearBtn.Font             = Enum.Font.GothamBold
    GearBtn.TextSize         = 13
    GearBtn.BorderSizePixel  = 0
    GearBtn.ZIndex           = 12
    GearBtn.Parent           = SB
    Cr(GearBtn,6)

    -- Özelleştirme paneli (içerik alanı üstüne overlay)
    local CustPanel = Instance.new("Frame")
    CustPanel.Size             = UDim2.new(1,0,1,0)
    CustPanel.BackgroundColor3 = Color3.fromRGB(14,2,9)
    CustPanel.BorderSizePixel  = 0
    CustPanel.Visible          = false
    CustPanel.ZIndex           = 20
    CustPanel.Parent           = CA
    Cr(CustPanel, 10)

    local CustTitle = Lbl(CustPanel,"Ozellestirme",15,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    CustTitle.Size=UDim2.new(1,0,0,38) CustTitle.ZIndex=21

    local CustClose = Instance.new("TextButton")
    CustClose.Text="Geri" CustClose.Size=UDim2.new(0,60,0,24)
    CustClose.Position=UDim2.new(1,-68,0,7)
    CustClose.BackgroundColor3=C.DARK CustClose.TextColor3=C.WHITE
    CustClose.Font=Enum.Font.GothamSemibold CustClose.TextSize=11
    CustClose.BorderSizePixel=0 CustClose.ZIndex=22 CustClose.Parent=CustPanel
    Cr(CustClose,6)

    -- Özelleştirme seçenekleri
    local custItems = {
        {label="Arka Plan",   key="bg"},
        {label="Neon Rengi",  key="neon"},
        {label="Boyut",       key="size"},
    }
    local custColors = {
        {name="Pembe",  col=Color3.fromRGB(255,20,110)},
        {name="Kirmizi",col=Color3.fromRGB(220,30,50)},
        {name="Mor",    col=Color3.fromRGB(140,30,220)},
        {name="Mavi",   col=Color3.fromRGB(30,100,255)},
        {name="Yesil",  col=Color3.fromRGB(20,200,100)},
    }

    -- Renk seçici (basit butonlar)
    local custSub = Lbl(CustPanel,"Ana Renk Sec:",12,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Left)
    custSub.Size=UDim2.new(1,-20,0,16) custSub.Position=UDim2.new(0,10,0,44) custSub.ZIndex=21

    local colorRow = Instance.new("Frame")
    colorRow.Size=UDim2.new(1,-20,0,30) colorRow.Position=UDim2.new(0,10,0,62)
    colorRow.BackgroundTransparency=1 colorRow.ZIndex=21 colorRow.Parent=CustPanel

    for i,cc in ipairs(custColors) do
        local cb2 = Instance.new("TextButton")
        cb2.Text="" cb2.Size=UDim2.new(0,28,0,28)
        cb2.Position=UDim2.new(0,(i-1)*34,0,0)
        cb2.BackgroundColor3=cc.col cb2.BorderSizePixel=0
        cb2.ZIndex=22 cb2.Parent=colorRow
        Cr(cb2,14)
        cb2.MouseButton1Click:Connect(function()
            C.HOT=cc.col C.NEON=cc.col C.DEEP=cc.col
            TopBar.BackgroundColor3=cc.col
            Main.BorderSizePixel=0
            pcall(function() TBGrad.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,cc.col),
                ColorSequenceKeypoint.new(1,Color3.new(cc.col.R*0.65,cc.col.G*0.65,cc.col.B*0.65)),
            }) end)
        end)
    end

    -- Boyut seçici
    local sizeSub = Lbl(CustPanel,"Pencere Boyutu:",12,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Left)
    sizeSub.Size=UDim2.new(1,-20,0,16) sizeSub.Position=UDim2.new(0,10,0,102) sizeSub.ZIndex=21

    local sizeRow = Instance.new("Frame")
    sizeRow.Size=UDim2.new(1,-20,0,30) sizeRow.Position=UDim2.new(0,10,0,120)
    sizeRow.BackgroundTransparency=1 sizeRow.ZIndex=21 sizeRow.Parent=CustPanel

    local sizes = {{n="Kucuk",w=480,h=280},{n="Normal",w=580,h=340},{n="Buyuk",w=700,h=420}}
    for i,sz in ipairs(sizes) do
        local sb = Instance.new("TextButton")
        sb.Text=sz.n sb.Size=UDim2.new(0,86,0,26)
        sb.Position=UDim2.new(0,(i-1)*92,0,0)
        sb.BackgroundColor3=C.DARKEST sb.TextColor3=C.TEXT2
        sb.Font=Enum.Font.GothamSemibold sb.TextSize=11
        sb.BorderSizePixel=0 sb.ZIndex=22 sb.Parent=sizeRow
        Cr(sb,6)
        sb.MouseButton1Click:Connect(function()
            TwBounce(Main,0.3,{
                Size=UDim2.new(0,sz.w,0,sz.h),
                Position=UDim2.new(0.5,-sz.w/2,0.5,-sz.h/2)
            })
        end)
    end

    GearBtn.MouseButton1Click:Connect(function()
        CustPanel.Visible = true
    end)
    CustClose.MouseButton1Click:Connect(function()
        CustPanel.Visible = false
    end)

    -- ══════════════════════════════════════════════════════
    --  EULA KABUL → SPLASH → MAIN
    -- ══════════════════════════════════════════════════════
    EulaAccept.MouseButton1Click:Connect(function()
        -- EULA kapat
        Tw(EulaFrame,0.3,{BackgroundTransparency=1,Size=UDim2.new(0,440,0,0)})
        task.delay(0.32,function()
            EulaFrame.Visible=false

            -- Splash aç
            SplashFrame.Visible=true
            SplashFrame.Size=UDim2.new(0,0,0,0)
            SplashFrame.Position=UDim2.new(0.5,0,0.5,0)
            TwBounce(SplashFrame,0.5,{
                Size=UDim2.new(0,380,0,200),
                Position=UDim2.new(0.5,-190,0.5,-100)
            })

            -- Loading bar animasyonu
            local steps = {
                {t=0.4,  txt="Baslatiliyor..."},
                {t=0.25, txt="Player bilgileri aliniyor..."},
                {t=0.25, txt="Moduller yukleniyor..."},
                {t=0.25, txt="Arayuz hazirlaniyor..."},
                {t=0.2,  txt="Hazir!"},
            }
            local totalFill = 0
            for i,step in ipairs(steps) do
                task.wait(0.45)
                LoadingLbl.Text = step.txt
                totalFill = totalFill + step.t
                Tw(BarFill,0.35,{Size=UDim2.new(totalFill,0,1,0)})
            end

            task.wait(0.5)
            -- Splash kapat, main aç
            Tw(SplashFrame,0.3,{BackgroundTransparency=1})
            task.delay(0.32,function()
                SplashFrame.Visible=false
                -- Main aç
                Main.Visible=true
                Main.Size=UDim2.new(0,0,0,0)
                Main.Position=UDim2.new(0.5,0,0.5,0)
                TwBounce(Main,0.5,{
                    Size=UDim2.new(0,580,0,340),
                    Position=UDim2.new(0.5,-290,0.5,-170)
                })
            end)
        end)
    end)

    -- ══════════════════════════════════════════════════════
    --  TAB SİSTEMİ
    -- ══════════════════════════════════════════════════════
    local tabs     = {}
    local tabCount = 0

    local function ActivateTab(idx)
        for i,t in ipairs(tabs) do
            if i==idx then
                Tw(t.btn,0.12,{BackgroundTransparency=0})
                t.btn.TextColor3=Color3.fromRGB(18,3,11)
                t.page.Visible=true
            else
                Tw(t.btn,0.12,{BackgroundTransparency=0.6})
                t.btn.TextColor3=C.TEXT2
                t.page.Visible=false
            end
        end
    end

    local Win = {}

    function Win:AddTab(name)
        tabCount=tabCount+1
        local idx=tabCount

        local TBtn=Instance.new("TextButton")
        TBtn.Text=name TBtn.Size=UDim2.new(1,0,0,28)
        TBtn.BackgroundColor3=C.WHITE TBtn.BackgroundTransparency=0.6
        TBtn.TextColor3=C.TEXT2 TBtn.Font=Enum.Font.GothamSemibold
        TBtn.TextSize=11 TBtn.BorderSizePixel=0 TBtn.LayoutOrder=idx
        TBtn.ZIndex=12 TBtn.Parent=TBList
        Cr(TBtn,6)

        local Page=Instance.new("ScrollingFrame")
        Page.Size=UDim2.new(1,-8,1,-8) Page.Position=UDim2.new(0,4,0,4)
        Page.BackgroundTransparency=1 Page.BorderSizePixel=0
        Page.ScrollBarThickness=2 Page.ScrollBarImageColor3=C.NEON
        Page.CanvasSize=UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize=Enum.AutomaticSize.Y
        Page.Visible=false Page.ZIndex=12 Page.Parent=CA

        local PL=Instance.new("UIListLayout")
        PL.Padding=UDim.new(0,6) PL.SortOrder=Enum.SortOrder.LayoutOrder PL.Parent=Page

        local PP=Instance.new("UIPadding")
        PP.PaddingLeft=UDim.new(0,4) PP.PaddingRight=UDim.new(0,4)
        PP.PaddingTop=UDim.new(0,4) PP.Parent=Page

        table.insert(tabs,{btn=TBtn,page=Page})
        TBtn.MouseButton1Click:Connect(function() ActivateTab(idx) end)
        if idx==1 then ActivateTab(1) end

        local Tab={}
        local eCount=0
        local function EBox(h)
            eCount=eCount+1
            local b=Instance.new("Frame")
            b.Size=UDim2.new(1,-2,0,h)
            b.BackgroundColor3=Color3.fromRGB(28,5,17)
            b.BackgroundTransparency=0.1
            b.BorderSizePixel=0 b.LayoutOrder=eCount
            b.ZIndex=13 b.Parent=Page
            Cr(b,7)
            return b
        end

        -- AddSlider
        function Tab:AddSlider(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Slider"
            local minV=cfg.Min or 0
            local maxV=cfg.Max or 100
            local def=math.clamp(cfg.Default or 50,cfg.Min or 0,cfg.Max or 100)
            local cb=cfg.Callback
            local box=EBox(62)

            local TL=Lbl(box,lbl,11,C.WHITE,Enum.Font.GothamSemibold)
            TL.Size=UDim2.new(0.65,0,0,16) TL.Position=UDim2.new(0,9,0,5) TL.ZIndex=14

            local VL=Lbl(box,tostring(def),11,C.TEXT2,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
            VL.Size=UDim2.new(0.3,0,0,16) VL.Position=UDim2.new(0.68,0,0,5) VL.ZIndex=14

            local Track=Instance.new("Frame")
            Track.Size=UDim2.new(1,-16,0,6) Track.Position=UDim2.new(0,8,0,34)
            Track.BackgroundColor3=C.DARKEST Track.BorderSizePixel=0
            Track.ZIndex=14 Track.Parent=box
            Cr(Track,3)

            local Fill=Instance.new("Frame")
            Fill.Size=UDim2.new((def-minV)/(maxV-minV),0,1,0)
            Fill.BackgroundColor3=C.HOT Fill.BorderSizePixel=0
            Fill.ZIndex=15 Fill.Parent=Track
            Cr(Fill,3)

            local FG=Instance.new("UIGradient")
            FG.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,80,160)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(255,20,100)),
            })
            FG.Parent=Fill

            local Knob=Instance.new("Frame")
            Knob.Size=UDim2.new(0,13,0,13) Knob.AnchorPoint=Vector2.new(0.5,0.5)
            Knob.Position=UDim2.new((def-minV)/(maxV-minV),0,0.5,0)
            Knob.BackgroundColor3=C.WHITE Knob.BorderSizePixel=0
            Knob.ZIndex=16 Knob.Parent=Track
            Cr(Knob,7) St(Knob,C.NEON,2,0.1)

            local sliding=false
            local function applyX(x)
                local rel=math.clamp((x-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                local val=math.round(minV+rel*(maxV-minV))
                Fill.Size=UDim2.new(rel,0,1,0)
                Knob.Position=UDim2.new(rel,0,0.5,0)
                VL.Text=tostring(val)
                if cb then pcall(cb,val) end
            end
            Track.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1
                or inp.UserInputType==Enum.UserInputType.Touch then
                    sliding=true applyX(inp.Position.X)
                    Tw(Knob,0.07,{Size=UDim2.new(0,17,0,17)})
                    inp.Changed:Connect(function()
                        if inp.UserInputState==Enum.UserInputState.End then
                            sliding=false Tw(Knob,0.07,{Size=UDim2.new(0,13,0,13)}) end
                    end)
                end
            end)
            UIS.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType==Enum.UserInputType.MouseMovement
                or inp.UserInputType==Enum.UserInputType.Touch then applyX(inp.Position.X) end
            end)
            UIS.InputEnded:Connect(function(inp)
                if (inp.UserInputType==Enum.UserInputType.MouseButton1
                or inp.UserInputType==Enum.UserInputType.Touch) and sliding then
                    sliding=false Tw(Knob,0.07,{Size=UDim2.new(0,13,0,13)}) end
            end)
            return {SetValue=function(v)
                v=math.clamp(v,minV,maxV)
                local r=(v-minV)/(maxV-minV)
                Fill.Size=UDim2.new(r,0,1,0)
                Knob.Position=UDim2.new(r,0,0.5,0)
                VL.Text=tostring(math.round(v))
                if cb then pcall(cb,v) end
            end}
        end

        -- AddToggle
        function Tab:AddToggle(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Toggle"
            local def=cfg.Default or false
            local cb=cfg.Callback
            local box=EBox(40)
            local state=def

            local TL=Lbl(box,lbl,11,C.WHITE,Enum.Font.GothamSemibold)
            TL.Size=UDim2.new(0.7,0,1,0) TL.Position=UDim2.new(0,9,0,0) TL.ZIndex=14

            local Trk=Instance.new("Frame")
            Trk.Size=UDim2.new(0,36,0,18) Trk.Position=UDim2.new(1,-44,0.5,-9)
            Trk.BackgroundColor3=state and C.HOT or C.DARKEST
            Trk.BorderSizePixel=0 Trk.ZIndex=14 Trk.Parent=box
            Cr(Trk,9)

            local Thumb=Instance.new("Frame")
            Thumb.Size=UDim2.new(0,12,0,12)
            Thumb.Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
            Thumb.BackgroundColor3=C.WHITE Thumb.BorderSizePixel=0
            Thumb.ZIndex=15 Thumb.Parent=Trk
            Cr(Thumb,6)

            local function SS(s)
                state=s
                Tw(Trk,0.16,{BackgroundColor3=s and C.HOT or C.DARKEST})
                Tw(Thumb,0.16,{Position=s and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)})
                if cb then pcall(cb,s) end
            end
            box.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then SS(not state) end
            end)
            return {SetValue=function(v) SS(v) end, GetValue=function() return state end}
        end

        -- AddButton
        function Tab:AddButton(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Buton"
            local cb=cfg.Callback
            local box=EBox(34) box.BackgroundTransparency=1

            local Btn=Instance.new("TextButton")
            Btn.Text=lbl Btn.Size=UDim2.new(1,0,1,0)
            Btn.BackgroundColor3=C.HOT Btn.TextColor3=C.WHITE
            Btn.Font=Enum.Font.GothamBold Btn.TextSize=12
            Btn.BorderSizePixel=0 Btn.LayoutOrder=eCount
            Btn.ZIndex=14 Btn.Parent=box
            Cr(Btn,7)

            Btn.MouseButton1Click:Connect(function()
                Tw(Btn,0.07,{BackgroundColor3=Color3.fromRGB(255,100,170)})
                task.delay(0.12,function() Tw(Btn,0.1,{BackgroundColor3=C.HOT}) end)
                if cb then pcall(cb) end
            end)
        end

        -- AddLabel
        function Tab:AddLabel(text)
            local box=EBox(28)
            local l=Lbl(box,text,10,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,-12,1,0) l.Position=UDim2.new(0,6,0,0) l.ZIndex=14
        end

        -- AddSection
        function Tab:AddSection(text)
            local box=EBox(20) box.BackgroundTransparency=0.6
            local l=Lbl(box,"-- "..text.." --",10,C.NEON,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,0,1,0) l.ZIndex=14
        end

        return Tab
    end -- AddTab

    return Win
end -- CreateWindow

return Lib

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  XENO TEST  —  direk yapistir veya loadstring ile yukle
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Hub = loadstring(game:HttpGet("RAW_LINK"))()

local Win = Hub:CreateWindow({
    Title    = "Benim Script",
    SubTitle = "v1.0  by Sen"
})

local Kar = Win:AddTab("Karakter")
Kar:AddSection("Hareket")
Kar:AddSlider({ Name="Hiz", Min=1, Max=200, Default=16,
    Callback=function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v
    end})
Kar:AddSlider({ Name="Ziplama", Min=1, Max=300, Default=50,
    Callback=function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower=v
    end})
Kar:AddToggle({ Name="Sonsuz Ziplama", Default=false,
    Callback=function(s)
        if s then
            _G.IJ=game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character.Humanoid
                    :ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        elseif _G.IJ then _G.IJ:Disconnect() end
    end})
Kar:AddButton({ Name="Reset Karakter",
    Callback=function()
        game.Players.LocalPlayer.Character.Humanoid.Health=0
    end})

local Vis = Win:AddTab("Grafik")
Vis:AddSlider({Name="FOV", Min=30,Max=120,Default=70,
    Callback=function(v) workspace.CurrentCamera.FieldOfView=v end})
Vis:AddSlider({Name="Yercekimi", Min=10,Max=300,Default=196,
    Callback=function(v) workspace.Gravity=v end})

]]
