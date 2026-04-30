-- เปิดโหมดปลอดภัยเพื่อให้ UI โหลดติดง่ายขึ้นบนเครื่องสเปกต่ำ
getgenv().SecureMode = true 
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- ================= CONFIG =================
local KeyURL = "https://pastebin.com/raw/Kvdbsd9C"
local LocalFile = "tokopp_key.txt"

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ================= SAFE FUNCTIONS =================
local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function hum()
    local c = char()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function hrp()
    local c = char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ================= LOAD KEY =================
local SavedKey = ""
pcall(function()
    if isfile and isfile(LocalFile) then
        SavedKey = readfile(LocalFile)
    end
end)

-- ================= UI WINDOW =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Secure", 
    LoadingTitle = "T&D System", 
    LoadingSubtitle = "by Tokopp & Dola", 
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local LoginTab = Window:CreateTab("🔐 Login")
local InputKey = SavedKey or ""
local StatusLabel = LoginTab:CreateLabel("Status: Waiting...")

-- ================= UTILS =================
local function clean(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

local function VerifyKey(key)
    key = clean(key or "")
    if key == "" then return false end
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
    local Tab = Window:CreateTab("Main Hub") 
    local state = {
        fly = false,
        noclip = false,
        infiniteJump = false,
        speed = 16,
        flySpeed = 35
    }

    Tab:CreateSection("Movement")

    Tab:CreateSlider({
        Name = "WalkSpeed",
        Range = {16, 250},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(v)
            state.speed = v
            local h = hum()
            if h then h.WalkSpeed = v end
        end
    })

    local flyConn
    Tab:CreateToggle({
        Name = "Fly (ระบบบิน)",
        CurrentValue = false,
        Callback = function(v)
            state.fly = v
            if flyConn then flyConn:Disconnect() end
            if v then
                flyConn = RunService.RenderStepped:Connect(function()
                    local r = hrp()
                    if r and state.fly then
                        r.Velocity = workspace.CurrentCamera.CFrame.LookVector * state.flySpeed
                    end
                end)
            else
                local r = hrp()
                if r then r.Velocity = Vector3.new(0,0,0) end
            end
        end
    })

    Tab:CreateSlider({
        Name = "Fly Speed",
        Range = {20, 300},
        Increment = 5,
        CurrentValue = 35,
        Callback = function(v)
            state.flySpeed = v
        end
    })

    Tab:CreateSection("Cheats")

    Tab:CreateToggle({
        Name = "NoClip (เดินทะลุ)",
        CurrentValue = false,
        Callback = function(v)
            state.noclip = v
        end
    })

    Tab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v)
            state.infiniteJump = v
        end
    })

    Tab:CreateButton({
        Name = "Teleport to Mouse (วาร์ปไปที่เมาส์)",
        Callback = function()
            local mouse = player:GetMouse()
            local connection
            connection = mouse.Button1Down:Connect(function()
                local r = hrp()
                if r then
                    r.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
                end
                connection:Disconnect()
            end)
            Rayfield:Notify({Title = "T&D Hub", Content = "คลิกที่ไหนก็ได้เพื่อวาร์ป!", Duration = 3})
        end
    })

    Tab:CreateSection("Misc & Optimization")

    Tab:CreateButton({
        Name = "FPS Boost",
        Callback = function()
            for _,v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
            Rayfield:Notify({Title = "T&D Hub", Content = "ลดกราฟิกสำเร็จ!", Duration = 3})
        end
    })

    Tab:CreateButton({
        Name = "Reset Character",
        Callback = function()
            local c = char()
            if c then c:BreakJoints() end
        end
    })

    -- ระบบวนลูป NoClip
    RunService.Stepped:Connect(function()
        if state.noclip then
            local c = char()
            if c then
                for _,v in ipairs(c:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)

    -- ระบบ Infinite Jump
    UIS.JumpRequest:Connect(function()
        if state.infiniteJump then
            local h = hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

-- ================= VERIFY BUTTON =================
LoginTab:CreateButton({
    Name = "Verify Key",
    Callback = function()
        StatusLabel:Set("Status: Checking... ⏳")
        if VerifyKey(InputKey) then
            if writefile then pcall(function() writefile(LocalFile, clean(InputKey)) end) end
            StatusLabel:Set("Status: Access Granted ✅")
            Rayfield:Notify({Title = "Welcome", Content = "ยินดีต้อนรับสู่ T&D Hub!", Duration = 3})
            task.wait(0.5)
            LoadHub()
        else
            StatusLabel:Set("Status: Invalid Key ❌")
            Rayfield:Notify({Title = "Error", Content = "คีย์ไม่ถูกต้อง!", Duration = 3})
        end
    end
})

-- ================= AUTO LOGIN =================
if SavedKey ~= "" then
    task.spawn(function()
        if VerifyKey(SavedKey) then
            StatusLabel:Set("Status: Auto Login ✅")
            task.wait(0.5)
            LoadHub()
        end
    end)
end
