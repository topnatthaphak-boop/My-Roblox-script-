local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= CONFIG =================
local KeyURL = "https://pastebin.com/raw/Kvdbsd9C"
local LocalFile = "tokopp_key.txt"

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ================= SAFE FUNCTIONS =================
local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() return char():FindFirstChildOfClass("Humanoid") end
local function hrp() return char():FindFirstChild("HumanoidRootPart") end

-- ================= LOAD SAVED KEY =================
local SavedKey = ""
pcall(function()
    if isfile(LocalFile) then
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
local function clean(str) return (str:gsub("^%s*(.-)%s*$", "%1")) end

local function VerifyKey(key)
    key = clean(key)
    local success, result = pcall(function() return game:HttpGet(KeyURL) end)
    if success and result then
        for line in result:gmatch("[^\r\n]+") do
            if clean(line) == key then return true end
        end
    end
    return false
end

-- ================= FLY SYSTEM (NEW) =================
local flying = false
local flySpeed = 50
local flyConn = nil
local bv, bg

local function stopFly()
    flying = false
    if flyConn then flyConn:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local h = hum()
    if h then h.PlatformStand = false end
end

local function startFly()
    stopFly() -- Clear old fly if exists
    local root = hrp()
    local h = hum()
    if not root or not h then return end

    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = root.CFrame
    bg.Parent = root

    bv = Instance.new("BodyVelocity")
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = root

    h.PlatformStand = true

    flyConn = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local moveDir = h.MoveDirection
        
        bv.velocity = camera.CFrame.LookVector * (moveDir.Magnitude > 0 and flySpeed or 0)
        if moveDir.Magnitude == 0 then
            bv.velocity = Vector3.new(0, 0.1, 0)
        end
        bg.cframe = camera.CFrame
    end)
end

-- ================= HUB CONTENT =================
local function LoadHub()
    local Tab = Window:CreateTab("Main Hub")
    
    local state = {
        noclip = false,
        infiniteJump = false,
        speed = 16
    }

    -- WalkSpeed
    Tab:CreateSlider({
        Name = "WalkSpeed",
        Range = {16, 200},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(v)
            state.speed = v
            local h = hum()
            if h then h.WalkSpeed = v end
        end
    })

    -- Advanced Fly (The one you requested!)
    Tab:CreateToggle({
        Name = "Fly (บินแบบเสถียร)",
        CurrentValue = false,
        Callback = function(v)
            flying = v
            if v then startFly() else stopFly() end
        end
    })

    Tab:CreateSlider({
        Name = "Fly Speed",
        Range = {20, 500},
        Increment = 10,
        CurrentValue = 50,
        Callback = function(v)
            flySpeed = v
        end
    })

    -- NoClip
    RunService.Stepped:Connect(function()
        if state.noclip then
            for _, v in ipairs(char():GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    Tab:CreateToggle({
        Name = "NoClip (ทะลุกำแพง)",
        CurrentValue = false,
        Callback = function(v) state.noclip = v end
    })

    -- Infinite Jump
    UIS.JumpRequest:Connect(function()
        if state.infiniteJump then
            local h = hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    Tab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) state.infiniteJump = v end
    })

    -- Other Features
    Tab:CreateButton({
        Name = "Teleport (Click)",
        Callback = function()
            local mouse = player:GetMouse()
            mouse.Button1Down:Connect(function()
                local r = hrp()
                if r then r.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) end
            end)
        end
    })

    Tab:CreateButton({
        Name = "FPS Boost",
        Callback = function()
            for _,v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v:Destroy()
                end
            end
        end
    })

    Tab:CreateButton({
        Name = "Minimize UI",
        Callback = function() Rayfield:ToggleUI() end
    })
end

-- ================= LOGIN LOGIC =================
LoginTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "กรอกคีย์ของคุณ",
    Callback = function(text) InputKey = text end
})

LoginTab:CreateButton({
    Name = "Get Key",
    Callback = function() setclipboard("https://pastebin.com/Kvdbsd9C") end
})

LoginTab:CreateButton({
    Name = "Verify Key",
    Callback = function()
        StatusLabel:Set("Status: Checking... ⏳")
        if VerifyKey(InputKey) then
            pcall(function() writefile(LocalFile, clean(InputKey)) end)
            StatusLabel:Set("Status: Access Granted ✅")
            task.wait(1)
            LoadHub()
        else
            StatusLabel:Set("Status: Invalid Key ❌")
        end
    end
})

-- Auto Login
if SavedKey ~= "" then
    task.spawn(function()
        if VerifyKey(SavedKey) then
            StatusLabel:Set("Status: Auto Login ✅")
            task.wait(1)
            LoadHub()
        end
    end)
end
