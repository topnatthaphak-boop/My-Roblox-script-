local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ================= UTILS =================
local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() return char():FindFirstChildOfClass("Humanoid") end
local function hrp() return char():FindFirstChild("HumanoidRootPart") end

-- ================= UI SETUP =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Forsaken Edition V4",
    LoadingTitle = "Forsaken Script",
    LoadingSubtitle = "by Tokopp & Dola",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local Tab = Window:CreateTab("🏠 Main Features")
local VisualTab = Window:CreateTab("👁️ Visuals")

local state = {
    infStamina = false,
    autoGen = false,
    espEnabled = false,
    genESP = false,
    walkTP = false,
    tpAmount = 0.5
}

-- ================= FUNCTIONALITY =================

-- 1. Walk TP System (ระบบเดินวาร์ป)
RunService.RenderStepped:Connect(function()
    if state.walkTP and hum() and hum().MoveDirection.Magnitude > 0 then
        if hrp() then
            hrp().CFrame = hrp().CFrame + (hum().MoveDirection * state.tpAmount)
        end
    end
end)

-- 2. Stamina System
task.spawn(function()
    while task.wait(0.5) do
        if state.infStamina then
            local stamina = player:FindFirstChild("Stamina") or char():FindFirstChild("Stamina")
            if stamina and stamina:IsA("NumberValue") then
                stamina.Value = 100
            end
        end
    end
end)

-- 3. Auto Generator System
task.spawn(function()
    while task.wait(0.1) do
        if state.autoGen then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("generator") and player:DistanceFromCharacter(v.PrimaryPart.Position) < 15 then
                    local remote = v:FindFirstChild("RemoteEvent") or game:GetService("ReplicatedStorage"):FindFirstChild("GenRemote")
                    if remote then
                        remote:FireServer()
                    end
                end
            end
        end
    end
end)

-- ================= UI COMPONENTS =================

-- [ MAIN TAB ]
Tab:CreateToggle({
    Name = "Walk TP (เดินแบบวาร์ป)",
    CurrentValue = false,
    Callback = function(v) state.walkTP = v end,
})

Tab:CreateSlider({
    Name = "Walk TP Strength (ความแรงวาร์ป)",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(v) state.tpAmount = v end,
})

Tab:CreateToggle({
    Name = "Infinite Stamina (สเตมิน่าไม่จำกัด)",
    CurrentValue = false,
    Callback = function(v) state.infStamina = v end,
})

Tab:CreateSlider({
    Name = "Safe WalkSpeed",
    Range = {16, 45},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if hum() then hum().WalkSpeed = v end
    end,
})

Tab:CreateToggle({
    Name = "Auto Repair (ปั่นไฟอัตโนมัติ)",
    CurrentValue = false,
    Callback = function(v) state.autoGen = v end,
})

-- [ VISUAL TAB ]
VisualTab:CreateButton({
    Name = "Full Bright (เปิดแสงสว่าง)",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Rayfield:Notify({Title = "Lighting", Content = "เปิดโหมดสว่างเรียบร้อยแล้ว", Duration = 2})
    end,
})

local function CreateESP(p)
    if p == player then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "TND_ESP"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Adornee = p.Character
    highlight.Parent = p.Character
end

VisualTab:CreateToggle({
    Name = "Player ESP (มองเห็นคน)",
    CurrentValue = false,
    Callback = function(v)
        state.espEnabled = v
        for _, p in pairs(Players:GetPlayers()) do
            if v then if p.Character then CreateESP(p) end
            else if p.Character and p.Character:FindFirstChild("TND_ESP") then p.Character.TND_ESP:Destroy() end end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "Generator ESP (มองเห็นเครื่องปั่นไฟ)",
    CurrentValue = false,
    Callback = function(v)
        state.genESP = v
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:lower():find("generator") then
                if v then
                    local hl = Instance.new("Highlight", obj)
                    hl.Name = "TND_GenESP"
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                else
                    if obj:FindFirstChild("TND_GenESP") then obj.TND_GenESP:Destroy() end
                end
            end
        end
    end,
})

-- ================= INITIALIZE =================
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if state.espEnabled then task.wait(0.5) CreateESP(p) end
    end)
end)

Rayfield:Notify({
    Title = "Script Loaded V4",
    Content = "ยินดีต้อนรับสู่ T&D Hub เวอร์ชันใหม่! Walk TP พร้อมใช้งานแล้ว",
    Duration = 5
})
