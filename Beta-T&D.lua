-- [[ PROJECT X24: FORTRESS XD EDITION ]]
-- [[ Developed by T&D Phoenix A ]]

local _OWNER = "T&D Phoenix A"
local _AUTH_VAL = 1163 -- รหัสพันธุกรรมคำนวณจาก ASCII ของชื่อเจ้าของ
local _SECURE_KEY = "X24-PRO" -- คีย์สำหรับเข้าสู่ระบบ
local _is_authorized = false

-- [ XD Formula: ระบบตรวจสอบความสมบูรณ์แบบเงียบ ]
local function verify_integrity()
    local val = 0
    for i = 1, #_OWNER do
        val = val + string.byte(_OWNER, i)
    end
    return val
end

-- [ กับดักหลอก (Decoy) สำหรับพวกชอบ Bypass ]
local function _check_license_fake()
    -- หลอกให้พวกแก้โค้ดมาเปลี่ยนค่าตรงนี้ แต่จริงๆ ฟังก์ชันนี้ไม่ได้ใช้รันสคริปต์
    return false
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [ 1. หน้าต่างตรวจสอบความปลอดภัย (KEY SYSTEM) ]
local KeyWindow = Rayfield:CreateWindow({
    Name = _OWNER .. " | Secure Access",
    LoadingTitle = "Project X24: Initialization",
    LoadingSubtitle = "Fortress XD Protection Active",
    ConfigurationSaving = {Enabled = false}
})

local KeyTab = KeyWindow:CreateTab("Enter Key")

KeyTab:CreateInput({
    Name = "ระบบป้องกันการ Bypass (XD สูตร 1)",
    PlaceholderText = "Key: " .. _SECURE_KEY,
    Callback = function(Text)
        -- เช็กทั้ง Key และ Integrity ของชื่อเจ้าของพร้อมกัน
        if Text == _SECURE_KEY and verify_integrity() == _AUTH_VAL then
            _is_authorized = true
            Rayfield:Notify({Title = "Success", Content = "เข้าสู่ระบบสำเร็จ! ปลดปล่อยพลังฟีนิกซ์...", Duration = 5})
            task.wait(1)
            KeyWindow:Destroy()
            StartSystemSelector()
        else
            -- ถ้าพยายามแก้ชื่อเจ้าของหรือใส่ Key ผิด
            game.Players.LocalPlayer:Kick("X24: ตรวจพบการดัดแปลงโค้ด หรือพยายาม Bypass ระบบ!")
        end
    end,
})

-- [ 2. ระบบเลือกโหมด (32/64 BIT) ]
function StartSystemSelector()
    local isLiteMode = false
    local SetupWindow = Rayfield:CreateWindow({
        Name = "T&D Phoenix A: System Selector",
        LoadingTitle = "Checking Device Compatibility...",
        LoadingSubtitle = "Select your version",
        ConfigurationSaving = {Enabled = false}
    })

    local SetupTab = SetupWindow:CreateTab("Select Mode")

    SetupTab:CreateButton({
        Name = "🔵 32-Bit (Lite Mode) - เน้นความลื่นไหล",
        Callback = function()
            isLiteMode = true
            Rayfield:Notify({Title = "System", Content = "เปิดโหมดประหยัด RAM", Duration = 5})
            SetupWindow:Destroy()
            StartMainScript(isLiteMode) 
        end,
    })

    SetupTab:CreateButton({
        Name = "🔴 64-Bit (Full Mode) - ฟังก์ชันจัดเต็ม",
        Callback = function()
            isLiteMode = false
            Rayfield:Notify({Title = "System", Content = "เปิดโหมดเต็มรูปแบบ", Duration = 5})
            SetupWindow:Destroy()
            StartMainScript(isLiteMode)
        end,
    })
end

-- [ 3. ฟังก์ชันสคริปต์หลัก (พร้อมกับดัก XD สูตร 2) ]
function StartMainScript(isLiteMode)
    -- กับดักตรรกะ: ถ้าไม่ได้ผ่านการรันจากปุ่ม Key หรือชื่อโดนเปลี่ยน สคริปต์จะระเบิดตัวเอง (Crash)
    if not _is_authorized or verify_integrity() ~= _AUTH_VAL then
        while true do end -- ทำให้ Roblox ค้าง เพื่อหยุดการแกะโค้ด
    end

    local Window = Rayfield:CreateWindow({
        Name = _OWNER,
        LoadingTitle = "Loading Project X24...",
        LoadingSubtitle = "The Ultimate Black Hole System",
        ConfigurationSaving = {Enabled = false}
    })

    -- สร้างแท็บทั้งหมด
    local Tab = Window:CreateTab("Main")
    local OthersTab = Window:CreateTab("Others (อื่นๆ)")
    local DevTab = Window:CreateTab("Dev Tools (พัฒนา)")
    local UpdateTab = Window:CreateTab("Updates (อัปเดต)")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local player = Players.LocalPlayer

    local function char() return player.Character or player.CharacterAdded:Wait() end
    local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end
    local state = { fly = false, god = false, noclip = false, esp = false, infiniteJump = false }

    -- [ MAIN TAB ] - ความเร็วที่ผูกกับชื่อเจ้าของ (เปลี่ยนชื่อ = วิ่งไม่ออก)
    local xd_speed = (verify_integrity() / 11.63) -- จะได้ 100 พอดีถ้าชื่อถูก

    Tab:CreateToggle({
        Name = "Speed Toggle (วิ่งเร็ว - พลัง XD)",
        CurrentValue = false,
        Callback = function(v)
            local h = hum()
            if h then h.WalkSpeed = v and xd_speed or 16 end
        end
    })

    Tab:CreateToggle({
        Name = "NoClip (ทะลุกำแพง)",
        CurrentValue = false,
        Callback = function(v) state.noclip = v end
    })

    RunService.Stepped:Connect(function()
        if state.noclip then
            local c = char()
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    Tab:CreateToggle({
        Name = "ESP (มองทะลุตัวละคร)",
        CurrentValue = false,
        Callback = function(v)
            state.esp = v
            if v then
                for _,p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "ESP"
                        h.FillColor = Color3.fromRGB(0,255,0)
                    end
                end
            else
                for _,p in ipairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("ESP") then p.Character.ESP:Destroy() end
                end
            end
        end
    })

    Tab:CreateToggle({
        Name = "God Mode (เลือดไม่ลด)",
        CurrentValue = false,
        Callback = function(v) state.god = v end
    })

    RunService.Heartbeat:Connect(function()
        if state.god then
            local h = hum()
            if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end
    end)

    Tab:CreateToggle({
        Name = "Infinite Jump (กระโดดไม่จำกัด)",
        CurrentValue = false,
        Callback = function(v) state.infiniteJump = v end
    })

    UIS.JumpRequest:Connect(function()
        if state.infiniteJump then
            local h = hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    -- [ OTHERS TAB ]
    OthersTab:CreateSection("--- สคริปต์พื้นฐาน (32/64 Bit) ---")
    
    OthersTab:CreateButton({
        Name = "IY (Infinite Yield)",
        Callback = function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-IY-InfiniteYield-137097"))()
        end,
    })

    OthersTab:CreateButton({
        Name = "Hexagon Client",
        Callback = function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-HX-Hexagon-Client-90722"))()
        end,
    })

    if not isLiteMode then
        OthersTab:CreateSection("--- สคริปต์พิเศษ (เฉพาะ 64-Bit) ---")
        
        OthersTab:CreateButton({
            Name = "Fly (บิน) - Legend Script",
            Callback = function()
                loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
            end,
        })

        OthersTab:CreateButton({
            Name = "Hack Lord (1x1x1x1)",
            Callback = function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-1x1x1x1-lord-by-White-Hat-71150"))()
            end,
        })
    end

    -- [ DEV TOOLS TAB ]
    if not isLiteMode then
        DevTab:CreateButton({
            Name = "Run Dex + SimpleSpy (Heavy Tools)",
            Callback = function()
                pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SECURE-DEX-AND-REMOTE-SPY-205256"))() end)
                pcall(function() loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))() end)
            end,
        })
    else
        DevTab:CreateSection("Dev Tools ถูกปิดในโหมด Lite")
    end

    -- [ UPDATES TAB ]
    UpdateTab:CreateSection("Project X24 Info")
    UpdateTab:CreateParagraph({
        Title = "🐍 " .. _OWNER .. ": Project X24", 
        Content = "Integrity Status: [SECURED XD]\nSecurity Level: Fortress\nฟีเจอร์ปัจจุบัน: Anti-Bypass, Mode Selector (32/64 bit)"
    })

    Rayfield:LoadConfiguration()
end
