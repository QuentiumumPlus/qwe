--[[
╔══════════════════════════════════════════════════════════════╗
║                    S3xy Hub  v6.0                            ║
║  Xeno / Solara / Delta / Synapse uyumlu  |  gethui()         ║
║  EULA → Splash → GUI  |  Pixel Font  |  18 Dil              ║
╚══════════════════════════════════════════════════════════════╝

KULLANIM:
    local Hub = loadstring(game:HttpGet("RAW_LINK"))()
    local Win = Hub:CreateWindow({
        Title    = "My Script",
        SubTitle = "v1.0",
        Language = "TR",   -- TR EN DE FR ES IT PT RU ZH JA KO AR PL NL SV NO DA FI
    })
    local Tab = Win:AddTab("Karakter")
    Tab:AddSlider({ Name="Hız", Min=1, Max=200, Default=16,
        Callback=function(v)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end })
]]

-- ════════════════════════════════════════════════════════════
--  SERVİSLER
-- ════════════════════════════════════════════════════════════
local Players  = game:GetService("Players")
local UIS      = game:GetService("UserInputService")
local TS       = game:GetService("TweenService")
local RS       = game:GetService("RunService")

-- ════════════════════════════════════════════════════════════
--  LOCAL PLAYER
-- ════════════════════════════════════════════════════════════
local LP
repeat pcall(function() LP = Players.LocalPlayer end)
      if not LP then RS.Heartbeat:Wait() end
until LP

-- ════════════════════════════════════════════════════════════
--  CONTAINER
-- ════════════════════════════════════════════════════════════
local function GetContainer()
    if typeof(gethui)=="function" then
        local ok,h = pcall(gethui) ; if ok and h then return h end
    end
    local ok,cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    local ok2,pg = pcall(function() return LP:WaitForChild("PlayerGui",5) end)
    if ok2 and pg then return pg end
end

-- ════════════════════════════════════════════════════════════
--  DİL PAKETLERİ
-- ════════════════════════════════════════════════════════════
local LANGS={
TR={accept="KABUL ET",deny="REDDET",loading="YUKLENIYOR",settings="AYARLAR",
    close="X",minimize="-",playerinfo="OYUNCU",back="GERI",
    colorpick="RENK SEC",windowsize="PENCERE BOYUTU",
    small="KUCUK",normal="NORMAL",large="BUYUK",
    eula_title="KULLANICI SOZLESMESI",
    eula_body=[[Bu yazilimi kullanarak asagidaki kosullari kabul edersiniz:

 [1] Yalnizca kisisel ve egitim amacli kullanim.
 [2] Baska oyunculara zarar vermek yasaktir.
 [3] Ban riskini tamamen siz ustlenirsiniz.
 [4] Gelistirici hicbir zarardan sorumlu tutulamaz.
 [5] +18 icerik icermektedir; kullanici 18+ olmalidir.
 [6] Dagitmak veya satmak kesinlikle yasaktir.

Devam ederek tum kosullari kabul etmis sayilirsiniz.]],
    steps={"[>] Baslatiliyor...","[>] Oyuncu bilgisi aliniyor...","[>] Moduller yukleniyor...","[>] Arayuz olusturuluyor...","[>] HAZIR!"}},

EN={accept="ACCEPT",deny="DECLINE",loading="LOADING",settings="SETTINGS",
    close="X",minimize="-",playerinfo="PLAYER",back="BACK",
    colorpick="PICK COLOR",windowsize="WINDOW SIZE",
    small="SMALL",normal="NORMAL",large="LARGE",
    eula_title="USER AGREEMENT",
    eula_body=[[By using this software you agree to the following:

 [1] Personal and educational use only.
 [2] Harming other players is strictly forbidden.
 [3] You assume full responsibility for account bans.
 [4] Developer holds no liability for any damage.
 [5] Contains 18+ content; users must be 18 or older.
 [6] Redistribution or sale is not permitted.

Continuing confirms you have read and accepted all terms.]],
    steps={"[>] Starting...","[>] Loading player...","[>] Loading modules...","[>] Building UI...","[>] READY!"}},

DE={accept="AKZEPTIEREN",deny="ABLEHNEN",loading="LADEN",settings="EINSTELLUNGEN",
    close="X",minimize="-",playerinfo="SPIELER",back="ZURUCK",
    colorpick="FARBE WAHLEN",windowsize="FENSTERGROSSE",
    small="KLEIN",normal="NORMAL",large="GROSS",
    eula_title="NUTZUNGSVEREINBARUNG",
    eula_body=[[Durch Nutzung dieser Software stimmst du zu:

 [1] Nur persoenliche und Bildungsnutzung.
 [2] Verwendung zum Schaden anderer ist verboten.
 [3] Du traegst das volle Risiko fuer Account-Sperren.
 [4] Entwickler haftet nicht fuer entstandene Schaeden.
 [5] Enthaelt 18+ Inhalte; Benutzer muss 18+ sein.
 [6] Weiterverbreitung ist nicht gestattet.]],
    steps={"[>] Starte...","[>] Spieler laden...","[>] Module laden...","[>] UI erstellen...","[>] FERTIG!"}},

FR={accept="ACCEPTER",deny="REFUSER",loading="CHARGEMENT",settings="PARAMETRES",
    close="X",minimize="-",playerinfo="JOUEUR",back="RETOUR",
    colorpick="COULEUR",windowsize="TAILLE FENETRE",
    small="PETIT",normal="NORMAL",large="GRAND",
    eula_title="ACCORD UTILISATEUR",
    eula_body=[[En utilisant ce logiciel vous acceptez:

 [1] Usage personnel et educatif uniquement.
 [2] Nuire a d'autres joueurs est interdit.
 [3] Vous assumez la responsabilite des bannissements.
 [4] Developpeur non responsable de tout dommage.
 [5] Contenu 18+; les utilisateurs doivent avoir 18+.
 [6] Redistribution ou vente strictement interdite.]],
    steps={"[>] Demarrage...","[>] Joueur...","[>] Modules...","[>] Interface...","[>] PRET!"}},

ES={accept="ACEPTAR",deny="RECHAZAR",loading="CARGANDO",settings="AJUSTES",
    close="X",minimize="-",playerinfo="JUGADOR",back="VOLVER",
    colorpick="COLOR",windowsize="TAMANO VENTANA",
    small="PEQUENO",normal="NORMAL",large="GRANDE",
    eula_title="ACUERDO DE USUARIO",
    eula_body=[[Al usar este software aceptas:

 [1] Solo para uso personal y educativo.
 [2] Daniar a otros jugadores esta prohibido.
 [3] Asumes responsabilidad por baneos.
 [4] El desarrollador no se responsabiliza de danos.
 [5] Contenido 18+; debes tener 18 o mas.
 [6] Redistribucion o venta prohibida.]],
    steps={"[>] Iniciando...","[>] Jugador...","[>] Modulos...","[>] UI...","[>] LISTO!"}},

IT={accept="ACCETTA",deny="RIFIUTA",loading="CARICAMENTO",settings="IMPOSTAZIONI",
    close="X",minimize="-",playerinfo="GIOCATORE",back="INDIETRO",
    colorpick="COLORE",windowsize="DIM. FINESTRA",
    small="PICCOLO",normal="NORMALE",large="GRANDE",
    eula_title="ACCORDO UTENTE",
    eula_body=[[Usando questo software accetti:

 [1] Solo uso personale ed educativo.
 [2] Danneggiare altri giocatori e vietato.
 [3] Assumi piena responsabilita per i ban.
 [4] Sviluppatore non responsabile di danni.
 [5] Contiene 18+; devi avere almeno 18 anni.
 [6] Redistribuzione o vendita vietata.]],
    steps={"[>] Avvio...","[>] Giocatore...","[>] Moduli...","[>] UI...","[>] PRONTO!"}},

PT={accept="ACEITAR",deny="RECUSAR",loading="CARREGANDO",settings="CONFIGURACOES",
    close="X",minimize="-",playerinfo="JOGADOR",back="VOLTAR",
    colorpick="COR",windowsize="TAMANHO JANELA",
    small="PEQUENO",normal="NORMAL",large="GRANDE",
    eula_title="ACORDO DO USUARIO",
    eula_body=[[Ao usar este software voce concorda:

 [1] Apenas para uso pessoal e educacional.
 [2] Prejudicar outros jogadores e proibido.
 [3] Voce assume responsabilidade por banimentos.
 [4] Desenvolvedor nao e responsavel por danos.
 [5] Conteudo 18+; voce deve ter 18 ou mais.
 [6] Redistribuicao ou venda e proibida.]],
    steps={"[>] Iniciando...","[>] Jogador...","[>] Modulos...","[>] UI...","[>] PRONTO!"}},

RU={accept="PRINYAT",deny="OTKLONIT",loading="ZAGRUZKA",settings="NASTROYKI",
    close="X",minimize="-",playerinfo="IGROK",back="NAZAD",
    colorpick="VYBOR CVETA",windowsize="RAZMER OKNA",
    small="MALEN",normal="NORMAL",large="BOLSHOY",
    eula_title="POLZOVATELSKOE SOGLASHENIE",
    eula_body=[[Ispolzuya eto PO, vy soglashaetes:

 [1] Tolko dlya lichnogo i uchebnogo ispolzovaniya.
 [2] Ispolzovanie dlya vreda drugim zapreshcheno.
 [3] Vy nesete polnuyu otvetstvennost za ban.
 [4] Razrabotchik ne neset otvetstvennosti za ushcherb.
 [5] Soderzhit kontент 18+; polzovatelu dolzhno byt 18+.
 [6] Rasprostranenie ili prodazha zapreshcheny.]],
    steps={"[>] Zapusk...","[>] Igrok...","[>] Moduli...","[>] UI...","[>] GOTOVO!"}},

ZH={accept="JIESHOU",deny="JUJUE",loading="JIAZAIZHONG",settings="SHEZHI",
    close="X",minimize="-",playerinfo="WANJIA",back="FANHUI",
    colorpick="XUANZE YANSE",windowsize="CHUANGKOU DAXIAO",
    small="XIAO",normal="ZHONGDENG",large="DA",
    eula_title="YONGHU XIEYI",
    eula_body=[[Shiyong ben ruanjian ji biaoshi tongyi yixia tiaokuan:

 [1] Jin gong geren he jiaoyu yongtu.
 [2] Jinzhi yong yu shanghai qita wanjia.
 [3] Nin duizhanghu feng禁fengxian chengdan quanze.
 [4] Kaifazhe bu dui renhezunsun fuzhe.
 [5] Baohani 18+ neirong; yonghu bixu man 18 sui.
 [6] Yan jin zaifahuozhe chushou.]],
    steps={"[>] Qidong...","[>] Wanjia...","[>] Mokuai...","[>] Jiemian...","[>] JIUXU!"}},

JA={accept="DOISURU",deny="KYOHI",loading="YOMIKOMI",settings="SETTEI",
    close="X",minimize="-",playerinfo="PLAYER",back="MODORU",
    colorpick="IRO SENTAKU",windowsize="WINDOW SAIZU",
    small="SHO",normal="HYOJUN",large="DAI",
    eula_title="RIYOU KIYAKU",
    eula_body=[[Kono sofutouea wo shiyousuru koto de doui shimasu:

 [1] Kojin oyobi kyouiku mokuteki nomi.
 [2] Hoka no pureyaa wo kizutsukeru koto wa kinshi.
 [3] Akaunuto no ban risk wa jiko sekinin desu.
 [4] Kaihatsusha wa ika naru songai ni mo sekinin nashi.
 [5] 18+ kontentsu wo fukumimasu; 18sai ijou gentei.
 [6] Saihaifuu mata wa hanbai wa genkini kinshisareteimasu.]],
    steps={"[>] Kidochu...","[>] Pureyaa...","[>] Mojiuru...","[>] UI...","[>] KANRYO!"}},

KO={accept="DONGUI",deny="GEOBU",loading="RODINGCHUNG",settings="SEOLJEONG",
    close="X",minimize="-",playerinfo="PEULLEIEO",back="DWIРО",
    colorpick="SAEKSANG SEONTAEK",windowsize="CHANG KEUGI",
    small="JAG-EUG",normal="BOTONG",large="KEUGE",
    eula_title="IYONG YAKGWAN",
    eula_body=[[I software reul sayong hameu rosseo dongui hamnida:

 [1] Gaeyin mich gyoyuk mokjeog euro man sayong.
 [2] Dareun peulleieoleul haechineun geos eun geumji.
 [3] Gyejong ben eui wiheom eun jeonjeog euro bon in budam.
 [4] Gaebalja neun eoddeon sonsange do chaegim ji ji anhseubnida.
 [5] 18+ contents reul poham; 18se iisang ieo ya ham.
 [6] Jaebaepohaneun geos eun eomgyeoghige geumjiimbnida.]],
    steps={"[>] Sijak...","[>] Peulleieo...","[>] Mojul...","[>] UI...","[>] JUNBI WANRYO!"}},

AR={accept="QABUL",deny="RAFD",loading="TAHMILL",settings="IIDADAT",
    close="X",minimize="-",playerinfo="LAIB",back="RUJU",
    colorpick="IKHTIAR LAWN",windowsize="HAJM NAFIIDHA",
    small="SAGHIIR",normal="AADIIY",large="KABIIR",
    eula_title="IITIFAQIAT ALMUSTAKHDAM",
    eula_body=[[Biastikhdamik lhadha albarnamaj fanta tuafiq ala:

 [1] Lilaistikhdam alshakhsii waltaelimii faqat.
 [2] Yuhzar aistikhdam lil'iidrar bil'akharin.
 [3] Tatahmal mas'uliat hadhf alhisab.
 [4] Almutatawwir ghayr mas'ul ean 'ay darar.
 [5] Yahtawi mahtwaa 18+; yajib 'an yakun 18+.
 [6] 'iiadat altawzie aw albie mahzurat.]],
    steps={"[>] Bada...","[>] Laib...","[>] Modulat...","[>] UI...","[>] JAHIZ!"}},

PL={accept="AKCEPTUJ",deny="ODRZUC",loading="LADOWANIE",settings="USTAWIENIA",
    close="X",minimize="-",playerinfo="GRACZ",back="WRÓC",
    colorpick="WYBIERZ KOLOR",windowsize="ROZMIAR OKNA",
    small="MALY",normal="NORMALNY",large="DUZY",
    eula_title="UMOWA UZYTKOWNIKA",
    eula_body=[[Korzystajac z tego oprogramowania akceptujesz:

 [1] Tylko do uzytku osobistego i edukacyjnego.
 [2] Uzywanie do krzywdzenia graczy jest zabronione.
 [3] Ponosisz pelna odpowiedzialnosc za bany.
 [4] Deweloper nie odpowiada za zadne szkody.
 [5] Zawartosc 18+; musisz miec 18 lat.
 [6] Redystrybucja lub sprzedaz jest surowo zabroniona.]],
    steps={"[>] Uruchamianie...","[>] Gracz...","[>] Moduly...","[>] UI...","[>] GOTOWE!"}},

NL={accept="ACCEPTEREN",deny="WEIGEREN",loading="LADEN",settings="INSTELLINGEN",
    close="X",minimize="-",playerinfo="SPELER",back="TERUG",
    colorpick="KLEUR KIEZEN",windowsize="VENSTERGROOTTE",
    small="KLEIN",normal="NORMAAL",large="GROOT",
    eula_title="GEBRUIKERSOVEREENKOMST",
    eula_body=[[Door deze software te gebruiken ga je akkoord met:

 [1] Alleen persoonlijk en educatief gebruik.
 [2] Gebruik om anderen te schaden is verboden.
 [3] Je draagt verantwoordelijkheid voor accountbans.
 [4] Ontwikkelaar is niet aansprakelijk voor schade.
 [5] Bevat 18+ inhoud; gebruikers moeten 18+ zijn.
 [6] Herdistributie of verkoop is verboden.]],
    steps={"[>] Starten...","[>] Speler...","[>] Modules...","[>] UI...","[>] KLAAR!"}},

SV={accept="ACCEPTERA",deny="NEKA",loading="LADDAR",settings="INSTALLNINGAR",
    close="X",minimize="-",playerinfo="SPELARE",back="TILLBAKA",
    colorpick="VALJ FARG",windowsize="FONSTERSTORLEK",
    small="LITEN",normal="NORMAL",large="STOR",
    eula_title="ANVANDARAVTAL",
    eula_body=[[Genom att anvanda programvaran godkanner du:

 [1] Endast for personligt och utbildningssyfte.
 [2] Anvandning for att skada andra ar forbjudet.
 [3] Du tar fullt ansvar for kontoavstangningar.
 [4] Utvecklaren ansvarar inte for skador.
 [5] Innehaller 18+ innehall; du maste vara 18+.
 [6] Vidaredistribution eller forsaljning ar forbjudet.]],
    steps={"[>] Startar...","[>] Spelare...","[>] Moduler...","[>] UI...","[>] KLAR!"}},

NO={accept="GODTA",deny="AVSLA",loading="LASTER",settings="INNSTILLINGER",
    close="X",minimize="-",playerinfo="SPILLER",back="TILBAKE",
    colorpick="VELG FARGE",windowsize="VINDUSSTORRELSE",
    small="LITEN",normal="NORMAL",large="STOR",
    eula_title="BRUKERAVTALE",
    eula_body=[[Ved a bruke programvaren godtar du:

 [1] Kun personlig og utdanningsmessig bruk.
 [2] Bruk for a skade andre spillere er forbudt.
 [3] Du tar fullt ansvar for kontoutestengelser.
 [4] Utvikleren er ikke ansvarlig for skader.
 [5] Inneholder 18+ innhold; du ma vare 18+.
 [6] Videredistribusjon eller salg er forbudt.]],
    steps={"[>] Starter...","[>] Spiller...","[>] Moduler...","[>] UI...","[>] KLAR!"}},

DA={accept="ACCEPTER",deny="AFVIS",loading="INDLAESER",settings="INDSTILLINGER",
    close="X",minimize="-",playerinfo="SPILLER",back="TILBAGE",
    colorpick="VAELG FARVE",windowsize="VINDUESSTORRELSE",
    small="LILLE",normal="NORMAL",large="STOR",
    eula_title="BRUGERAFTALE",
    eula_body=[[Ved at bruge softwaren accepterer du:

 [1] Kun til personlig og uddannelsesmaessig brug.
 [2] Brug til at skade andre spillere er forbudt.
 [3] Du tager fuldt ansvar for kontobaneringer.
 [4] Udvikleren er ikke ansvarlig for skader.
 [5] Indeholder 18+ indhold; du skal vaere 18+.
 [6] Videredistribution eller salg er forbudt.]],
    steps={"[>] Starter...","[>] Spiller...","[>] Moduler...","[>] UI...","[>] KLAR!"}},

FI={accept="HYVAKSY",deny="HYLKAA",loading="LADATAAN",settings="ASETUKSET",
    close="X",minimize="-",playerinfo="PELAAJA",back="TAKAISIN",
    colorpick="VALITSE VARI",windowsize="IKKUNAN KOKO",
    small="PIENI",normal="NORMAALI",large="SUURI",
    eula_title="KAYTTAJASOPIMUS",
    eula_body=[[Kayttamalla tata ohjelmistoa hyvaksyt seuraavat ehdot:

 [1] Vain henkilokohtaiseen ja opetuskayttoon.
 [2] Kaytto muiden pelaajien vahingoittamiseen on kielletty.
 [3] Otat tayden vastuun tilin porttikielloista.
 [4] Kehittaja ei ole vastuussa mistaan vahingoista.
 [5] Sisaltaa 18+ sisaltoa; kayttajan on oltava 18+.
 [6] Uudelleenjakelu tai myynti on ehdottomasti kielletty.]],
    steps={"[>] Kaynnistetaan...","[>] Pelaaja...","[>] Moduulit...","[>] UI...","[>] VALMIS!"}},
}

-- ════════════════════════════════════════════════════════════
--  FONT — Roblox'ta mevcut en pixel/retro fontlar
-- ════════════════════════════════════════════════════════════
local PF  = Enum.Font.Code          -- pixel/monospace — başlıklar
local PF2 = Enum.Font.RobotoMono    -- monospace — içerik
local PF3 = Enum.Font.Gotham        -- fallback

-- ════════════════════════════════════════════════════════════
--  RENKLER
-- ════════════════════════════════════════════════════════════
local C={
    HOT     = Color3.fromRGB(255, 20,115),
    MID     = Color3.fromRGB(230,  8, 98),
    DEEP    = Color3.fromRGB(195,  0, 82),
    DARK    = Color3.fromRGB(140,  0, 56),
    DARKEST = Color3.fromRGB( 75,  0, 30),
    PANEL   = Color3.fromRGB( 18,  3, 11),
    PANELBG = Color3.fromRGB( 12,  1,  7),
    WHITE   = Color3.new(1,1,1),
    TEXT2   = Color3.fromRGB(255,185,212),
    NEON    = Color3.fromRGB(255, 75,158),
    STROKE  = Color3.fromRGB(255,110,175),
}

-- ════════════════════════════════════════════════════════════
--  YARDIMCI
-- ════════════════════════════════════════════════════════════
local function Cr(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 6) c.Parent=p return c end
local function St(p,col,th,tr) local s=Instance.new("UIStroke") s.Color=col or C.STROKE s.Thickness=th or 1 s.Transparency=tr or 0.35 s.Parent=p return s end
local function MkLbl(p,txt,sz,col,fnt,xa,ya)
    local l=Instance.new("TextLabel")
    l.Text=txt; l.TextSize=sz or 12; l.TextColor3=col or C.WHITE
    l.Font=fnt or PF2; l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.TextYAlignment=ya or Enum.TextYAlignment.Center
    l.Parent=p; return l
end
local function Tw(o,t,props)
    pcall(function()
        TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
    end)
end
local function TwBack(o,t,props)
    pcall(function()
        TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),props):Play()
    end)
end

-- ════════════════════════════════════════════════════════════
--  KÜTÜPHANe
-- ════════════════════════════════════════════════════════════
local Lib={}

function Lib:CreateWindow(cfg)
    cfg=cfg or {}
    local winTitle = cfg.Title    or "S3xy Hub"
    local winSub   = cfg.SubTitle or "v6.0"
    local lang     = LANGS[cfg.Language] or LANGS.TR

    -- Eski GUI temizle
    pcall(function()
        local c=GetContainer()
        if c then local o=c:FindFirstChild("S3xyHub_GUI") if o then o:Destroy() end end
        local o2=LP.PlayerGui:FindFirstChild("S3xyHub_GUI") if o2 then o2:Destroy() end
    end)

    local cont=GetContainer()
    if not cont then warn("[S3xyHub] Container yok!") return end

    -- ScreenGui
    local SG=Instance.new("ScreenGui")
    SG.Name="S3xyHub_GUI"; SG.ResetOnSpawn=false
    SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function() SG.DisplayOrder=999 end)
    pcall(function() SG.IgnoreGuiInset=true end)
    SG.Parent=cont

    -- ════════════════════════════════════════════════════════
    --  NEON ARKA PLAN  ZIndex 1-3
    -- ════════════════════════════════════════════════════════
    local BG=Instance.new("Frame")
    BG.Name="NeonBG"; BG.Size=UDim2.new(1,0,1,0)
    BG.BackgroundColor3=Color3.fromRGB(9,1,5)
    BG.BorderSizePixel=0; BG.ZIndex=1; BG.Parent=SG

    -- Glow blob'ları
    for _,g in ipairs({
        {0.12,0.18,340,0.46,Color3.fromRGB(255,20,110)},
        {0.80,0.72,380,0.42,Color3.fromRGB(200,0,82)},
        {0.50,0.48,500,0.56,Color3.fromRGB(115,0,46)},
        {0.92,0.10,210,0.50,Color3.fromRGB(255,55,132)},
        {0.06,0.84,230,0.48,Color3.fromRGB(255,32,116)},
        {0.33,0.87,175,0.52,Color3.fromRGB(175,0,70)},
        {0.66,0.08,165,0.52,Color3.fromRGB(255,58,138)},
    }) do
        local gl=Instance.new("ImageLabel")
        gl.Size=UDim2.new(0,g[3],0,g[3]); gl.Position=UDim2.new(g[1],-g[3]/2,g[2],-g[3]/2)
        gl.BackgroundTransparency=1; gl.Image="rbxassetid://5028857084"
        gl.ImageColor3=g[5]; gl.ImageTransparency=g[4]; gl.ZIndex=2; gl.Parent=BG
    end

    -- Grid çizgiler
    for i=1,9 do
        local h=Instance.new("Frame"); h.Size=UDim2.new(1,0,0,1)
        h.Position=UDim2.new(0,0,i/10,0); h.BackgroundColor3=C.NEON
        h.BackgroundTransparency=0.87; h.BorderSizePixel=0; h.ZIndex=3; h.Parent=BG
    end
    for i=1,13 do
        local v=Instance.new("Frame"); v.Size=UDim2.new(0,1,1,0)
        v.Position=UDim2.new(i/14,0,0,0); v.BackgroundColor3=C.NEON
        v.BackgroundTransparency=0.87; v.BorderSizePixel=0; v.ZIndex=3; v.Parent=BG
    end

    -- Dekoratif semboller — pixel font ile
    for _,d in ipairs({
        {"<3",0.04,0.06,18,-12,0.30},{"<3",0.93,0.10,16,18,0.28},
        {"<3",0.16,0.90,17,-6,0.26},{"<3",0.84,0.80,15,10,0.28},
        {"<3",0.48,0.04,14,-22,0.24},{"<3",0.72,0.03,18,-8,0.26},
        {"<3",0.60,0.92,13,15,0.22},{"<3",0.28,0.97,16,4,0.24},
        {"+18",0.94,0.48,13,6,0.22},{"+18",0.03,0.52,11,-10,0.20},
        {"+18",0.52,0.97,11,5,0.18},{"+18",0.20,0.03,12,8,0.18},
        {"[*]",0.24,0.03,14,28,0.22},{"[*]",0.80,0.92,12,-18,0.22},
        {"[#]",0.10,0.44,12,0,0.20},{"[#]",0.90,0.56,11,45,0.18},
        {">>",0.45,0.01,12,0,0.18},{"<<",0.58,0.96,11,0,0.16},
    }) do
        local sl=Instance.new("TextLabel")
        sl.Text=d[1]; sl.TextSize=d[4]; sl.TextColor3=C.NEON
        sl.TextTransparency=d[6]; sl.Font=PF
        sl.BackgroundTransparency=1
        sl.Position=UDim2.new(d[2],0,d[3],0)
        sl.Size=UDim2.new(0,80,0,30); sl.Rotation=d[5]
        sl.ZIndex=3; sl.Parent=BG
    end

    -- ════════════════════════════════════════════════════════
    --  EULA  ZIndex 20
    -- ════════════════════════════════════════════════════════
    local EF=Instance.new("Frame")
    EF.Size=UDim2.new(0,460,0,330); EF.Position=UDim2.new(0.5,-230,0.5,-165)
    EF.BackgroundColor3=C.PANELBG; EF.BorderSizePixel=0
    EF.ZIndex=20; EF.Parent=SG
    Cr(EF,10); St(EF,C.STROKE,2,0.06)

    -- Üst renk bar
    local ETopBar=Instance.new("Frame")
    ETopBar.Size=UDim2.new(1,0,0,36); ETopBar.BackgroundColor3=C.DEEP
    ETopBar.BorderSizePixel=0; ETopBar.ZIndex=21; ETopBar.Parent=EF
    Cr(ETopBar,10)
    local ETG=Instance.new("UIGradient")
    ETG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.HOT),ColorSequenceKeypoint.new(1,C.DEEP)})
    ETG.Rotation=90; ETG.Parent=ETopBar

    local ETitleLbl=MkLbl(ETopBar,"",16,C.WHITE,PF,Enum.TextXAlignment.Center)
    ETitleLbl.Size=UDim2.new(1,-80,1,0); ETitleLbl.Position=UDim2.new(0,10,0,0); ETitleLbl.ZIndex=22

    -- Dil butonu (topbar sağ)
    local LangBtn=Instance.new("TextButton")
    LangBtn.Text="LANG"; LangBtn.Size=UDim2.new(0,56,0,24)
    LangBtn.Position=UDim2.new(1,-64,0,6)
    LangBtn.BackgroundColor3=C.DARKEST; LangBtn.TextColor3=C.TEXT2
    LangBtn.Font=PF; LangBtn.TextSize=10
    LangBtn.BorderSizePixel=0; LangBtn.ZIndex=22; LangBtn.Parent=ETopBar
    Cr(LangBtn,4)

    -- Dil dropdown
    local LDrop=Instance.new("Frame")
    LDrop.Size=UDim2.new(0,80,0,0); LDrop.Position=UDim2.new(1,-84,1,2)
    LDrop.BackgroundColor3=C.PANELBG; LDrop.BorderSizePixel=0
    LDrop.ClipsDescendants=true; LDrop.ZIndex=30; LDrop.Parent=ETopBar
    Cr(LDrop,6); St(LDrop,C.STROKE,1,0.3)
    local DDL=Instance.new("UIListLayout"); DDL.Padding=UDim.new(0,2); DDL.Parent=LDrop

    local langKeys={"TR","EN","DE","FR","ES","IT","PT","RU","ZH","JA","KO","AR","PL","NL","SV","NO","DA","FI"}
    local langOpen=false

    local EBodyRef,EAcceptRef,EDenyRef -- forward refs untuk dil degisimi

    local function ApplyLang(L)
        lang=L
        ETitleLbl.Text=lang.eula_title
        if EBodyRef then EBodyRef.Text=lang.eula_body end
        if EAcceptRef then EAcceptRef.Text=lang.accept end
        if EDenyRef then EDenyRef.Text=lang.deny end
    end

    for _,lk in ipairs(langKeys) do
        local lb=Instance.new("TextButton")
        lb.Text=lk; lb.Size=UDim2.new(1,0,0,20)
        lb.BackgroundColor3=C.DARK; lb.BackgroundTransparency=0.25
        lb.TextColor3=C.WHITE; lb.Font=PF; lb.TextSize=10
        lb.BorderSizePixel=0; lb.ZIndex=31; lb.Parent=LDrop
        Cr(lb,3)
        lb.MouseButton1Click:Connect(function()
            ApplyLang(LANGS[lk] or LANGS.TR)
            langOpen=false; Tw(LDrop,0.15,{Size=UDim2.new(0,80,0,0)})
        end)
    end

    LangBtn.MouseButton1Click:Connect(function()
        langOpen=not langOpen
        if langOpen then
            Tw(LDrop,0.18,{Size=UDim2.new(0,80,0,#langKeys*22+4)})
        else
            Tw(LDrop,0.15,{Size=UDim2.new(0,80,0,0)})
        end
    end)

    -- EULA gövde
    local EBody=Instance.new("ScrollingFrame")
    EBody.Size=UDim2.new(1,-20,0,196); EBody.Position=UDim2.new(0,10,0,42)
    EBody.BackgroundTransparency=1; EBody.BorderSizePixel=0
    EBody.ScrollBarThickness=2; EBody.ScrollBarImageColor3=C.NEON
    EBody.CanvasSize=UDim2.new(0,0,0,0); EBody.AutomaticCanvasSize=Enum.AutomaticSize.Y
    EBody.ZIndex=21; EBody.Parent=EF

    local EBodyTxt=Instance.new("TextLabel")
    EBodyTxt.Size=UDim2.new(1,0,0,0); EBodyTxt.AutomaticSize=Enum.AutomaticSize.Y
    EBodyTxt.BackgroundTransparency=1; EBodyTxt.TextColor3=C.TEXT2
    EBodyTxt.Font=PF2; EBodyTxt.TextSize=11; EBodyTxt.TextWrapped=true
    EBodyTxt.TextXAlignment=Enum.TextXAlignment.Left
    EBodyTxt.TextYAlignment=Enum.TextYAlignment.Top
    EBodyTxt.ZIndex=22; EBodyTxt.Text=lang.eula_body; EBodyTxt.Parent=EBody
    EBodyRef=EBodyTxt

    -- Ayraç
    local ESep=Instance.new("Frame")
    ESep.Size=UDim2.new(1,-20,0,1); ESep.Position=UDim2.new(0,10,0,242)
    ESep.BackgroundColor3=C.NEON; ESep.BackgroundTransparency=0.55
    ESep.BorderSizePixel=0; ESep.ZIndex=21; ESep.Parent=EF

    -- REDDET
    local EDeny=Instance.new("TextButton")
    EDeny.Text=lang.deny; EDeny.Size=UDim2.new(0,140,0,38)
    EDeny.Position=UDim2.new(0.5,-148,1,-48)
    EDeny.BackgroundColor3=Color3.fromRGB(45,6,20)
    EDeny.TextColor3=C.TEXT2; EDeny.Font=PF; EDeny.TextSize=12
    EDeny.BorderSizePixel=0; EDeny.ZIndex=22; EDeny.Parent=EF
    Cr(EDeny,6); St(EDeny,C.STROKE,1,0.5)
    EDenyRef=EDeny

    -- KABUL ET
    local EAccept=Instance.new("TextButton")
    EAccept.Text=lang.accept; EAccept.Size=UDim2.new(0,140,0,38)
    EAccept.Position=UDim2.new(0.5,8,1,-48)
    EAccept.BackgroundColor3=C.HOT; EAccept.TextColor3=C.WHITE
    EAccept.Font=PF; EAccept.TextSize=12
    EAccept.BorderSizePixel=0; EAccept.ZIndex=22; EAccept.Parent=EF
    Cr(EAccept,6); St(EAccept,Color3.fromRGB(255,155,198),1.5,0.2)
    EAcceptRef=EAccept

    -- ilk dil uygula
    ApplyLang(lang)

    EDeny.MouseButton1Click:Connect(function()
        Tw(EF,0.25,{BackgroundTransparency=1})
        Tw(BG,0.25,{BackgroundTransparency=1})
        task.delay(0.3,function() SG:Destroy() end)
    end)

    -- ════════════════════════════════════════════════════════
    --  SPLASH  ZIndex 15
    -- ════════════════════════════════════════════════════════
    local SF=Instance.new("Frame")
    SF.Size=UDim2.new(0,340,0,200); SF.Position=UDim2.new(0.5,-170,0.5,-100)
    SF.BackgroundColor3=C.PANELBG; SF.BorderSizePixel=0
    SF.ZIndex=15; SF.Visible=false; SF.Parent=SG
    Cr(SF,12); St(SF,C.STROKE,2,0.05)

    local STopBar=Instance.new("Frame")
    STopBar.Size=UDim2.new(1,0,0,3); STopBar.BackgroundColor3=C.HOT
    STopBar.BorderSizePixel=0; STopBar.ZIndex=16; STopBar.Parent=SF
    Cr(STopBar,12)

    local SGlow=Instance.new("ImageLabel")
    SGlow.Size=UDim2.new(0,90,0,90); SGlow.Position=UDim2.new(0.5,-45,0,14)
    SGlow.BackgroundTransparency=1; SGlow.Image="rbxassetid://5028857084"
    SGlow.ImageColor3=C.HOT; SGlow.ImageTransparency=0.15; SGlow.ZIndex=16; SGlow.Parent=SF

    local SIcon=MkLbl(SF,"[S]",32,C.WHITE,PF,Enum.TextXAlignment.Center)
    SIcon.Size=UDim2.new(0,60,0,48); SIcon.Position=UDim2.new(0.5,-30,0,26); SIcon.ZIndex=17

    local STitleLbl=MkLbl(SF,"S3XY HUB",18,C.WHITE,PF,Enum.TextXAlignment.Center)
    STitleLbl.Size=UDim2.new(1,0,0,22); STitleLbl.Position=UDim2.new(0,0,0,108); STitleLbl.ZIndex=16

    local SSubLbl=MkLbl(SF,winTitle,11,C.TEXT2,PF2,Enum.TextXAlignment.Center)
    SSubLbl.Size=UDim2.new(1,0,0,14); SSubLbl.Position=UDim2.new(0,0,0,130); SSubLbl.ZIndex=16

    -- Loading bar
    local BarBG=Instance.new("Frame")
    BarBG.Size=UDim2.new(0,260,0,4); BarBG.Position=UDim2.new(0.5,-130,1,-22)
    BarBG.BackgroundColor3=C.DARKEST; BarBG.BorderSizePixel=0; BarBG.ZIndex=16; BarBG.Parent=SF
    Cr(BarBG,2)

    local BarFill=Instance.new("Frame")
    BarFill.Size=UDim2.new(0,0,1,0); BarFill.BackgroundColor3=C.HOT
    BarFill.BorderSizePixel=0; BarFill.ZIndex=17; BarFill.Parent=BarBG
    Cr(BarFill,2)
    local BFG=Instance.new("UIGradient")
    BFG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,105,168)),ColorSequenceKeypoint.new(1,C.HOT)})
    BFG.Parent=BarFill

    local LoadLbl=MkLbl(SF,"",10,C.TEXT2,PF2,Enum.TextXAlignment.Center)
    LoadLbl.Size=UDim2.new(1,0,0,14); LoadLbl.Position=UDim2.new(0,0,1,-38); LoadLbl.ZIndex=16

    -- ════════════════════════════════════════════════════════
    --  ANA GUI  ZIndex 10  —  başta gizli
    -- ════════════════════════════════════════════════════════
    local Main=Instance.new("Frame")
    Main.Name="Main"; Main.Size=UDim2.new(0,590,0,345)
    Main.Position=UDim2.new(0.5,-295,0.5,-172)
    Main.BackgroundColor3=Color3.fromRGB(15,2,9)
    Main.BorderSizePixel=0; Main.ClipsDescendants=true
    Main.ZIndex=10; Main.Visible=false; Main.Parent=SG
    Cr(Main,12); St(Main,C.STROKE,2,0.05)

    local MainGrad=Instance.new("UIGradient")
    MainGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,3,13)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,1,7))})
    MainGrad.Rotation=135; MainGrad.Parent=Main

    -- TopBar
    local TB=Instance.new("Frame")
    TB.Size=UDim2.new(1,0,0,38); TB.BackgroundColor3=C.DEEP
    TB.BorderSizePixel=0; TB.ZIndex=12; TB.Parent=Main
    Cr(TB,12)
    local TBG=Instance.new("UIGradient")
    TBG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,32,115)),ColorSequenceKeypoint.new(1,Color3.fromRGB(182,0,76))})
    TBG.Rotation=90; TBG.Parent=TB

    local BrandLbl=MkLbl(TB,"S3XY HUB",16,C.WHITE,PF,Enum.TextXAlignment.Center)
    BrandLbl.Size=UDim2.new(1,0,1,0); BrandLbl.ZIndex=13

    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Text="[X]"; CloseBtn.Size=UDim2.new(0,38,0,26)
    CloseBtn.Position=UDim2.new(1,-42,0,6)
    CloseBtn.BackgroundColor3=Color3.fromRGB(185,22,68)
    CloseBtn.TextColor3=C.WHITE; CloseBtn.Font=PF; CloseBtn.TextSize=11
    CloseBtn.BorderSizePixel=0; CloseBtn.ZIndex=14; CloseBtn.Parent=TB
    Cr(CloseBtn,4)

    local MinBtn=Instance.new("TextButton")
    MinBtn.Text="[-]"; MinBtn.Size=UDim2.new(0,38,0,26)
    MinBtn.Position=UDim2.new(1,-84,0,6)
    MinBtn.BackgroundColor3=C.DARK; MinBtn.TextColor3=C.WHITE
    MinBtn.Font=PF; MinBtn.TextSize=11
    MinBtn.BorderSizePixel=0; MinBtn.ZIndex=14; MinBtn.Parent=TB
    Cr(MinBtn,4)

    -- Sidebar
    local SB=Instance.new("Frame")
    SB.Size=UDim2.new(0,130,1,-38); SB.Position=UDim2.new(0,0,0,38)
    SB.BackgroundColor3=Color3.fromRGB(11,1,6)
    SB.BorderSizePixel=0; SB.ClipsDescendants=true; SB.ZIndex=11; SB.Parent=Main

    local SBLine=Instance.new("Frame")
    SBLine.Size=UDim2.new(0,1,1,0); SBLine.Position=UDim2.new(1,-1,0,0)
    SBLine.BackgroundColor3=C.NEON; SBLine.BackgroundTransparency=0.5
    SBLine.BorderSizePixel=0; SBLine.ZIndex=12; SBLine.Parent=SB

    -- Player kutusu
    local PBox=Instance.new("Frame")
    PBox.Size=UDim2.new(1,-8,0,72); PBox.Position=UDim2.new(0,4,0,5)
    PBox.BackgroundColor3=Color3.fromRGB(24,3,14); PBox.BackgroundTransparency=0.05
    PBox.BorderSizePixel=0; PBox.ZIndex=12; PBox.Parent=SB
    Cr(PBox,8); St(PBox,C.STROKE,1,0.5)

    local PToggleBtn=Instance.new("TextButton")
    PToggleBtn.Text="v"; PToggleBtn.Size=UDim2.new(0,14,0,12)
    PToggleBtn.Position=UDim2.new(1,-16,0,4)
    PToggleBtn.BackgroundTransparency=1; PToggleBtn.TextColor3=C.TEXT2
    PToggleBtn.Font=PF; PToggleBtn.TextSize=9
    PToggleBtn.BorderSizePixel=0; PToggleBtn.ZIndex=13; PToggleBtn.Parent=PBox

    local Av=Instance.new("ImageLabel")
    Av.Size=UDim2.new(0,36,0,36); Av.Position=UDim2.new(0,5,0.5,-18)
    Av.BackgroundColor3=C.DARK; Av.BackgroundTransparency=0.3
    Av.BorderSizePixel=0; Av.ZIndex=13; Av.Parent=PBox
    Cr(Av,6)
    pcall(function()
        Av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LP.UserId.."&width=150&height=150&format=png"
    end)

    local dname,uname="PLAYER","unknown"
    pcall(function() dname=string.upper(LP.DisplayName) end)
    pcall(function() uname=LP.Name end)

    local NL=MkLbl(PBox,dname,10,C.WHITE,PF)
    NL.Size=UDim2.new(1,-48,0,14); NL.Position=UDim2.new(0,46,0,14)
    NL.TextTruncate=Enum.TextTruncate.AtEnd; NL.ZIndex=13

    local UL=MkLbl(PBox,"@"..uname,9,C.TEXT2,PF2)
    UL.Size=UDim2.new(1,-48,0,12); UL.Position=UDim2.new(0,46,0,30)
    UL.TextTruncate=Enum.TextTruncate.AtEnd; UL.ZIndex=13

    local pboxOpen=true
    PToggleBtn.MouseButton1Click:Connect(function()
        pboxOpen=not pboxOpen
        if pboxOpen then Tw(PBox,0.2,{Size=UDim2.new(1,-8,0,72)}) PToggleBtn.Text="v"
        else Tw(PBox,0.2,{Size=UDim2.new(1,-8,0,20)}) PToggleBtn.Text=">" end
    end)

    -- Tab listesi
    local TBListF=Instance.new("Frame")
    TBListF.Size=UDim2.new(1,-8,1,-84); TBListF.Position=UDim2.new(0,4,0,80)
    TBListF.BackgroundTransparency=1; TBListF.ClipsDescendants=true
    TBListF.ZIndex=12; TBListF.Parent=SB
    local TBLL=Instance.new("UIListLayout"); TBLL.Padding=UDim.new(0,3); TBLL.SortOrder=Enum.SortOrder.LayoutOrder; TBLL.Parent=TBListF

    -- Gear
    local GearBtn=Instance.new("TextButton")
    GearBtn.Text="[SETTINGS]"; GearBtn.Size=UDim2.new(1,-8,0,22)
    GearBtn.Position=UDim2.new(0,4,1,-26)
    GearBtn.BackgroundColor3=Color3.fromRGB(18,2,10); GearBtn.BackgroundTransparency=0.2
    GearBtn.TextColor3=C.TEXT2; GearBtn.Font=PF; GearBtn.TextSize=9
    GearBtn.BorderSizePixel=0; GearBtn.ZIndex=12; GearBtn.Parent=SB
    Cr(GearBtn,4)

    -- İçerik alanı
    local CA=Instance.new("Frame")
    CA.Size=UDim2.new(1,-136,1,-38); CA.Position=UDim2.new(0,134,0,38)
    CA.BackgroundColor3=Color3.fromRGB(16,2,10)
    CA.BorderSizePixel=0; CA.ClipsDescendants=true; CA.ZIndex=11; CA.Parent=Main
    Cr(CA,8)

    -- Ayarlar paneli
    local CustP=Instance.new("Frame")
    CustP.Size=UDim2.new(1,0,1,0); CustP.BackgroundColor3=Color3.fromRGB(12,1,7)
    CustP.BorderSizePixel=0; CustP.Visible=false; CustP.ZIndex=20; CustP.Parent=CA
    Cr(CustP,8)

    local CTopBar=Instance.new("Frame")
    CTopBar.Size=UDim2.new(1,0,0,3); CTopBar.BackgroundColor3=C.HOT
    CTopBar.BorderSizePixel=0; CTopBar.ZIndex=21; CTopBar.Parent=CustP
    Cr(CTopBar,8)

    local CTitleLbl=MkLbl(CustP,lang.settings,14,C.WHITE,PF,Enum.TextXAlignment.Center)
    CTitleLbl.Size=UDim2.new(1,0,0,36); CTitleLbl.ZIndex=21

    local CBackBtn=Instance.new("TextButton")
    CBackBtn.Text="[<BACK]"; CBackBtn.Size=UDim2.new(0,70,0,22)
    CBackBtn.Position=UDim2.new(1,-76,0,7)
    CBackBtn.BackgroundColor3=C.DARK; CBackBtn.TextColor3=C.TEXT2
    CBackBtn.Font=PF; CBackBtn.TextSize=9
    CBackBtn.BorderSizePixel=0; CBackBtn.ZIndex=22; CBackBtn.Parent=CustP
    Cr(CBackBtn,4)
    CBackBtn.MouseButton1Click:Connect(function() CustP.Visible=false end)

    -- Dil seçici (ayarlar içinde)
    local CLangLbl=MkLbl(CustP,"[LANGUAGE]",10,C.TEXT2,PF)
    CLangLbl.Size=UDim2.new(1,-16,0,14); CLangLbl.Position=UDim2.new(0,8,0,42); CLangLbl.ZIndex=21

    local CLangRow=Instance.new("Frame")
    CLangRow.Size=UDim2.new(1,-16,0,50); CLangRow.Position=UDim2.new(0,8,0,57)
    CLangRow.BackgroundTransparency=1; CLangRow.ZIndex=21; CLangRow.Parent=CustP
    local CLG=Instance.new("UIGridLayout")
    CLG.CellSize=UDim2.new(0,36,0,17); CLG.CellPaddingSize=UDim2.new(0,3,0,3); CLG.Parent=CLangRow

    for _,lk in ipairs(langKeys) do
        local lb2=Instance.new("TextButton")
        lb2.Text=lk; lb2.BackgroundColor3=C.DARK; lb2.BackgroundTransparency=0.2
        lb2.TextColor3=C.TEXT2; lb2.Font=PF; lb2.TextSize=9
        lb2.BorderSizePixel=0; lb2.ZIndex=22; lb2.Parent=CLangRow
        Cr(lb2,3)
        lb2.MouseButton1Click:Connect(function()
            ApplyLang(LANGS[lk] or LANGS.TR)
            CTitleLbl.Text=lang.settings
            CBackBtn.Text="[<"..lang.back.."]"
        end)
    end

    -- Renk seçici
    local CColLbl=MkLbl(CustP,"[COLOR]",10,C.TEXT2,PF)
    CColLbl.Size=UDim2.new(1,-16,0,14); CColLbl.Position=UDim2.new(0,8,0,112); CColLbl.ZIndex=21

    local CColRow=Instance.new("Frame")
    CColRow.Size=UDim2.new(1,-16,0,30); CColRow.Position=UDim2.new(0,8,0,128)
    CColRow.BackgroundTransparency=1; CColRow.ZIndex=21; CColRow.Parent=CustP
    local CCG=Instance.new("UIGridLayout")
    CCG.CellSize=UDim2.new(0,26,0,26); CCG.CellPaddingSize=UDim2.new(0,4,0,4); CCG.Parent=CColRow

    for _,cc in ipairs({
        {Color3.fromRGB(255,20,110)},{Color3.fromRGB(220,25,45)},
        {Color3.fromRGB(145,30,225)},{Color3.fromRGB(25,105,255)},
        {Color3.fromRGB(20,195,95)},{Color3.fromRGB(255,140,0)},
        {Color3.fromRGB(0,195,210)},{Color3.fromRGB(255,210,0)},
    }) do
        local cb=Instance.new("TextButton")
        cb.Text=""; cb.BackgroundColor3=cc[1]; cb.BorderSizePixel=0
        cb.ZIndex=22; cb.Parent=CColRow
        Cr(cb,13); St(cb,C.WHITE,1.5,0.5)
        cb.MouseButton1Click:Connect(function()
            local r,g,b=cc[1].R,cc[1].G,cc[1].B
            C.HOT=cc[1]; C.NEON=cc[1]; C.STROKE=cc[1]
            C.DEEP=Color3.new(r*0.76,g*0.76,b*0.76)
            C.DARK=Color3.new(r*0.54,g*0.54,b*0.54)
            C.DARKEST=Color3.new(r*0.30,g*0.30,b*0.30)
            TB.BackgroundColor3=C.DEEP
            SBLine.BackgroundColor3=cc[1]
            ETopBar.BackgroundColor3=C.DEEP
            STopBar.BackgroundColor3=cc[1]
            CTopBar.BackgroundColor3=cc[1]
            pcall(function()
                TBG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cc[1]),ColorSequenceKeypoint.new(1,C.DEEP)})
                ETG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cc[1]),ColorSequenceKeypoint.new(1,C.DEEP)})
            end)
        end)
    end

    -- Boyut seçici
    local CSLbl=MkLbl(CustP,"[WINDOW SIZE]",10,C.TEXT2,PF)
    CSLbl.Size=UDim2.new(1,-16,0,14); CSLbl.Position=UDim2.new(0,8,0,166); CSLbl.ZIndex=21

    local CSRow=Instance.new("Frame")
    CSRow.Size=UDim2.new(1,-16,0,28); CSRow.Position=UDim2.new(0,8,0,182)
    CSRow.BackgroundTransparency=1; CSRow.ZIndex=21; CSRow.Parent=CustP
    local CSG=Instance.new("UIListLayout"); CSG.FillDirection=Enum.FillDirection.Horizontal
    CSG.Padding=UDim.new(0,6); CSG.Parent=CSRow

    for i,sz in ipairs({{480,280},{590,345},{720,430}}) do
        local sn={lang.small,lang.normal,lang.large}
        local sb=Instance.new("TextButton")
        sb.Text=sn[i]; sb.Size=UDim2.new(0,95,0,26)
        sb.BackgroundColor3=C.DARKEST; sb.TextColor3=C.TEXT2
        sb.Font=PF; sb.TextSize=10
        sb.BorderSizePixel=0; sb.ZIndex=22; sb.Parent=CSRow
        Cr(sb,4)
        sb.MouseButton1Click:Connect(function()
            TwBack(Main,0.3,{Size=UDim2.new(0,sz[1],0,sz[2]),Position=UDim2.new(0.5,-sz[1]/2,0.5,-sz[2]/2)})
        end)
    end

    GearBtn.MouseButton1Click:Connect(function() CustP.Visible=true end)

    -- Drag
    local dragging=false; local dOff=Vector2.new()
    TB.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dOff=Vector2.new(inp.Position.X-Main.AbsolutePosition.X,inp.Position.Y-Main.AbsolutePosition.Y)
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local vp=Vector2.new(1920,1080); pcall(function() vp=workspace.CurrentCamera.ViewportSize end)
        Main.Position=UDim2.new(0,math.clamp(inp.Position.X-dOff.X,0,vp.X-Main.AbsoluteSize.X),0,math.clamp(inp.Position.Y-dOff.Y,0,vp.Y-Main.AbsoluteSize.Y))
    end)

    -- Küçült
    local minimized=false
    MinBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then Tw(Main,0.2,{Size=UDim2.new(0,590,0,38)}) MinBtn.Text="[+]"
        else Tw(Main,0.25,{Size=UDim2.new(0,590,0,345)}) MinBtn.Text="[-]" end
    end)

    -- Kapat/Aç
    local OpenBtn=Instance.new("TextButton")
    OpenBtn.Text="[S3XY HUB]"; OpenBtn.Size=UDim2.new(0,96,0,24)
    OpenBtn.Position=UDim2.new(0,10,1,-34)
    OpenBtn.BackgroundColor3=C.DEEP; OpenBtn.TextColor3=C.WHITE
    OpenBtn.Font=PF; OpenBtn.TextSize=10
    OpenBtn.BorderSizePixel=0; OpenBtn.Visible=false; OpenBtn.ZIndex=10; OpenBtn.Parent=SG
    Cr(OpenBtn,4); St(OpenBtn,C.STROKE,1.5,0.2)

    CloseBtn.MouseButton1Click:Connect(function()
        Tw(Main,0.22,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0,Main.AbsolutePosition.X+295,0,Main.AbsolutePosition.Y+172)})
        task.delay(0.24,function() Main.Visible=false; OpenBtn.Visible=true end)
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible=false; Main.Visible=true
        Main.Size=UDim2.new(0,0,0,0); Main.Position=UDim2.new(0.5,0,0.5,0)
        TwBack(Main,0.42,{Size=UDim2.new(0,590,0,345),Position=UDim2.new(0.5,-295,0.5,-172)})
    end)

    -- ════════════════════════════════════════════════════════
    --  EULA → SPLASH → MAIN AKIŞI  (task.spawn ile)
    -- ════════════════════════════════════════════════════════
    EAccept.MouseButton1Click:Connect(function()
        -- EAccept'i hemen devre dışı bırak (çift tıklamayı önle)
        EAccept.Active=false
        EAccept.AutoButtonColor=false

        -- EULA kapat
        Tw(EF,0.22,{BackgroundTransparency=1})
        task.delay(0.24,function() EF.Visible=false end)

        -- Splash aç — task.spawn ile bağımsız coroutine
        task.spawn(function()
            task.wait(0.28)

            -- Splash göster
            SF.Visible=true
            SF.BackgroundTransparency=0
            SF.Size=UDim2.new(0,0,0,0)
            SF.Position=UDim2.new(0.5,0,0.5,0)
            TwBack(SF,0.45,{Size=UDim2.new(0,340,0,200),Position=UDim2.new(0.5,-170,0.5,-100)})

            task.wait(0.5)

            -- Loading adımları
            local steps=lang.steps
            for i,step in ipairs(steps) do
                LoadLbl.Text=step
                local pct=i/#steps
                Tw(BarFill,0.28,{Size=UDim2.new(pct,0,1,0)})
                task.wait(0.38)
            end

            task.wait(0.3)

            -- Splash kapat
            Tw(SF,0.22,{BackgroundTransparency=1})
            task.wait(0.25)
            SF.Visible=false

            -- Arka planı kapat
            Tw(BG,0.30,{BackgroundTransparency=1})
            task.wait(0.32)
            BG.Visible=false

            -- Main aç
            Main.Visible=true
            Main.BackgroundTransparency=0
            Main.Size=UDim2.new(0,0,0,0)
            Main.Position=UDim2.new(0.5,0,0.5,0)
            TwBack(Main,0.48,{Size=UDim2.new(0,590,0,345),Position=UDim2.new(0.5,-295,0.5,-172)})
        end)
    end)

    -- ════════════════════════════════════════════════════════
    --  TAB SİSTEMİ
    -- ════════════════════════════════════════════════════════
    local tabs={}; local tabCount=0

    local function ActivateTab(idx)
        for i,t in ipairs(tabs) do
            if i==idx then
                Tw(t.btn,0.1,{BackgroundTransparency=0}); t.btn.TextColor3=Color3.fromRGB(12,1,7); t.page.Visible=true
            else
                Tw(t.btn,0.1,{BackgroundTransparency=0.65}); t.btn.TextColor3=C.TEXT2; t.page.Visible=false
            end
        end
    end

    local Win={}

    function Win:AddTab(name)
        tabCount=tabCount+1; local idx=tabCount

        local TBtn=Instance.new("TextButton")
        TBtn.Text=string.upper(name); TBtn.Size=UDim2.new(1,0,0,26)
        TBtn.BackgroundColor3=C.WHITE; TBtn.BackgroundTransparency=0.65
        TBtn.TextColor3=C.TEXT2; TBtn.Font=PF; TBtn.TextSize=10
        TBtn.BorderSizePixel=0; TBtn.LayoutOrder=idx; TBtn.ZIndex=12; TBtn.Parent=TBListF
        Cr(TBtn,4)

        local Page=Instance.new("ScrollingFrame")
        Page.Size=UDim2.new(1,-8,1,-8); Page.Position=UDim2.new(0,4,0,4)
        Page.BackgroundTransparency=1; Page.BorderSizePixel=0
        Page.ScrollBarThickness=2; Page.ScrollBarImageColor3=C.NEON
        Page.CanvasSize=UDim2.new(0,0,0,0); Page.AutomaticCanvasSize=Enum.AutomaticSize.Y
        Page.Visible=false; Page.ZIndex=12; Page.Parent=CA

        local PL=Instance.new("UIListLayout"); PL.Padding=UDim.new(0,5); PL.SortOrder=Enum.SortOrder.LayoutOrder; PL.Parent=Page
        local PP=Instance.new("UIPadding"); PP.PaddingLeft=UDim.new(0,4); PP.PaddingRight=UDim.new(0,4); PP.PaddingTop=UDim.new(0,4); PP.Parent=Page

        table.insert(tabs,{btn=TBtn,page=Page})
        TBtn.MouseButton1Click:Connect(function() ActivateTab(idx) end)
        if idx==1 then ActivateTab(1) end

        local Tab={}; local eCount=0
        local function EBox(h)
            eCount=eCount+1
            local b=Instance.new("Frame")
            b.Size=UDim2.new(1,-2,0,h); b.BackgroundColor3=Color3.fromRGB(22,3,13)
            b.BackgroundTransparency=0.05; b.BorderSizePixel=0; b.LayoutOrder=eCount
            b.ZIndex=13; b.Parent=Page
            Cr(b,6)
            -- Sol accent
            local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,2,0.65,0); acc.Position=UDim2.new(0,0,0.175,0)
            acc.BackgroundColor3=C.HOT; acc.BackgroundTransparency=0.35; acc.BorderSizePixel=0; acc.ZIndex=14; acc.Parent=b
            Cr(acc,1)
            return b
        end

        function Tab:AddSlider(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "SLIDER"
            local minV=cfg.Min or 0; local maxV=cfg.Max or 100
            local def=math.clamp(cfg.Default or 50,cfg.Min or 0,cfg.Max or 100)
            local cb=cfg.Callback; local box=EBox(62)

            local TL=MkLbl(box,string.upper(lbl),10,C.WHITE,PF)
            TL.Size=UDim2.new(0.65,0,0,15); TL.Position=UDim2.new(0,10,0,5); TL.ZIndex=14

            local VL=MkLbl(box,tostring(def),10,C.TEXT2,PF,Enum.TextXAlignment.Right)
            VL.Size=UDim2.new(0.3,0,0,15); VL.Position=UDim2.new(0.68,0,0,5); VL.ZIndex=14

            local Track=Instance.new("Frame")
            Track.Size=UDim2.new(1,-16,0,6); Track.Position=UDim2.new(0,8,0,34)
            Track.BackgroundColor3=C.DARKEST; Track.BorderSizePixel=0; Track.ZIndex=14; Track.Parent=box
            Cr(Track,3)

            local Fill=Instance.new("Frame")
            Fill.Size=UDim2.new((def-minV)/(maxV-minV),0,1,0)
            Fill.BackgroundColor3=C.HOT; Fill.BorderSizePixel=0; Fill.ZIndex=15; Fill.Parent=Track
            Cr(Fill,3)
            local FG=Instance.new("UIGradient")
            FG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,105,168)),ColorSequenceKeypoint.new(1,C.HOT)})
            FG.Parent=Fill

            local Knob=Instance.new("Frame")
            Knob.Size=UDim2.new(0,13,0,13); Knob.AnchorPoint=Vector2.new(0.5,0.5)
            Knob.Position=UDim2.new((def-minV)/(maxV-minV),0,0.5,0)
            Knob.BackgroundColor3=C.WHITE; Knob.BorderSizePixel=0; Knob.ZIndex=16; Knob.Parent=Track
            Cr(Knob,7); St(Knob,C.STROKE,2,0.05)

            local sliding=false
            local function applyX(x)
                local rel=math.clamp((x-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                local val=math.round(minV+rel*(maxV-minV))
                Fill.Size=UDim2.new(rel,0,1,0); Knob.Position=UDim2.new(rel,0,0.5,0)
                VL.Text=tostring(val); if cb then pcall(cb,val) end
            end
            Track.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    sliding=true; applyX(inp.Position.X); Tw(Knob,0.07,{Size=UDim2.new(0,17,0,17)})
                    inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then sliding=false; Tw(Knob,0.07,{Size=UDim2.new(0,13,0,13)}) end end)
                end
            end)
            UIS.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then applyX(inp.Position.X) end
            end)
            UIS.InputEnded:Connect(function(inp)
                if (inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) and sliding then
                    sliding=false; Tw(Knob,0.07,{Size=UDim2.new(0,13,0,13)}) end
            end)
            return {SetValue=function(v)
                v=math.clamp(v,minV,maxV); local r=(v-minV)/(maxV-minV)
                Fill.Size=UDim2.new(r,0,1,0); Knob.Position=UDim2.new(r,0,0.5,0)
                VL.Text=tostring(math.round(v)); if cb then pcall(cb,v) end
            end}
        end

        function Tab:AddToggle(cfg)
            cfg=cfg or {}; local lbl=cfg.Name or "TOGGLE"; local def=cfg.Default or false; local cb=cfg.Callback
            local box=EBox(40); local state=def

            local TL=MkLbl(box,string.upper(lbl),10,C.WHITE,PF)
            TL.Size=UDim2.new(0.7,0,1,0); TL.Position=UDim2.new(0,10,0,0); TL.ZIndex=14

            local Trk=Instance.new("Frame")
            Trk.Size=UDim2.new(0,36,0,18); Trk.Position=UDim2.new(1,-44,0.5,-9)
            Trk.BackgroundColor3=state and C.HOT or C.DARKEST; Trk.BorderSizePixel=0; Trk.ZIndex=14; Trk.Parent=box
            Cr(Trk,9)

            local Thumb=Instance.new("Frame")
            Thumb.Size=UDim2.new(0,12,0,12)
            Thumb.Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
            Thumb.BackgroundColor3=C.WHITE; Thumb.BorderSizePixel=0; Thumb.ZIndex=15; Thumb.Parent=Trk
            Cr(Thumb,6)

            local function SS(s) state=s
                Tw(Trk,0.14,{BackgroundColor3=s and C.HOT or C.DARKEST})
                Tw(Thumb,0.14,{Position=s and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)})
                if cb then pcall(cb,s) end
            end
            box.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then SS(not state) end end)
            return {SetValue=function(v) SS(v) end,GetValue=function() return state end}
        end

        function Tab:AddButton(cfg)
            cfg=cfg or {}; local lbl=cfg.Name or "BUTTON"; local cb=cfg.Callback
            local box=EBox(34); box.BackgroundTransparency=1

            local Btn=Instance.new("TextButton")
            Btn.Text=string.upper(lbl); Btn.Size=UDim2.new(1,0,1,0)
            Btn.BackgroundColor3=C.HOT; Btn.TextColor3=C.WHITE
            Btn.Font=PF; Btn.TextSize=11; Btn.BorderSizePixel=0; Btn.LayoutOrder=eCount
            Btn.ZIndex=14; Btn.Parent=box
            Cr(Btn,6); St(Btn,Color3.fromRGB(255,150,195),1,0.4)

            Btn.MouseButton1Click:Connect(function()
                Tw(Btn,0.06,{BackgroundColor3=Color3.fromRGB(255,110,170)})
                task.delay(0.12,function() Tw(Btn,0.1,{BackgroundColor3=C.HOT}) end)
                if cb then pcall(cb) end
            end)
        end

        function Tab:AddLabel(text)
            local box=EBox(26)
            local l=MkLbl(box,text,10,C.TEXT2,PF2,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,-12,1,0); l.Position=UDim2.new(0,6,0,0); l.ZIndex=14
        end

        function Tab:AddSection(text)
            local box=EBox(20); box.BackgroundTransparency=0.55
            local l=MkLbl(box,"--- "..string.upper(text).." ---",9,C.NEON,PF,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,0,1,0); l.ZIndex=14
        end

        function Tab:AddTextBox(cfg)
            cfg=cfg or {}; local lbl=cfg.Name or "INPUT"; local ph=cfg.Placeholder or "..."
            local cb=cfg.Callback; local box=EBox(50)

            local TL=MkLbl(box,string.upper(lbl),10,C.WHITE,PF)
            TL.Size=UDim2.new(1,-12,0,15); TL.Position=UDim2.new(0,10,0,4); TL.ZIndex=14

            local Input=Instance.new("TextBox")
            Input.Size=UDim2.new(1,-16,0,20); Input.Position=UDim2.new(0,8,0,22)
            Input.BackgroundColor3=C.DARKEST; Input.BackgroundTransparency=0.08
            Input.TextColor3=C.WHITE; Input.Font=PF2; Input.TextSize=10
            Input.PlaceholderText=ph; Input.PlaceholderColor3=C.TEXT2
            Input.BorderSizePixel=0; Input.ZIndex=14; Input.Parent=box
            Cr(Input,4)
            Input.FocusLost:Connect(function(enter) if enter and cb then pcall(cb,Input.Text) end end)
        end

        return Tab
    end

    return Win
end

return Lib

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  XENO TEST  — direk executor'a yaz
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Hub = loadstring(game:HttpGet("RAW_LINK"))()

local Win = Hub:CreateWindow({
    Title    = "My Script",
    SubTitle = "v1.0",
    Language = "TR",
})

local Kar = Win:AddTab("Karakter")
Kar:AddSection("Hareket")
Kar:AddSlider({ Name="Hiz",     Min=1, Max=200, Default=16,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end})
Kar:AddSlider({ Name="Ziplama", Min=1, Max=300, Default=50,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end})
Kar:AddToggle({ Name="Sonsuz Ziplama", Default=false,
    Callback=function(s)
        if s then
            _G.IJ=game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        elseif _G.IJ then _G.IJ:Disconnect() end
    end})
Kar:AddButton({ Name="Reset",
    Callback=function() game.Players.LocalPlayer.Character.Humanoid.Health=0 end})

local Vis = Win:AddTab("Grafik")
Vis:AddSlider({Name="FOV",       Min=30, Max=120, Default=70,
    Callback=function(v) workspace.CurrentCamera.FieldOfView=v end})
Vis:AddSlider({Name="Yercekimi", Min=10, Max=300, Default=196,
    Callback=function(v) workspace.Gravity=v end})
]]
