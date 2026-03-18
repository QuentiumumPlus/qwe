--[[
╔══════════════════════════════════════════════════════════════╗
║                    S3xy Hub  v5.0                            ║
║  Xeno / Solara / Delta / Synapse / Wave uyumlu               ║
║  gethui()  |  Rayfield tarzı açılış  |  EULA                 ║
║  Neon arka plan  |  Çok Dilli  |  Özelleştirme               ║
╚══════════════════════════════════════════════════════════════╝

KULLANIM:
    local Hub = loadstring(game:HttpGet("RAW_LINK"))()

    local Win = Hub:CreateWindow({
        Title    = "My Script",
        SubTitle = "v1.0  by Someone",
        Language = "TR",  -- TR/EN/DE/FR/ES/IT/PT/RU/ZH/JA/KO/AR/PL/NL/SV/NO/DA/FI
    })

    local Tab = Win:AddTab("Karakter")
    Tab:AddSlider({ Name="Hız", Min=1, Max=200, Default=16,
        Callback = function(v)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    })
]]

-- ════════════════════════════════════════════════════════════
--  SERVİSLER
-- ════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenSvc     = game:GetService("TweenService")
local RunSvc       = game:GetService("RunService")

-- ════════════════════════════════════════════════════════════
--  LOCAL PLAYER
-- ════════════════════════════════════════════════════════════
local LP
repeat
    pcall(function() LP = Players.LocalPlayer end)
    if not LP then RunSvc.Heartbeat:Wait() end
until LP

-- ════════════════════════════════════════════════════════════
--  CONTAINER  (gethui öncelikli — executor uyumu)
-- ════════════════════════════════════════════════════════════
local function GetContainer()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    local ok2, pg = pcall(function() return LP:WaitForChild("PlayerGui", 5) end)
    if ok2 and pg then return pg end
end

-- ════════════════════════════════════════════════════════════
--  ÇOK DİLLİ DESTEK
-- ════════════════════════════════════════════════════════════
local LANGS = {
    TR = { accept="Kabul Et", deny="Reddet", loading="Yükleniyor",
           settings="Ayarlar", close="Kapat", minimize="Küçült",
           playerinfo="Oyuncu Bilgisi", back="Geri",
           colorpick="Renk Seç", windowsize="Pencere Boyutu",
           small="Küçük", normal="Normal", large="Büyük",
           eula_title="Kullanıcı Sözleşmesi",
           eula_body=[[Bu yazılımı kullanarak aşağıdaki koşulları kabul etmiş sayılırsınız:

  1. Bu script yalnızca kişisel kullanım ve eğitim amaçlıdır.
  2. Başka oyunculara zarar vermek amacıyla kullanmak yasaktır.
  3. Hesabınızın banlanma riskini tamamen siz üstlenirsiniz.
  4. Geliştirici hiçbir zarardan sorumlu tutulamaz.
  5. Bu script +18 içeriklere sahiptir; kullanıcı 18 yaşında olmalıdır.
  6. Scripti dağıtmak veya satmak kesinlikle yasaktır.

Devam ederek tüm koşulları okuduğunuzu onaylıyorsunuz.]],
           steps={"Başlatılıyor...","Oyuncu bilgileri alınıyor...","Modüller yükleniyor...","Arayüz hazırlanıyor...","Hazır!"} },

    EN = { accept="Accept", deny="Decline", loading="Loading",
           settings="Settings", close="Close", minimize="Minimize",
           playerinfo="Player Info", back="Back",
           colorpick="Pick Color", windowsize="Window Size",
           small="Small", normal="Normal", large="Large",
           eula_title="User Agreement",
           eula_body=[[By using this software you agree to the following terms:

  1. This script is for personal and educational use only.
  2. Using it to harm other players is strictly forbidden.
  3. You assume full responsibility for any account bans.
  4. The developer cannot be held liable for any damage.
  5. This script contains 18+ content; users must be 18+.
  6. Redistributing or selling this script is not allowed.

By continuing you confirm you have read all terms.]],
           steps={"Starting...","Loading player data...","Loading modules...","Building UI...","Ready!"} },

    DE = { accept="Akzeptieren", deny="Ablehnen", loading="Lädt",
           settings="Einstellungen", close="Schließen", minimize="Minimieren",
           playerinfo="Spielerinfo", back="Zurück",
           colorpick="Farbe wählen", windowsize="Fenstergröße",
           small="Klein", normal="Normal", large="Groß",
           eula_title="Nutzungsvereinbarung",
           eula_body=[[Durch die Nutzung dieser Software stimmen Sie zu:

  1. Dieses Skript dient nur persönlichen & Bildungszwecken.
  2. Verwendung zum Schaden anderer Spieler ist verboten.
  3. Sie tragen die volle Verantwortung für Account-Sperren.
  4. Der Entwickler haftet nicht für entstandene Schäden.
  5. Dieses Skript enthält 18+ Inhalte; Benutzer müssen 18+ sein.
  6. Weiterverbreitung oder Verkauf ist nicht gestattet.]],
           steps={"Starte...","Spielerdaten laden...","Module laden...","UI erstellen...","Fertig!"} },

    FR = { accept="Accepter", deny="Refuser", loading="Chargement",
           settings="Paramètres", close="Fermer", minimize="Réduire",
           playerinfo="Infos Joueur", back="Retour",
           colorpick="Choisir couleur", windowsize="Taille fenêtre",
           small="Petit", normal="Normal", large="Grand",
           eula_title="Accord d'utilisation",
           eula_body=[[En utilisant ce logiciel vous acceptez les conditions suivantes:

  1. Ce script est uniquement à usage personnel et éducatif.
  2. L'utilisation pour nuire à d'autres joueurs est interdite.
  3. Vous assumez l'entière responsabilité des bannissements.
  4. Le développeur décline toute responsabilité.
  5. Ce script contient du contenu 18+; les utilisateurs doivent avoir 18+.
  6. La redistribution ou la vente est strictement interdite.]],
           steps={"Démarrage...","Chargement joueur...","Chargement modules...","Construction UI...","Prêt!"} },

    ES = { accept="Aceptar", deny="Rechazar", loading="Cargando",
           settings="Ajustes", close="Cerrar", minimize="Minimizar",
           playerinfo="Info Jugador", back="Volver",
           colorpick="Elegir color", windowsize="Tamaño ventana",
           small="Pequeño", normal="Normal", large="Grande",
           eula_title="Acuerdo de usuario",
           eula_body=[[Al usar este software aceptas los siguientes términos:

  1. Este script es solo para uso personal y educativo.
  2. Usarlo para dañar a otros jugadores está prohibido.
  3. Asumes plena responsabilidad por baneo de tu cuenta.
  4. El desarrollador no se hace responsable de daños.
  5. Este script contiene contenido +18; debes tener 18+.
  6. Redistribuir o vender este script está prohibido.]],
           steps={"Iniciando...","Cargando jugador...","Cargando módulos...","Construyendo UI...","¡Listo!"} },

    IT = { accept="Accetta", deny="Rifiuta", loading="Caricamento",
           settings="Impostazioni", close="Chiudi", minimize="Minimizza",
           playerinfo="Info Giocatore", back="Indietro",
           colorpick="Scegli colore", windowsize="Dimensione finestra",
           small="Piccolo", normal="Normale", large="Grande",
           eula_title="Accordo utente",
           eula_body=[[Usando questo software accetti i seguenti termini:

  1. Questo script è solo per uso personale ed educativo.
  2. Usarlo per danneggiare altri giocatori è vietato.
  3. Assumi piena responsabilità per i ban dell'account.
  4. Lo sviluppatore non è responsabile per danni.
  5. Questo script contiene contenuti 18+; devi avere 18+.
  6. La redistribuzione o vendita è strettamente vietata.]],
           steps={"Avvio...","Caricamento giocatore...","Caricamento moduli...","Costruzione UI...","Pronto!"} },

    PT = { accept="Aceitar", deny="Recusar", loading="Carregando",
           settings="Configurações", close="Fechar", minimize="Minimizar",
           playerinfo="Info Jogador", back="Voltar",
           colorpick="Escolher cor", windowsize="Tamanho janela",
           small="Pequeno", normal="Normal", large="Grande",
           eula_title="Acordo do usuário",
           eula_body=[[Ao usar este software você concorda com os seguintes termos:

  1. Este script é apenas para uso pessoal e educacional.
  2. Usá-lo para prejudicar outros jogadores é proibido.
  3. Você assume total responsabilidade por banimentos.
  4. O desenvolvedor não é responsável por danos.
  5. Este script contém conteúdo 18+; você deve ter 18+.
  6. Redistribuir ou vender este script é estritamente proibido.]],
           steps={"Iniciando...","Carregando jogador...","Carregando módulos...","Construindo UI...","Pronto!"} },

    RU = { accept="Принять", deny="Отклонить", loading="Загрузка",
           settings="Настройки", close="Закрыть", minimize="Свернуть",
           playerinfo="Инфо игрока", back="Назад",
           colorpick="Выбор цвета", windowsize="Размер окна",
           small="Маленький", normal="Нормальный", large="Большой",
           eula_title="Пользовательское соглашение",
           eula_body=[[Используя данное ПО, вы соглашаетесь со следующими условиями:

  1. Данный скрипт только для личного и учебного использования.
  2. Использование для вреда другим игрокам запрещено.
  3. Вы несете полную ответственность за бан аккаунта.
  4. Разработчик не несет ответственности за ущерб.
  5. Скрипт содержит контент 18+; пользователь должен быть 18+.
  6. Распространение или продажа скрипта строго запрещены.]],
           steps={"Запуск...","Загрузка игрока...","Загрузка модулей...","Создание интерфейса...","Готово!"} },

    ZH = { accept="接受", deny="拒绝", loading="加载中",
           settings="设置", close="关闭", minimize="最小化",
           playerinfo="玩家信息", back="返回",
           colorpick="选择颜色", windowsize="窗口大小",
           small="小", normal="正常", large="大",
           eula_title="用户协议",
           eula_body=[[使用本软件即表示您同意以下条款：

  1. 本脚本仅供个人和教育用途。
  2. 禁止用于伤害其他玩家。
  3. 您对账号封禁风险承担全部责任。
  4. 开发者不对任何损失负责。
  5. 本脚本包含18+内容；用户必须年满18岁。
  6. 严禁重新分发或出售本脚本。]],
           steps={"启动中...","加载玩家数据...","加载模块...","构建界面...","就绪!"} },

    JA = { accept="同意する", deny="拒否する", loading="読込中",
           settings="設定", close="閉じる", minimize="最小化",
           playerinfo="プレイヤー情報", back="戻る",
           colorpick="色を選択", windowsize="ウィンドウサイズ",
           small="小", normal="標準", large="大",
           eula_title="利用規約",
           eula_body=[[このソフトウェアを使用することで、以下の条件に同意したものとみなされます：

  1. このスクリプトは個人・教育目的のみです。
  2. 他のプレイヤーを傷つける目的での使用は禁止です。
  3. アカウントのBanリスクは自己責任です。
  4. 開発者はいかなる損害にも責任を負いません。
  5. 18+コンテンツを含みます；18歳以上限定です。
  6. 再配布・販売は厳禁です。]],
           steps={"起動中...","プレイヤー読込...","モジュール読込...","UI構築...","完了!"} },

    KO = { accept="동의", deny="거부", loading="로딩중",
           settings="설정", close="닫기", minimize="최소화",
           playerinfo="플레이어 정보", back="뒤로",
           colorpick="색상 선택", windowsize="창 크기",
           small="작게", normal="보통", large="크게",
           eula_title="이용 약관",
           eula_body=[[이 소프트웨어를 사용함으로써 다음 약관에 동의합니다:

  1. 이 스크립트는 개인 및 교육 목적으로만 사용됩니다.
  2. 다른 플레이어를 해치기 위해 사용하는 것은 금지됩니다.
  3. 계정 밴의 위험은 전적으로 본인이 부담합니다.
  4. 개발자는 어떠한 손해에도 책임을 지지 않습니다.
  5. 이 스크립트는 18+ 콘텐츠를 포함합니다.
  6. 재배포 또는 판매는 엄격히 금지됩니다.]],
           steps={"시작중...","플레이어 로딩...","모듈 로딩...","UI 구성...","준비완료!"} },

    AR = { accept="قبول", deny="رفض", loading="جاري التحميل",
           settings="الإعدادات", close="إغلاق", minimize="تصغير",
           playerinfo="معلومات اللاعب", back="رجوع",
           colorpick="اختر لوناً", windowsize="حجم النافذة",
           small="صغير", normal="عادي", large="كبير",
           eula_title="اتفاقية المستخدم",
           eula_body=[[باستخدامك لهذا البرنامج فأنت توافق على الشروط التالية:

  1. هذا السكريبت للاستخدام الشخصي والتعليمي فقط.
  2. يُحظر استخدامه للإضرار بالاعبين الآخرين.
  3. تتحمل المسؤولية الكاملة عن حظر حسابك.
  4. المطور غير مسؤول عن أي أضرار.
  5. يحتوي هذا السكريبت على محتوى +18.
  6. يُحظر إعادة التوزيع أو البيع.]],
           steps={"جارٍ البدء...","تحميل بيانات اللاعب...","تحميل الوحدات...","بناء الواجهة...","جاهز!"} },

    PL = { accept="Akceptuj", deny="Odrzuć", loading="Ładowanie",
           settings="Ustawienia", close="Zamknij", minimize="Minimalizuj",
           playerinfo="Info gracza", back="Wróć",
           colorpick="Wybierz kolor", windowsize="Rozmiar okna",
           small="Mały", normal="Normalny", large="Duży",
           eula_title="Umowa użytkownika",
           eula_body=[[Korzystając z tego oprogramowania akceptujesz warunki:

  1. Ten skrypt służy wyłącznie do użytku osobistego i edukacyjnego.
  2. Używanie go do krzywdzenia innych graczy jest zabronione.
  3. Ponosisz pełną odpowiedzialność za bany konta.
  4. Deweloper nie ponosi odpowiedzialności za żadne szkody.
  5. Ten skrypt zawiera treści 18+; musisz mieć 18+.
  6. Redystrybucja lub sprzedaż jest surowo zabroniona.]],
           steps={"Uruchamianie...","Ładowanie gracza...","Ładowanie modułów...","Budowanie UI...","Gotowe!"} },

    NL = { accept="Accepteren", deny="Weigeren", loading="Laden",
           settings="Instellingen", close="Sluiten", minimize="Minimaliseren",
           playerinfo="Spelerinfo", back="Terug",
           colorpick="Kleur kiezen", windowsize="Venstergrootte",
           small="Klein", normal="Normaal", large="Groot",
           eula_title="Gebruikersovereenkomst",
           eula_body=[[Door deze software te gebruiken ga je akkoord met de volgende voorwaarden:

  1. Dit script is alleen voor persoonlijk en educatief gebruik.
  2. Gebruik om andere spelers te schaden is verboden.
  3. Je draagt volledige verantwoordelijkheid voor accountbans.
  4. De ontwikkelaar is niet aansprakelijk voor schade.
  5. Dit script bevat 18+ inhoud; gebruikers moeten 18+ zijn.
  6. Herdistributie of verkoop is strikt verboden.]],
           steps={"Starten...","Speler laden...","Modules laden...","UI bouwen...","Klaar!"} },

    SV = { accept="Acceptera", deny="Neka", loading="Laddar",
           settings="Inställningar", close="Stäng", minimize="Minimera",
           playerinfo="Spelarinfo", back="Tillbaka",
           colorpick="Välj färg", windowsize="Fönsterstorlek",
           small="Liten", normal="Normal", large="Stor",
           eula_title="Användaravtal",
           eula_body=[[Genom att använda denna programvara godkänner du:

  1. Detta skript är endast för personligt och utbildningssyfte.
  2. Att använda det för att skada andra spelare är förbjudet.
  3. Du tar fullt ansvar för kontoavstängningar.
  4. Utvecklaren ansvarar inte för några skador.
  5. Skriptet innehåller 18+ innehåll; du måste vara 18+.
  6. Vidaredistribution eller försäljning är strängt förbjudet.]],
           steps={"Startar...","Laddar spelare...","Laddar moduler...","Bygger UI...","Klar!"} },

    NO = { accept="Godta", deny="Avslå", loading="Laster",
           settings="Innstillinger", close="Lukk", minimize="Minimer",
           playerinfo="Spillerinfo", back="Tilbake",
           colorpick="Velg farge", windowsize="Vindusstørrelse",
           small="Liten", normal="Normal", large="Stor",
           eula_title="Brukeravtale",
           eula_body=[[Ved å bruke denne programvaren godtar du:

  1. Dette skriptet er kun for personlig og utdanningsmessig bruk.
  2. Bruk for å skade andre spillere er forbudt.
  3. Du tar fullt ansvar for kontoutestengelser.
  4. Utvikleren er ikke ansvarlig for skader.
  5. Skriptet inneholder 18+ innhold; du må være 18+.
  6. Videredistribusjon eller salg er strengt forbudt.]],
           steps={"Starter...","Laster spiller...","Laster moduler...","Bygger UI...","Klar!"} },

    DA = { accept="Accepter", deny="Afvis", loading="Indlæser",
           settings="Indstillinger", close="Luk", minimize="Minimer",
           playerinfo="Spillerinfo", back="Tilbage",
           colorpick="Vælg farve", windowsize="Vinduesstørrelse",
           small="Lille", normal="Normal", large="Stor",
           eula_title="Brugeraftale",
           eula_body=[[Ved at bruge denne software accepterer du:

  1. Dette script er kun til personlig og uddannelsesmæssig brug.
  2. Brug til at skade andre spillere er forbudt.
  3. Du tager fuldt ansvar for kontobaneringer.
  4. Udvikleren er ikke ansvarlig for skader.
  5. Scriptet indeholder 18+ indhold; du skal være 18+.
  6. Videredistribution eller salg er strengt forbudt.]],
           steps={"Starter...","Indlæser spiller...","Indlæser moduler...","Bygger UI...","Klar!"} },

    FI = { accept="Hyväksy", deny="Hylkää", loading="Ladataan",
           settings="Asetukset", close="Sulje", minimize="Pienennä",
           playerinfo="Pelaajatiedot", back="Takaisin",
           colorpick="Valitse väri", windowsize="Ikkunan koko",
           small="Pieni", normal="Normaali", large="Suuri",
           eula_title="Käyttäjäsopimus",
           eula_body=[[Käyttämällä tätä ohjelmistoa hyväksyt seuraavat ehdot:

  1. Tämä skripti on tarkoitettu vain henkilökohtaiseen ja opetuskäyttöön.
  2. Käyttö muiden pelaajien vahingoittamiseen on kielletty.
  3. Otat täyden vastuun tilin porttikielloista.
  4. Kehittäjä ei ole vastuussa mistään vahingoista.
  5. Skripti sisältää 18+ sisältöä; sinun on oltava 18+.
  6. Uudelleenjakelu tai myynti on ehdottomasti kielletty.]],
           steps={"Käynnistetään...","Ladataan pelaajaa...","Ladataan moduuleja...","Rakennetaan UI...","Valmis!"} },
}

-- ════════════════════════════════════════════════════════════
--  RENK PALETİ
-- ════════════════════════════════════════════════════════════
local C = {
    HOT     = Color3.fromRGB(255, 25, 118),
    MID     = Color3.fromRGB(230, 10,  98),
    DEEP    = Color3.fromRGB(195,  0,  82),
    DARK    = Color3.fromRGB(140,  0,  56),
    DARKEST = Color3.fromRGB( 80,  0,  32),
    PANEL   = Color3.fromRGB( 20,  3,  12),
    PANELBG = Color3.fromRGB( 14,  2,   9),
    WHITE   = Color3.new(1,1,1),
    TEXT2   = Color3.fromRGB(255,190,215),
    NEON    = Color3.fromRGB(255, 80, 160),
    STROKE  = Color3.fromRGB(255,120,180),
}

-- ════════════════════════════════════════════════════════════
--  YARDIMCI FONKSİYONLAR
-- ════════════════════════════════════════════════════════════
local function Cr(p,r)
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c
end
local function St(p,col,th,tr)
    local s=Instance.new("UIStroke") s.Color=col or C.STROKE
    s.Thickness=th or 1 s.Transparency=tr or 0.4 s.Parent=p return s
end
local function Lbl(p,txt,sz,col,fnt,xa,ya)
    local l=Instance.new("TextLabel")
    l.Text=txt l.TextSize=sz or 13
    l.TextColor3=col or C.WHITE
    l.Font=fnt or Enum.Font.GothamSemibold
    l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.TextYAlignment=ya or Enum.TextYAlignment.Center
    l.Parent=p return l
end
local function Tw(o,t,props)
    pcall(function()
        TweenSvc:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
    end)
end
local function TwBack(o,t,props)
    pcall(function()
        TweenSvc:Create(o,TweenInfo.new(t,Enum.EasingStyle.Back,Enum.EasingDirection.Out),props):Play()
    end)
end
local function TwSine(o,t,props)
    pcall(function()
        TweenSvc:Create(o,TweenInfo.new(t,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),props):Play()
    end)
end

-- ════════════════════════════════════════════════════════════
--  KÜTÜPHANE
-- ════════════════════════════════════════════════════════════
local Lib = {}

function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local winTitle = cfg.Title    or "S3xy Hub"
    local winSub   = cfg.SubTitle or "v5.0"
    local lang     = LANGS[cfg.Language or "TR"] or LANGS["TR"]

    -- Eski GUI temizle
    pcall(function()
        local cont = GetContainer()
        if cont then
            local old = cont:FindFirstChild("S3xyHub_GUI")
            if old then old:Destroy() end
        end
        local old2 = LP.PlayerGui:FindFirstChild("S3xyHub_GUI")
        if old2 then old2:Destroy() end
    end)

    local container = GetContainer()
    if not container then warn("[S3xyHub] Container bulunamadi!") return end

    -- ── ScreenGui ────────────────────────────────────────────
    local SG = Instance.new("ScreenGui")
    SG.Name           = "S3xyHub_GUI"
    SG.ResetOnSpawn   = false
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() SG.DisplayOrder   = 999 end)
    pcall(function() SG.IgnoreGuiInset = true end)
    SG.Parent = container

    -- ════════════════════════════════════════════════════════
    --  NEON ARKA PLAN  (ScreenGui'nin ARKASINDA — ZIndex 1-3)
    --  Sadece SplashFrame + EulaFrame + Main'in arkasında
    -- ════════════════════════════════════════════════════════
    local BG = Instance.new("Frame")
    BG.Name             = "NeonBG"
    BG.Size             = UDim2.new(1,0,1,0)
    BG.BackgroundColor3 = Color3.fromRGB(10,1,6)
    BG.BorderSizePixel  = 0
    BG.ZIndex           = 1
    BG.Parent           = SG

    -- Neon glow daireleri
    local glows = {
        {0.12,0.20,320,0.48,Color3.fromRGB(255,20,110)},
        {0.78,0.70,360,0.44,Color3.fromRGB(200,0,82)},
        {0.50,0.45,480,0.58,Color3.fromRGB(120,0,48)},
        {0.90,0.12,200,0.52,Color3.fromRGB(255,55,135)},
        {0.08,0.82,220,0.50,Color3.fromRGB(255,35,118)},
        {0.35,0.85,180,0.55,Color3.fromRGB(180,0,72)},
        {0.65,0.10,160,0.54,Color3.fromRGB(255,60,140)},
    }
    for _,g in ipairs(glows) do
        local gl=Instance.new("ImageLabel")
        gl.Size=UDim2.new(0,g[3],0,g[3])
        gl.Position=UDim2.new(g[1],-g[3]/2,g[2],-g[3]/2)
        gl.BackgroundTransparency=1
        gl.Image="rbxassetid://5028857084"
        gl.ImageColor3=g[5]
        gl.ImageTransparency=g[4]
        gl.ZIndex=2 gl.Parent=BG
    end

    -- Grid çizgiler (hafif)
    for i=1,9 do
        local h=Instance.new("Frame")
        h.Size=UDim2.new(1,0,0,1)
        h.Position=UDim2.new(0,0,i/10,0)
        h.BackgroundColor3=C.NEON h.BackgroundTransparency=0.88
        h.BorderSizePixel=0 h.ZIndex=3 h.Parent=BG
    end
    for i=1,13 do
        local v=Instance.new("Frame")
        v.Size=UDim2.new(0,1,1,0)
        v.Position=UDim2.new(i/14,0,0,0)
        v.BackgroundColor3=C.NEON v.BackgroundTransparency=0.88
        v.BorderSizePixel=0 v.ZIndex=3 v.Parent=BG
    end

    -- Yüzen dekoratif semboller
    local decor = {
        {"♥",0.04,0.06,40,-12,0.22},{"♥",0.93,0.10,30,18,0.26},
        {"♥",0.16,0.90,34,-6,0.20},{"♥",0.84,0.80,26,10,0.24},
        {"♥",0.48,0.04,22,-22,0.18},{"♥",0.33,0.95,30,4,0.22},
        {"♥",0.72,0.03,36,-8,0.20},{"♥",0.60,0.92,20,15,0.16},
        {"18+",0.94,0.48,18,6,0.16},{"18+",0.03,0.52,16,-10,0.14},
        {"18+",0.52,0.97,15,5,0.14},{"18+",0.20,0.03,17,8,0.13},
        {"★",0.24,0.03,26,28,0.16},{"★",0.80,0.92,20,-18,0.16},
        {"★",0.97,0.78,16,12,0.13},{"★",0.02,0.22,18,-5,0.14},
        {"✦",0.10,0.44,18,0,0.18},{"✦",0.90,0.56,14,45,0.16},
        {"✦",0.45,0.01,16,22,0.14},{"✦",0.58,0.96,12,-30,0.13},
    }
    for _,d in ipairs(decor) do
        local sl=Instance.new("TextLabel")
        sl.Text=d[1] sl.TextSize=d[4]
        sl.TextColor3=C.NEON sl.TextTransparency=d[6]
        sl.Font=Enum.Font.GothamBold sl.BackgroundTransparency=1
        sl.Position=UDim2.new(d[2],0,d[3],0)
        sl.Size=UDim2.new(0,70,0,44) sl.Rotation=d[5]
        sl.ZIndex=3 sl.Parent=BG
    end

    -- Sembolleri yavaş yavaş animasyon — pulse
    task.spawn(function()
        while SG and SG.Parent do
            for _,c in ipairs(BG:GetChildren()) do
                if c:IsA("TextLabel") then
                    TwSine(c,2+math.random()*2,{TextTransparency=c.TextTransparency+0.08})
                    task.wait(0.1)
                    TwSine(c,2+math.random()*2,{TextTransparency=math.max(0.10,c.TextTransparency-0.08)})
                end
            end
            task.wait(3)
        end
    end)

    -- ════════════════════════════════════════════════════════
    --  EULA EKRANI  (ZIndex 20)
    -- ════════════════════════════════════════════════════════
    local EF = Instance.new("Frame")
    EF.Size=UDim2.new(0,450,0,320) EF.Position=UDim2.new(0.5,-225,0.5,-160)
    EF.BackgroundColor3=C.PANELBG EF.BorderSizePixel=0
    EF.ZIndex=20 EF.Parent=SG
    Cr(EF,16) St(EF,C.STROKE,2,0.05)

    -- İnce üst çizgi renk
    local ETop=Instance.new("Frame")
    ETop.Size=UDim2.new(1,0,0,3) ETop.BackgroundColor3=C.HOT
    ETop.BorderSizePixel=0 ETop.ZIndex=21 ETop.Parent=EF
    Cr(ETop,16)

    local ETitle=Lbl(EF,lang.eula_title,16,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    ETitle.Size=UDim2.new(1,0,0,44) ETitle.ZIndex=21

    local ESep=Instance.new("Frame")
    ESep.Size=UDim2.new(1,-28,0,1) ESep.Position=UDim2.new(0,14,0,44)
    ESep.BackgroundColor3=C.NEON ESep.BackgroundTransparency=0.5
    ESep.BorderSizePixel=0 ESep.ZIndex=21 ESep.Parent=EF

    -- Dil seçici (dropdown basit)
    local LangBtn=Instance.new("TextButton")
    LangBtn.Text="Lang" LangBtn.Size=UDim2.new(0,52,0,22)
    LangBtn.Position=UDim2.new(1,-60,0,11)
    LangBtn.BackgroundColor3=C.DARK LangBtn.TextColor3=C.TEXT2
    LangBtn.Font=Enum.Font.GothamBold LangBtn.TextSize=10
    LangBtn.BorderSizePixel=0 LangBtn.ZIndex=22 LangBtn.Parent=EF
    Cr(LangBtn,5)

    -- Dil dropdown
    local LangDrop=Instance.new("Frame")
    LangDrop.Size=UDim2.new(0,90,0,0)
    LangDrop.Position=UDim2.new(1,-94,0,34)
    LangDrop.BackgroundColor3=C.PANELBG LangDrop.BorderSizePixel=0
    LangDrop.ClipsDescendants=true LangDrop.ZIndex=30 LangDrop.Parent=EF
    Cr(LangDrop,8) St(LangDrop,C.STROKE,1,0.3)

    local DDLayout=Instance.new("UIListLayout")
    DDLayout.Padding=UDim.new(0,2) DDLayout.Parent=LangDrop

    local langOpen=false
    local langNames={"TR","EN","DE","FR","ES","IT","PT","RU","ZH","JA","KO","AR","PL","NL","SV","NO","DA","FI"}

    for _,ln in ipairs(langNames) do
        local lb2=Instance.new("TextButton")
        lb2.Text=ln lb2.Size=UDim2.new(1,0,0,22)
        lb2.BackgroundColor3=C.DARK lb2.BackgroundTransparency=0.3
        lb2.TextColor3=C.WHITE lb2.Font=Enum.Font.GothamSemibold
        lb2.TextSize=11 lb2.BorderSizePixel=0 lb2.ZIndex=31 lb2.Parent=LangDrop
        Cr(lb2,4)
        lb2.MouseButton1Click:Connect(function()
            lang=LANGS[ln] or LANGS["TR"]
            ETitle.Text=lang.eula_title
            EBodyTxt.Text=lang.eula_body
            EAccept.Text=lang.accept
            EDeny.Text=lang.deny
            langOpen=false
            Tw(LangDrop,0.2,{Size=UDim2.new(0,90,0,0)})
        end)
    end

    LangBtn.MouseButton1Click:Connect(function()
        langOpen=not langOpen
        if langOpen then
            Tw(LangDrop,0.2,{Size=UDim2.new(0,90,0,#langNames*24+4)})
        else
            Tw(LangDrop,0.2,{Size=UDim2.new(0,90,0,0)})
        end
    end)

    -- EULA metni
    local EBodyTxt=Instance.new("TextLabel")
    EBodyTxt.Size=UDim2.new(1,-28,0,185) EBodyTxt.Position=UDim2.new(0,14,0,50)
    EBodyTxt.BackgroundTransparency=1 EBodyTxt.TextColor3=C.TEXT2
    EBodyTxt.Font=Enum.Font.Gotham EBodyTxt.TextSize=11
    EBodyTxt.TextWrapped=true EBodyTxt.TextXAlignment=Enum.TextXAlignment.Left
    EBodyTxt.TextYAlignment=Enum.TextYAlignment.Top
    EBodyTxt.ZIndex=21 EBodyTxt.Text=lang.eula_body EBodyTxt.Parent=EF

    local EDeny=Instance.new("TextButton")
    EDeny.Text=lang.deny EDeny.Size=UDim2.new(0,130,0,36)
    EDeny.Position=UDim2.new(0.5,-138,1,-46)
    EDeny.BackgroundColor3=Color3.fromRGB(50,8,22)
    EDeny.TextColor3=C.TEXT2 EDeny.Font=Enum.Font.GothamBold
    EDeny.TextSize=13 EDeny.BorderSizePixel=0 EDeny.ZIndex=22 EDeny.Parent=EF
    Cr(EDeny,9)

    local EAccept=Instance.new("TextButton")
    EAccept.Text=lang.accept EAccept.Size=UDim2.new(0,130,0,36)
    EAccept.Position=UDim2.new(0.5,8,1,-46)
    EAccept.BackgroundColor3=C.HOT EAccept.TextColor3=C.WHITE
    EAccept.Font=Enum.Font.GothamBold EAccept.TextSize=13
    EAccept.BorderSizePixel=0 EAccept.ZIndex=22 EAccept.Parent=EF
    Cr(EAccept,9) St(EAccept,Color3.fromRGB(255,160,200),1.5,0.2)

    EDeny.MouseButton1Click:Connect(function()
        Tw(EF,0.3,{BackgroundTransparency=1})
        Tw(BG,0.3,{BackgroundTransparency=1})
        task.delay(0.35,function() SG:Destroy() end)
    end)

    -- ════════════════════════════════════════════════════════
    --  SPLASH EKRANI  (ZIndex 15, EULA kabul sonrası)
    -- ════════════════════════════════════════════════════════
    local SF=Instance.new("Frame")
    SF.Size=UDim2.new(0,360,0,210) SF.Position=UDim2.new(0.5,-180,0.5,-105)
    SF.BackgroundColor3=C.PANELBG SF.BorderSizePixel=0
    SF.ZIndex=15 SF.Visible=false SF.Parent=SG
    Cr(SF,18) St(SF,C.STROKE,2,0.05)

    -- Üst renk çizgi
    local STop=Instance.new("Frame")
    STop.Size=UDim2.new(1,0,0,3) STop.BackgroundColor3=C.HOT
    STop.BorderSizePixel=0 STop.ZIndex=16 STop.Parent=SF
    Cr(STop,18)

    -- Logo glow
    local SLGlow=Instance.new("ImageLabel")
    SLGlow.Size=UDim2.new(0,100,0,100) SLGlow.Position=UDim2.new(0.5,-50,0,16)
    SLGlow.BackgroundTransparency=1 SLGlow.Image="rbxassetid://5028857084"
    SLGlow.ImageColor3=C.HOT SLGlow.ImageTransparency=0.18
    SLGlow.ZIndex=16 SLGlow.Parent=SF

    local SLIcon=Lbl(SF,"S",40,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    SLIcon.Size=UDim2.new(0,54,0,54) SLIcon.Position=UDim2.new(0.5,-27,0,29)
    SLIcon.ZIndex=17

    local SLTitle=Lbl(SF,"S3xy Hub",21,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    SLTitle.Size=UDim2.new(1,0,0,26) SLTitle.Position=UDim2.new(0,0,0,116) SLTitle.ZIndex=16

    local SLSub=Lbl(SF,winTitle,12,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
    SLSub.Size=UDim2.new(1,0,0,16) SLSub.Position=UDim2.new(0,0,0,142) SLSub.ZIndex=16

    local BarBG=Instance.new("Frame")
    BarBG.Size=UDim2.new(0,280,0,4) BarBG.Position=UDim2.new(0.5,-140,1,-24)
    BarBG.BackgroundColor3=C.DARKEST BarBG.BorderSizePixel=0
    BarBG.ZIndex=16 BarBG.Parent=SF
    Cr(BarBG,2)

    local BarFill=Instance.new("Frame")
    BarFill.Size=UDim2.new(0,0,1,0) BarFill.BackgroundColor3=C.HOT
    BarFill.BorderSizePixel=0 BarFill.ZIndex=17 BarFill.Parent=BarBG
    Cr(BarFill,2)

    local BarGrad=Instance.new("UIGradient")
    BarGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,100,170)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,20,100)),
    })
    BarGrad.Parent=BarFill

    local LoadLbl=Lbl(SF,lang.loading.."...",10,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
    LoadLbl.Size=UDim2.new(1,0,0,14) LoadLbl.Position=UDim2.new(0,0,1,-40) LoadLbl.ZIndex=16

    -- ════════════════════════════════════════════════════════
    --  ANA GUI  (ZIndex 10, splash sonrası)
    -- ════════════════════════════════════════════════════════
    local Main=Instance.new("Frame")
    Main.Name="Main" Main.Size=UDim2.new(0,590,0,345)
    Main.Position=UDim2.new(0.5,-295,0.5,-172)
    Main.BackgroundColor3=Color3.fromRGB(16,2,10)
    Main.BorderSizePixel=0 Main.ClipsDescendants=true
    Main.ZIndex=10 Main.Visible=false Main.Parent=SG
    Cr(Main,14) St(Main,C.STROKE,2,0.05)

    -- Arka plan gradient
    local MG=Instance.new("UIGradient")
    MG.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(24,4,15)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(14,2,9)),
    })
    MG.Rotation=135 MG.Parent=Main

    -- ── TopBar ────────────────────────────────────────────
    local TB=Instance.new("Frame")
    TB.Size=UDim2.new(1,0,0,40) TB.BackgroundColor3=C.DEEP
    TB.BorderSizePixel=0 TB.ZIndex=12 TB.Parent=Main
    Cr(TB,14)

    local TBGrad=Instance.new("UIGradient")
    TBGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,35,118)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(185,0,78)),
    })
    TBGrad.Rotation=90 TBGrad.Parent=TB

    -- Marka
    local BrandLbl=Lbl(TB,"S3xy Hub",18,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    BrandLbl.Size=UDim2.new(1,0,1,0) BrandLbl.ZIndex=13

    -- Kapat
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Text="x" CloseBtn.Size=UDim2.new(0,26,0,26)
    CloseBtn.Position=UDim2.new(1,-30,0,7)
    CloseBtn.BackgroundColor3=Color3.fromRGB(190,25,72)
    CloseBtn.TextColor3=C.WHITE CloseBtn.Font=Enum.Font.GothamBold
    CloseBtn.TextSize=12 CloseBtn.BorderSizePixel=0
    CloseBtn.ZIndex=14 CloseBtn.Parent=TB
    Cr(CloseBtn,6)

    -- Küçült
    local MinBtn=Instance.new("TextButton")
    MinBtn.Text="-" MinBtn.Size=UDim2.new(0,26,0,26)
    MinBtn.Position=UDim2.new(1,-60,0,7)
    MinBtn.BackgroundColor3=C.DARK MinBtn.TextColor3=C.WHITE
    MinBtn.Font=Enum.Font.GothamBold MinBtn.TextSize=15
    MinBtn.BorderSizePixel=0 MinBtn.ZIndex=14 MinBtn.Parent=TB
    Cr(MinBtn,6)

    -- ── Sidebar  132px ───────────────────────────────────
    local SB=Instance.new("Frame")
    SB.Size=UDim2.new(0,132,1,-40) SB.Position=UDim2.new(0,0,0,40)
    SB.BackgroundColor3=Color3.fromRGB(12,1,7)
    SB.BorderSizePixel=0 SB.ClipsDescendants=true
    SB.ZIndex=11 SB.Parent=Main

    -- Sidebar sağ kenar çizgi
    local SBLine=Instance.new("Frame")
    SBLine.Size=UDim2.new(0,1,1,0) SBLine.Position=UDim2.new(1,-1,0,0)
    SBLine.BackgroundColor3=C.NEON SBLine.BackgroundTransparency=0.55
    SBLine.BorderSizePixel=0 SBLine.ZIndex=12 SBLine.Parent=SB

    -- ── Player Kutusu ────────────────────────────────────
    local PBox=Instance.new("Frame")
    PBox.Size=UDim2.new(1,-10,0,74) PBox.Position=UDim2.new(0,5,0,6)
    PBox.BackgroundColor3=Color3.fromRGB(26,4,16)
    PBox.BackgroundTransparency=0.05 PBox.BorderSizePixel=0
    PBox.ZIndex=12 PBox.Parent=SB
    Cr(PBox,10) St(PBox,C.STROKE,1,0.45)

    -- Player aç/kapat
    local PToggle=Instance.new("TextButton")
    PToggle.Text="v" PToggle.Size=UDim2.new(0,16,0,14)
    PToggle.Position=UDim2.new(1,-18,0,4)
    PToggle.BackgroundTransparency=1 PToggle.TextColor3=C.TEXT2
    PToggle.Font=Enum.Font.GothamBold PToggle.TextSize=9
    PToggle.BorderSizePixel=0 PToggle.ZIndex=13 PToggle.Parent=PBox

    -- Avatar
    local Av=Instance.new("ImageLabel")
    Av.Size=UDim2.new(0,38,0,38) Av.Position=UDim2.new(0,6,0.5,-19)
    Av.BackgroundColor3=C.DARK Av.BackgroundTransparency=0.3
    Av.BorderSizePixel=0 Av.ZIndex=13 Av.Parent=PBox
    Cr(Av,8)
    pcall(function()
        Av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="
            ..LP.UserId.."&width=150&height=150&format=png"
    end)

    local dname,uname="Player","unknown"
    pcall(function() dname=LP.DisplayName end)
    pcall(function() uname=LP.Name end)

    local NL=Lbl(PBox,dname,11,C.WHITE,Enum.Font.GothamBold)
    NL.Size=UDim2.new(1,-52,0,15) NL.Position=UDim2.new(0,50,0,14)
    NL.TextTruncate=Enum.TextTruncate.AtEnd NL.ZIndex=13

    local UL=Lbl(PBox,"@"..uname,9,C.TEXT2,Enum.Font.Gotham)
    UL.Size=UDim2.new(1,-52,0,13) UL.Position=UDim2.new(0,50,0,30)
    UL.TextTruncate=Enum.TextTruncate.AtEnd UL.ZIndex=13

    -- Oyuncu kutusu aç/kapat
    local pboxOpen=true
    PToggle.MouseButton1Click:Connect(function()
        pboxOpen=not pboxOpen
        if pboxOpen then
            Tw(PBox,0.22,{Size=UDim2.new(1,-10,0,74)}) PToggle.Text="v"
        else
            Tw(PBox,0.22,{Size=UDim2.new(1,-10,0,22)}) PToggle.Text=">"
        end
    end)

    -- Tab listesi
    local TBListFrame=Instance.new("Frame")
    TBListFrame.Size=UDim2.new(1,-10,1,-88) TBListFrame.Position=UDim2.new(0,5,0,84)
    TBListFrame.BackgroundTransparency=1 TBListFrame.ClipsDescendants=true
    TBListFrame.ZIndex=12 TBListFrame.Parent=SB

    local TBLL=Instance.new("UIListLayout")
    TBLL.Padding=UDim.new(0,4) TBLL.SortOrder=Enum.SortOrder.LayoutOrder TBLL.Parent=TBListFrame

    -- Gear butonu
    local GearBtn=Instance.new("TextButton")
    GearBtn.Text="⚙" GearBtn.Size=UDim2.new(1,-10,0,24)
    GearBtn.Position=UDim2.new(0,5,1,-28)
    GearBtn.BackgroundColor3=Color3.fromRGB(20,3,12)
    GearBtn.BackgroundTransparency=0.25 GearBtn.TextColor3=C.TEXT2
    GearBtn.Font=Enum.Font.GothamBold GearBtn.TextSize=12
    GearBtn.BorderSizePixel=0 GearBtn.ZIndex=12 GearBtn.Parent=SB
    Cr(GearBtn,6)

    -- ── İçerik Alanı ─────────────────────────────────────
    local CA=Instance.new("Frame")
    CA.Size=UDim2.new(1,-138,1,-40) CA.Position=UDim2.new(0,136,0,40)
    CA.BackgroundColor3=Color3.fromRGB(18,3,11)
    CA.BorderSizePixel=0 CA.ClipsDescendants=true
    CA.ZIndex=11 CA.Parent=Main
    Cr(CA,10)

    -- ── Ayarlar Paneli ────────────────────────────────────
    local CustPanel=Instance.new("Frame")
    CustPanel.Size=UDim2.new(1,0,1,0)
    CustPanel.BackgroundColor3=Color3.fromRGB(14,2,9)
    CustPanel.BorderSizePixel=0 CustPanel.Visible=false
    CustPanel.ZIndex=20 CustPanel.Parent=CA
    Cr(CustPanel,10)

    -- Üst çizgi
    local CTop=Instance.new("Frame")
    CTop.Size=UDim2.new(1,0,0,3) CTop.BackgroundColor3=C.HOT
    CTop.BorderSizePixel=0 CTop.ZIndex=21 CTop.Parent=CustPanel
    Cr(CTop,10)

    local CTitle=Lbl(CustPanel,lang.settings,15,C.WHITE,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    CTitle.Size=UDim2.new(1,0,0,40) CTitle.ZIndex=21

    local CBack=Instance.new("TextButton")
    CBack.Text=lang.back CBack.Size=UDim2.new(0,58,0,22)
    CBack.Position=UDim2.new(1,-66,0,9)
    CBack.BackgroundColor3=C.DARK CBack.TextColor3=C.TEXT2
    CBack.Font=Enum.Font.GothamSemibold CBack.TextSize=11
    CBack.BorderSizePixel=0 CBack.ZIndex=22 CBack.Parent=CustPanel
    Cr(CBack,6)
    CBack.MouseButton1Click:Connect(function() CustPanel.Visible=false end)

    -- Dil seçimi (ayarlar içinde)
    local CLangLbl=Lbl(CustPanel,"Dil / Language:",11,C.TEXT2,Enum.Font.GothamSemibold)
    CLangLbl.Size=UDim2.new(1,-20,0,14) CLangLbl.Position=UDim2.new(0,10,0,46) CLangLbl.ZIndex=21

    local CLangRow=Instance.new("Frame")
    CLangRow.Size=UDim2.new(1,-18,0,44) CLangRow.Position=UDim2.new(0,9,0,62)
    CLangRow.BackgroundTransparency=1 CLangRow.ZIndex=21 CLangRow.Parent=CustPanel

    local CLangGrid=Instance.new("UIGridLayout")
    CLangGrid.CellSize=UDim2.new(0,38,0,18) CLangGrid.CellPaddingSize=UDim2.new(0,3,0,3)
    CLangGrid.Parent=CLangRow

    for _,ln in ipairs(langNames) do
        local lb3=Instance.new("TextButton")
        lb3.Text=ln lb3.BackgroundColor3=C.DARK
        lb3.BackgroundTransparency=0.3 lb3.TextColor3=C.TEXT2
        lb3.Font=Enum.Font.GothamBold lb3.TextSize=9
        lb3.BorderSizePixel=0 lb3.ZIndex=22 lb3.Parent=CLangRow
        Cr(lb3,4)
        lb3.MouseButton1Click:Connect(function()
            lang=LANGS[ln] or LANGS["TR"]
            -- UI metinleri güncelle
            GearBtn.Text="⚙"
            CTitle.Text=lang.settings
            CBack.Text=lang.back
            CCLbl.Text=lang.colorpick..":"
            CSLbl.Text=lang.windowsize..":"
        end)
    end

    -- Renk seçici
    local CCLbl=Lbl(CustPanel,lang.colorpick..":",11,C.TEXT2,Enum.Font.GothamSemibold)
    CCLbl.Size=UDim2.new(1,-20,0,14) CCLbl.Position=UDim2.new(0,10,0,112) CCLbl.ZIndex=21

    local CColorRow=Instance.new("Frame")
    CColorRow.Size=UDim2.new(1,-18,0,28) CColorRow.Position=UDim2.new(0,9,0,128)
    CColorRow.BackgroundTransparency=1 CColorRow.ZIndex=21 CColorRow.Parent=CustPanel

    local colors={
        {Color3.fromRGB(255,20,110),"Pembe/Pink"},
        {Color3.fromRGB(220,25,45),"Kırmızı/Red"},
        {Color3.fromRGB(145,30,225),"Mor/Purple"},
        {Color3.fromRGB(25,105,255),"Mavi/Blue"},
        {Color3.fromRGB(20,195,95),"Yeşil/Green"},
        {Color3.fromRGB(255,140,0),"Turuncu/Orange"},
        {Color3.fromRGB(0,195,210),"Cyan"},
        {Color3.fromRGB(255,210,0),"Sarı/Yellow"},
    }
    for i,cc in ipairs(colors) do
        local cb3=Instance.new("TextButton")
        cb3.Text="" cb3.Size=UDim2.new(0,26,0,26)
        cb3.Position=UDim2.new(0,(i-1)*30,0,0)
        cb3.BackgroundColor3=cc[1] cb3.BorderSizePixel=0
        cb3.ZIndex=22 cb3.Parent=CColorRow
        Cr(cb3,13)
        St(cb3,Color3.new(1,1,1),1.5,0.4)
        cb3.MouseButton1Click:Connect(function()
            C.HOT=cc[1] C.NEON=cc[1] C.STROKE=cc[1]
            C.DEEP=Color3.new(cc[1].R*0.78,cc[1].G*0.78,cc[1].B*0.78)
            C.DARK=Color3.new(cc[1].R*0.55,cc[1].G*0.55,cc[1].B*0.55)
            C.DARKEST=Color3.new(cc[1].R*0.32,cc[1].G*0.32,cc[1].B*0.32)
            TB.BackgroundColor3=C.DEEP
            SBLine.BackgroundColor3=cc[1]
            ETop.BackgroundColor3=cc[1]
            STop.BackgroundColor3=cc[1]
            CTop.BackgroundColor3=cc[1]
            pcall(function()
                TBGrad.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,cc[1]),
                    ColorSequenceKeypoint.new(1,C.DEEP),
                })
            end)
        end)
    end

    -- Boyut seçici
    local CSLbl=Lbl(CustPanel,lang.windowsize..":",11,C.TEXT2,Enum.Font.GothamSemibold)
    CSLbl.Size=UDim2.new(1,-20,0,14) CSLbl.Position=UDim2.new(0,10,0,162) CSLbl.ZIndex=21

    local CSizeRow=Instance.new("Frame")
    CSizeRow.Size=UDim2.new(1,-18,0,28) CSizeRow.Position=UDim2.new(0,9,0,178)
    CSizeRow.BackgroundTransparency=1 CSizeRow.ZIndex=21 CSizeRow.Parent=CustPanel

    local sizes={{480,280},{590,345},{720,430}}
    for i,sz in ipairs(sizes) do
        local snames={lang.small,lang.normal,lang.large}
        local sb2=Instance.new("TextButton")
        sb2.Text=snames[i] sb2.Size=UDim2.new(0,94,0,26)
        sb2.Position=UDim2.new(0,(i-1)*98,0,0)
        sb2.BackgroundColor3=C.DARKEST sb2.TextColor3=C.TEXT2
        sb2.Font=Enum.Font.GothamSemibold sb2.TextSize=11
        sb2.BorderSizePixel=0 sb2.ZIndex=22 sb2.Parent=CSizeRow
        Cr(sb2,6)
        sb2.MouseButton1Click:Connect(function()
            TwBack(Main,0.32,{
                Size=UDim2.new(0,sz[1],0,sz[2]),
                Position=UDim2.new(0.5,-sz[1]/2,0.5,-sz[2]/2)
            })
        end)
    end

    GearBtn.MouseButton1Click:Connect(function() CustPanel.Visible=true end)

    -- ── DRAG ────────────────────────────────────────────────
    local dragging=false
    local dragOff=Vector2.new()
    TB.InputBegan:Connect(function(inp)
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
            math.clamp(inp.Position.X-dragOff.X,0,vp.X-Main.AbsoluteSize.X),0,
            math.clamp(inp.Position.Y-dragOff.Y,0,vp.Y-Main.AbsoluteSize.Y))
    end)

    -- ── Küçült ───────────────────────────────────────────────
    local minimized=false
    MinBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            Tw(Main,0.22,{Size=UDim2.new(0,590,0,40)}) MinBtn.Text="+"
        else
            Tw(Main,0.28,{Size=UDim2.new(0,590,0,345)}) MinBtn.Text="-"
        end
    end)

    -- ── Kapat / Aç ───────────────────────────────────────────
    local OpenBtn=Instance.new("TextButton")
    OpenBtn.Text="S3xy Hub" OpenBtn.Size=UDim2.new(0,78,0,24)
    OpenBtn.Position=UDim2.new(0,10,1,-34)
    OpenBtn.BackgroundColor3=C.DEEP OpenBtn.TextColor3=C.WHITE
    OpenBtn.Font=Enum.Font.GothamBold OpenBtn.TextSize=10
    OpenBtn.BorderSizePixel=0 OpenBtn.Visible=false
    OpenBtn.ZIndex=10 OpenBtn.Parent=SG
    Cr(OpenBtn,6) St(OpenBtn,C.STROKE,1.5,0.2)

    CloseBtn.MouseButton1Click:Connect(function()
        Tw(Main,0.22,{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0,Main.AbsolutePosition.X+295,0,Main.AbsolutePosition.Y+172)})
        task.delay(0.25,function() Main.Visible=false OpenBtn.Visible=true end)
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible=false Main.Visible=true
        Main.Size=UDim2.new(0,0,0,0) Main.Position=UDim2.new(0.5,0,0.5,0)
        TwBack(Main,0.45,{Size=UDim2.new(0,590,0,345),Position=UDim2.new(0.5,-295,0.5,-172)})
    end)

    -- ════════════════════════════════════════════════════════
    --  EULA KABUL → SPLASH → MAIN AKIŞI
    -- ════════════════════════════════════════════════════════
    EAccept.MouseButton1Click:Connect(function()
        -- EULA'yı kapat (ARKA PLAN KALIR)
        Tw(EF,0.28,{BackgroundTransparency=1})
        task.delay(0.30,function()
            EF.Visible=false

            -- Splash aç
            SF.Visible=true SF.Size=UDim2.new(0,0,0,0) SF.Position=UDim2.new(0.5,0,0.5,0)
            TwBack(SF,0.48,{Size=UDim2.new(0,360,0,210),Position=UDim2.new(0.5,-180,0.5,-105)})

            -- Loading adımları
            local steps=lang.steps
            local filled=0
            for i,step in ipairs(steps) do
                task.wait(0.42)
                LoadLbl.Text=step
                filled=filled+(1/#steps)
                Tw(BarFill,0.32,{Size=UDim2.new(math.min(filled,1),0,1,0)})
            end

            task.wait(0.45)
            -- Splash kapat
            Tw(SF,0.28,{BackgroundTransparency=1})
            task.delay(0.30,function()
                SF.Visible=false
                -- Arka planı kapat (GUI açılınca arka plan kaybolur)
                Tw(BG,0.35,{BackgroundTransparency=1})
                task.delay(0.36,function() BG.Visible=false end)
                -- Main aç
                Main.Visible=true Main.Size=UDim2.new(0,0,0,0) Main.Position=UDim2.new(0.5,0,0.5,0)
                TwBack(Main,0.5,{Size=UDim2.new(0,590,0,345),Position=UDim2.new(0.5,-295,0.5,-172)})
            end)
        end)
    end)

    -- ════════════════════════════════════════════════════════
    --  TAB SİSTEMİ
    -- ════════════════════════════════════════════════════════
    local tabs={}
    local tabCount=0

    local function ActivateTab(idx)
        for i,t in ipairs(tabs) do
            if i==idx then
                Tw(t.btn,0.12,{BackgroundTransparency=0})
                t.btn.TextColor3=Color3.fromRGB(14,2,9)
                t.page.Visible=true
            else
                Tw(t.btn,0.12,{BackgroundTransparency=0.65})
                t.btn.TextColor3=C.TEXT2
                t.page.Visible=false
            end
        end
    end

    local Win={}

    function Win:AddTab(name)
        tabCount=tabCount+1
        local idx=tabCount

        local TBtn=Instance.new("TextButton")
        TBtn.Text=name TBtn.Size=UDim2.new(1,0,0,28)
        TBtn.BackgroundColor3=C.WHITE TBtn.BackgroundTransparency=0.65
        TBtn.TextColor3=C.TEXT2 TBtn.Font=Enum.Font.GothamSemibold
        TBtn.TextSize=11 TBtn.BorderSizePixel=0 TBtn.LayoutOrder=idx
        TBtn.ZIndex=12 TBtn.Parent=TBListFrame
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
            b.BackgroundColor3=Color3.fromRGB(24,4,15)
            b.BackgroundTransparency=0.08
            b.BorderSizePixel=0 b.LayoutOrder=eCount
            b.ZIndex=13 b.Parent=Page
            Cr(b,7)
            -- Sol kenar accent çizgi
            local acc=Instance.new("Frame")
            acc.Size=UDim2.new(0,2,0.7,0) acc.Position=UDim2.new(0,0,0.15,0)
            acc.BackgroundColor3=C.HOT acc.BackgroundTransparency=0.4
            acc.BorderSizePixel=0 acc.ZIndex=14 acc.Parent=b
            Cr(acc,1)
            return b
        end

        -- ── AddSlider ──────────────────────────────────────
        function Tab:AddSlider(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Slider"
            local minV=cfg.Min or 0
            local maxV=cfg.Max or 100
            local def=math.clamp(cfg.Default or 50,cfg.Min or 0,cfg.Max or 100)
            local cb=cfg.Callback
            local box=EBox(64)

            local TL=Lbl(box,lbl,11,C.WHITE,Enum.Font.GothamSemibold)
            TL.Size=UDim2.new(0.65,0,0,16) TL.Position=UDim2.new(0,10,0,6) TL.ZIndex=14

            local VL=Lbl(box,tostring(def),11,C.TEXT2,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
            VL.Size=UDim2.new(0.3,0,0,16) VL.Position=UDim2.new(0.68,0,0,6) VL.ZIndex=14

            local Track=Instance.new("Frame")
            Track.Size=UDim2.new(1,-18,0,6) Track.Position=UDim2.new(0,9,0,36)
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
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,100,168)),
                ColorSequenceKeypoint.new(1,C.HOT),
            })
            FG.Parent=Fill

            local Knob=Instance.new("Frame")
            Knob.Size=UDim2.new(0,14,0,14) Knob.AnchorPoint=Vector2.new(0.5,0.5)
            Knob.Position=UDim2.new((def-minV)/(maxV-minV),0,0.5,0)
            Knob.BackgroundColor3=C.WHITE Knob.BorderSizePixel=0
            Knob.ZIndex=16 Knob.Parent=Track
            Cr(Knob,7) St(Knob,C.STROKE,2,0.05)

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
                    Tw(Knob,0.07,{Size=UDim2.new(0,18,0,18)})
                    inp.Changed:Connect(function()
                        if inp.UserInputState==Enum.UserInputState.End then
                            sliding=false Tw(Knob,0.07,{Size=UDim2.new(0,14,0,14)}) end
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
                    sliding=false Tw(Knob,0.07,{Size=UDim2.new(0,14,0,14)}) end
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

        -- ── AddToggle ─────────────────────────────────────
        function Tab:AddToggle(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Toggle"
            local def=cfg.Default or false
            local cb=cfg.Callback
            local box=EBox(42) local state=def

            local TL=Lbl(box,lbl,11,C.WHITE,Enum.Font.GothamSemibold)
            TL.Size=UDim2.new(0.7,0,1,0) TL.Position=UDim2.new(0,10,0,0) TL.ZIndex=14

            local Trk=Instance.new("Frame")
            Trk.Size=UDim2.new(0,38,0,19) Trk.Position=UDim2.new(1,-46,0.5,-9.5)
            Trk.BackgroundColor3=state and C.HOT or C.DARKEST
            Trk.BorderSizePixel=0 Trk.ZIndex=14 Trk.Parent=box
            Cr(Trk,10)

            local Thumb=Instance.new("Frame")
            Thumb.Size=UDim2.new(0,13,0,13)
            Thumb.Position=state and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5)
            Thumb.BackgroundColor3=C.WHITE Thumb.BorderSizePixel=0
            Thumb.ZIndex=15 Thumb.Parent=Trk
            Cr(Thumb,7)

            local function SS(s)
                state=s
                Tw(Trk,0.16,{BackgroundColor3=s and C.HOT or C.DARKEST})
                Tw(Thumb,0.16,{Position=s and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5)})
                if cb then pcall(cb,s) end
            end
            box.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then SS(not state) end
            end)
            return {SetValue=function(v) SS(v) end,GetValue=function() return state end}
        end

        -- ── AddButton ─────────────────────────────────────
        function Tab:AddButton(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Buton"
            local cb=cfg.Callback
            local box=EBox(36) box.BackgroundTransparency=1

            local Btn=Instance.new("TextButton")
            Btn.Text=lbl Btn.Size=UDim2.new(1,0,1,0)
            Btn.BackgroundColor3=C.HOT Btn.TextColor3=C.WHITE
            Btn.Font=Enum.Font.GothamBold Btn.TextSize=12
            Btn.BorderSizePixel=0 Btn.LayoutOrder=eCount
            Btn.ZIndex=14 Btn.Parent=box
            Cr(Btn,7) St(Btn,Color3.fromRGB(255,150,195),1,0.35)

            Btn.MouseButton1Click:Connect(function()
                Tw(Btn,0.07,{BackgroundColor3=Color3.fromRGB(255,110,172)})
                task.delay(0.14,function() Tw(Btn,0.12,{BackgroundColor3=C.HOT}) end)
                if cb then pcall(cb) end
            end)
        end

        -- ── AddLabel ──────────────────────────────────────
        function Tab:AddLabel(text)
            local box=EBox(28)
            local l=Lbl(box,text,10,C.TEXT2,Enum.Font.Gotham,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,-14,1,0) l.Position=UDim2.new(0,7,0,0) l.ZIndex=14
        end

        -- ── AddSection ────────────────────────────────────
        function Tab:AddSection(text)
            local box=EBox(22) box.BackgroundTransparency=0.58
            local l=Lbl(box,"─── "..text.." ───",10,C.NEON,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
            l.Size=UDim2.new(1,0,1,0) l.ZIndex=14
        end

        -- ── AddTextBox ────────────────────────────────────
        function Tab:AddTextBox(cfg)
            cfg=cfg or {}
            local lbl=cfg.Name or "Input"
            local placeholder=cfg.Placeholder or "..."
            local cb=cfg.Callback
            local box=EBox(52)

            local TL=Lbl(box,lbl,11,C.WHITE,Enum.Font.GothamSemibold)
            TL.Size=UDim2.new(1,-14,0,16) TL.Position=UDim2.new(0,10,0,5) TL.ZIndex=14

            local Input=Instance.new("TextBox")
            Input.Size=UDim2.new(1,-18,0,22) Input.Position=UDim2.new(0,9,0,24)
            Input.BackgroundColor3=C.DARKEST Input.BackgroundTransparency=0.1
            Input.TextColor3=C.WHITE Input.Font=Enum.Font.Gotham
            Input.TextSize=11 Input.PlaceholderText=placeholder
            Input.PlaceholderColor3=C.TEXT2 Input.BorderSizePixel=0
            Input.ZIndex=14 Input.Parent=box
            Cr(Input,5)

            Input.FocusLost:Connect(function(enter)
                if enter and cb then pcall(cb,Input.Text) end
            end)
        end

        return Tab
    end

    return Win
end

return Lib

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  XENO TEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Hub = loadstring(game:HttpGet("RAW_LINK_BURAYA"))()

local Win = Hub:CreateWindow({
    Title    = "My Script",
    SubTitle = "v1.0  by You",
    Language = "TR",
})

local Kar = Win:AddTab("Karakter")
Kar:AddSection("Hareket")
Kar:AddSlider({ Name="Hız",     Min=1, Max=200, Default=16,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end})
Kar:AddSlider({ Name="Zıplama", Min=1, Max=300, Default=50,
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end})
Kar:AddToggle({ Name="Sonsuz Zıplama", Default=false,
    Callback=function(s)
        if s then
            _G.IJ=game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character.Humanoid
                    :ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        elseif _G.IJ then _G.IJ:Disconnect() end
    end})
Kar:AddButton({ Name="Reset Karakter",
    Callback=function() game.Players.LocalPlayer.Character.Humanoid.Health=0 end})

local Vis = Win:AddTab("Grafik")
Vis:AddSlider({ Name="FOV", Min=30, Max=120, Default=70,
    Callback=function(v) workspace.CurrentCamera.FieldOfView=v end})
Vis:AddSlider({ Name="Yerçekimi", Min=10, Max=300, Default=196,
    Callback=function(v) workspace.Gravity=v end})

local Misc = Win:AddTab("Misc")
Misc:AddSection("Araçlar")
Misc:AddTextBox({ Name="Teleport (PlaceId)", Placeholder="12345678",
    Callback=function(v) game:GetService("TeleportService"):Teleport(tonumber(v)) end})
Misc:AddLabel("S3xy Hub v5 - Enjoy!")
]]
