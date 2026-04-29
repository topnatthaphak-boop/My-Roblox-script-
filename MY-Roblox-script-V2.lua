local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= CONFIG =================
local KeyURL = "https://pastebin.com/raw/Kvdbsd9C"
local LocalFile = "tokopp_key.txt"

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ================= SAFE =================
local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function hum()
    return char():FindFirstChildOfClass("Humanoid")
end

local function hrp()
    return char():FindFirstChild("HumanoidRootPart")
end

-- ================= LOAD KEY =================
local SavedKey = ""
pcall(function()
    if isfile(LocalFile) then
        SavedKey = readfile(LocalFile)
    end
end)

-- ================= UI (เปลี่ยนชื่อเป็น T&D Hub ตรงนี้) =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Secure", -- เปลี่ยนชื่อตรงนี้แล้วครับ
    LoadingTitle = "T&D System", -- เปลี่ยนชื่อตรงนี้แล้วครับ
    LoadingSubtitle = "by Tokopp & Dola", -- ใส่ชื่อพวกเราคู่กันตรงนี้เลย
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local LoginTab = Window:CreateTab("🔐 Login")

local InputKey = SavedKey or ""
local StatusLabel = LoginTab:CreateLabel("Status: Waiting...")

-- ================= CLEAN STRING =================
local function clean(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

-- ================= VERIFY =================
local function VerifyKey(key)
    key = clean(key)

    local success, result = pcall(function()
        return game:HttpGet(KeyURL)
    end)

    if success and result then
        for line in result:gmatch("[^\r\n]+") do
            if clean(line) == key then
                return true
            end
        end
    end

    return false
end

-- ================= LOGIN UI =================
LoginTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "กรอกคีย์ของคุณ",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        InputKey = text
    end
})

LoginTab:CreateButton({
    Name = "Get Key",
    Callback = function()
        setclipboard("https://pastebin.com/Kvdbsd9C")
        Rayfield:Notify({
            Title = "Copied",
            Content = "ลิงก์รับคีย์ถูกคัดลอกแล้ว",
            Duration = 4
        })
    end
})

-- ================= HUB FUNCTION =================
local function LoadHub()

    local Tab = Window:CreateTab("Main Hub") -- เปลี่ยนชื่อ Tab ให้ดูเป็น Hub ของเรา

    local state = {
        fly = false,
        noclip = false,
        infiniteJump = false,
        speed = 16,
        flySpeed = 35
    }

    Tab:CreateSlider({
        Name = "WalkSpeed",
        Range = {16, 80},
        Increment = 2,
        CurrentValue = 16,
        Callback = function(v)
            state.speed = v
            local h = hum()
            if h then h.WalkSpeed = v end
        end
    })

    local flyConn
    Tab:CreateToggle({
        Name = "Fly (บิน)",
        CurrentValue = false,
        Callback = function(v)
            state.fly = v
            if flyConn then flyConn:Disconnect() end

            if v then
                flyConn = RunService.RenderStepped:Connect(function()
                    local r = hrp()
                    if r then
                        r.Velocity = workspace.CurrentCamera.CFrame.LookVector * state.flySpeed
                    end
                end)
            end
        end
    })

    Tab:CreateSlider({
        Name = "Fly Speed",
        Range = {20, 120},
        Increment = 5,
        CurrentValue = 35,
        Callback = function(v)
            state.flySpeed = v
        end
    })

    RunService.Stepped:Connect(function()
        if state.noclip then
            local c = char()
            for _,v in ipairs(c:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)

    Tab:CreateToggle({
        Name = "NoClip (ทะลุกำแพง)",
        CurrentValue = false,
        Callback = function(v)
            state.noclip = v
        end
    })

    UIS.JumpRequest:Connect(function()
        if state.infiniteJump then
            local h = hum()
            if h then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    Tab:CreateToggle({
        Name = "Infinite Jump (กระโดดไม่จำกัด)",
        CurrentValue = false,
        Callback = function(v)
            state.infiniteJump = v
        end
    })

    Tab:CreateButton({
        Name = "Teleport to Mouse (คลิกเพื่อวาร์ป)",
        Callback = function()
            local mouse = player:GetMouse()
            local connection
            connection = mouse.Button1Down:Connect(function()
                local r = hrp()
                if r then
                    r.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
                end
                connection:Disconnect() -- วาร์ปเสร็จแล้วปิดการทำงาน
            end)
            Rayfield:Notify({Title = "T&D Hub", Content = "คลิกที่ไหนก็ได้เพื่อวาร์ป!", Duration = 3})
        end
    })

    Tab:CreateButton({
        Name = "Reset Character",
        Callback = function()
            player.Character:BreakJoints()
        end
    })

    Tab:CreateButton({
        Name = "FPS Boost",
        Callback = function()
            for _,v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end
                if v:IsA("Decal") then
                    v:Destroy()
                end
            end
            Rayfield:Notify({Title = "T&D Hub", Content = "เพิ่มความเร็วเครื่องสำเร็จ!", Duration = 3})
        end
    })

    Tab:CreateButton({
        Name = "Minimize UI (ซ่อนหน้าจอ)",
        Callback = function()
            Rayfield:ToggleUI()
        end
    })
end

-- ================= VERIFY BUTTON =================
LoginTab:CreateButton({
    Name = "Verify Key (ตรวจสอบคีย์)",
    Callback = function()
        StatusLabel:Set("Status: Checking... ⏳")

        if VerifyKey(InputKey) then

            pcall(function()
                writefile(LocalFile, clean(InputKey))
            end)

            StatusLabel:Set("Status: Access Granted ✅")

            Rayfield:Notify({
                Title = "Welcome to T&D Hub",
                Content = "ยินดีต้อนรับ " .. player.Name .. " เข้าสู่ระบบ!",
                Duration = 4
            })

            task.wait(1)
            LoadHub()

        else
            StatusLabel:Set("Status: Invalid Key ❌")

            Rayfield:Notify({
                Title = "Error",
                Content = "คีย์ไม่ถูกต้อง กรุณาลองใหม่",
                Duration = 4
            })
        end
    end
})

-- ================= AUTO LOGIN =================
if SavedKey ~= "" then
    task.spawn(function()
        if VerifyKey(SavedKey) then
            StatusLabel:Set("Status: Auto Login ✅")
            task.wait(1)
            LoadHub()
        end
    end)
end
