local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ================= UTILS =================
local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() return char():FindFirstChildOfClass("Humanoid") end
local function hrp() return char():FindFirstChild("HumanoidRootPart") end

-- ================= UI SETUP =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Forsaken Perfect V4",
    LoadingTitle = "T&D Hub Version 4",
    LoadingSubtitle = "by Tokopp & Dola",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local Tab = Window:CreateTab("🏠 Main & Combat")
local VisualTab = Window:CreateTab("👁️ Visuals")

local state = {
    infStamina = false,
    autoGen = false,
    killAura = false,
    espEnabled = false,
    genESP = false,
    walkTP = false,
    tpAmount = 0.5,
    killAuraDist = 15
}

-- ================= FUNCTIONALITY =================

-- 1. Walk TP System (ระบบเดินวาร์ปที่เนียนกว่าเดิม)
RunService.RenderStepped:Connect(function()
    if state.walkTP and hum() and hum().MoveDirection.Magnitude > 0 then
        if hrp() then
            hrp().CFrame = hrp().CFrame + (hum().MoveDirection * state.tpAmount)
        end
    end
end)

-- 2. Kill Aura (โจมตีอัตโนมัติ - เพิ่มใหม่!)
task.spawn(function()
    while task.wait(0.1) do
        if state.killAura then
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v ~= char() then
                    local dist = (hrp().Position - v.PrimaryPart.Position).Magnitude
                    if dist <= state.killAuraDist then
                        local attackRemote = ReplicatedStorage:FindFirstChild("AttackRemote") or ReplicatedStorage:FindFirstChild("Punch")
                        if attackRemote then attackRemote:FireServer(v.Humanoid) end
                    end
                end
            end
        end
    end
end)

-- 3. Stamina System
task.spawn(function()
    while task.wait(0.5) do
        if state.infStamina then
            local stamina = player:FindFirstChild("Stamina") or char():FindFirstChild("Stamina")
            if stamina and stamina:IsA("NumberValue") then stamina.Value = 100 end
        end
    end
end)

-- 4. Auto Generator System (ปั่นไฟ)
task.spawn(function()
    while task.wait(0.1) do
        if state.autoGen then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("generator") and v:FindFirstChild("PrimaryPart") then
                    if player:DistanceFromCharacter(v.PrimaryPart.Position) < 15 then
                        local remote = v:FindFirstChild("RemoteEvent") or ReplicatedStorage:FindFirstChild("GenRemote")
                        if remote then remote:FireServer() end
                    end
                end
            end
        end
    end
end)

-- ================= UI COMPONENTS =================

Tab:CreateToggle({
    Name = "Kill Aura (โจมตีรอบตัว)",
    CurrentValue = false,
    Callback = function(v) state.killAura = v end,
})

Tab:CreateToggle({
    Name = "Walk TP (เดินแบบวาร์ป)",
    CurrentValue = false,
    Callback = function(v) state.walkTP = v end,
})

Tab:CreateSlider({
    Name = "Walk TP Strength",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(v) state.tpAmount = v end,
})

Tab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(v) state.infStamina = v end,
})

Tab:CreateToggle({
    Name = "Auto Repair (ปั่นไฟอัตโนมัติ)",
    CurrentValue = false,
    Callback = function(v) state.autoGen = v end,
})

-- Visuals
VisualTab:CreateButton({
    Name = "Full Bright (เปิดแสงสว่าง)",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end,
})

local function CreateESP(p)
    if p == player or not p.Character then return end
    local hl = p.Character:FindFirstChild("TND_ESP") or Instance.new("Highlight", p.Character)
    hl.Name = "TND_ESP"
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 0.5
end

VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        state.espEnabled = v
        for _, p in pairs(Players:GetPlayers()) do
            if v then CreateESP(p) 
            else if p.Character and p.Character:FindFirstChild("TND_ESP") then p.Character.TND_ESP:Destroy() end end
        end
    end,
})

-- ================= INITIALIZE =================
Rayfield:Notify({
    Title = "T&D Hub Perfect Loaded",
    Content = "อัปเดตระบบ Kill Aura และ Perfect Logic เรียบร้อยแล้ว!",
    Duration = 5
})
