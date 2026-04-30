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
local function clean(str) return (str:gsub("^%s*(.-)%s*$\", \"%1\")) end

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

-- ================= FLY SYSTEM =================
local flying = false
local flySpeed = 50
local flyConn = nil
local bv, bg

local function stopFly()
    if flyConn then flyConn:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local h = hum()
    if h then h.PlatformStand = false end
end

local function startFly()
    stopFly()
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
        if moveDir.Magnitude == 0 then bv.velocity = Vector3.new(0, 0.1, 0) end
        bg.cframe = camera.CFrame
    end)
end

-- ================= ESP SYSTEM =================
local esp_enabled = false

local function createESP(plr)
    if plr == player then return end
    local function addHighlight(character)
        if not character then return end
        
        -- Highlight (ตัวเรืองแสง)
        local highlight = character:FindFirstChild("TD_Highlight") or Instance.new("Highlight")
        highlight.Name = "TD_Highlight"
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Enabled = esp_enabled

        -- NameTag (ชื่อ)
        local head = character:WaitForChild("Head", 5)
        if head then
            local billboard = head:FindFirstChild("TD_NameTag") or Instance.new("BillboardGui")
            billboard.Name = "TD_NameTag"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local label = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = plr.Name
            label.TextColor3 = Color3.fromRGB(0, 255, 0)
            label.TextStrokeTransparency = 0
            label.TextScaled = true
            label.Parent = billboard
            billboard.Enabled = esp_enabled
        end
    end
    plr.CharacterAdded:Connect(addHighlight)
    if plr.Character then addHighlight(plr.Character) end
end

-- ================= HUB CONTENT =================
local function LoadHub()
    local Tab = Window:CreateTab("Main Hub")
    local state = { noclip = false, infiniteJump = false }

    Tab:CreateSection("Movement")
    
    Tab:CreateSlider({
        Name = "WalkSpeed",
        Range = {16, 250},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(v)
            local h = hum()
            if h then h.WalkSpeed = v end
        end
    })

    Tab:CreateToggle({
        Name = "Advanced Fly (บินตามกล้อง)",
        CurrentValue = false,
        Callback = function(v)
            flying = v
            if v then startFly() else stopFly() end
        end
    })

    Tab:CreateSlider({
        Name = "Fly Speed",
        Range = {20, 500},
        Increment = 5,
        CurrentValue = 50,
        Callback = function(v) flySpeed = v end
    })

    Tab:CreateSection("Visuals & Cheats")

    Tab:CreateToggle({
        Name = "ESP Player (เรืองแสงสีเขียว)",
        CurrentValue = false,
        Callback = function(v)
            esp_enabled = v
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    if p.Character:FindFirstChild("TD_Highlight") then p.Character.TD_Highlight.Enabled = v end
                    if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("TD_NameTag") then
                        p.Character.Head.TD_NameTag.Enabled = v
                    end
                end
            end
        end
    })

    Tab:CreateToggle({
        Name = "NoClip (เดินทะลุ)",
        CurrentValue = false,
        Callback = function(v) state.noclip = v end
    })

    Tab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) state.infiniteJump = v end
    })

    Tab:CreateSection("Misc")

    Tab:CreateButton({
        Name = "FPS Boost",
        Callback = function()
            for _,v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Enum.Material.Plastic v.Reflectance = 0
                elseif v:IsA("Decal") then v:Destroy() end
            end
        end
    })

    -- ระบบวนลูป NoClip & Infinite Jump
    RunService.Stepped:Connect(function()
        if state.noclip then
            for _, v in ipairs(char():GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

-- Setup ESP for all players
for _, v in ipairs(Players:GetPlayers()) do createESP(v) end
Players.PlayerAdded:Connect(createESP)

-- ================= LOGIN LOGIC =================
LoginTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "กรอกคีย์ที่นี่...",
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
            task.wait(0.5)
            LoadHub()
        else
            StatusLabel:Set("Status: Invalid Key ❌")
        end
    end
})

if SavedKey ~= "" then
    task.spawn(function()
        if VerifyKey(SavedKey) then
            StatusLabel:Set("Status: Auto Login ✅")
            task.wait(0.5)
            LoadHub()
        end
    end)
            end
            
