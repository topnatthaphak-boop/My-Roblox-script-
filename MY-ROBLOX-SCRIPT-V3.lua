local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ================= UTILS =================
local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() return char():FindFirstChildOfClass("Humanoid") end
local function hrp() return char():FindFirstChild("HumanoidRootPart") end

-- ================= UI SETUP =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Forsaken Edition",
    LoadingTitle = "Forsaken Script",
    LoadingSubtitle = "by Tokopp & Dola",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false -- ปิดระบบคีย์ถาวร
})

local Tab = Window:CreateTab("🏠 Main Features")

local state = {
    infStamina = false,
    safeSpeed = false,
    autoGen = false,
    espEnabled = false
}

-- 1. Stamina ไม่จำกัด (ตรวจสอบหาค่า Stamina ในเครื่องเล่น)
task.spawn(function()
    while task.wait(0.5) do
        if state.infStamina then
            -- ปรับตามโครงสร้างของแมพ Forsaken (ส่วนใหญ่อยู่ใน LocalPlayer หรือ Character)
            local stamina = player:FindFirstChild("Stamina") or char():FindFirstChild("Stamina")
            if stamina and stamina:IsA("NumberValue") then
                stamina.Value = 100
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Infinite Stamina (สเตมิน่าไม่จำกัด)",
    CurrentValue = false,
    Callback = function(v)
        state.infStamina = v
    end
})

-- 2. วิ่งเร็วแบบปลอดภัย (Safe Speed)
Tab:CreateSlider({
    Name = "Safe WalkSpeed",
    Range = {16, 45},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if hum() then
            hum().WalkSpeed = v
        end
    end
})

-- 3. Auto ปั่นไฟ (Auto Generator)
-- หมายเหตุ: ระบบนี้จะทำงานเมื่อเข้าใกล้ Generator และทำการส่ง Signal ปั่นไฟให้อัตโนมัติ
task.spawn(function()
    while task.wait(0.1) do
        if state.autoGen then
            -- ค้นหา Generator ใน Workspace (ชื่ออาจเปลี่ยนตามแมพ)
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("generator") and player:DistanceFromCharacter(v.PrimaryPart.Position) < 15 then
                    -- ส่งคำสั่งปั่นไฟ (ต้องปรับ Remote Event ตามของจริงในแมพ)
                    local remote = v:FindFirstChild("RemoteEvent") or game:GetService("ReplicatedStorage"):FindFirstChild("GenRemote")
                    if remote then
                        remote:FireServer()
                    end
                end
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Auto Repair (ปั่นไฟอัตโนมัติ)",
    CurrentValue = false,
    Callback = function(v)
        state.autoGen = v
    end
})

-- 4. ESP มองเห็นผู้เล่น (สีขาว)
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

Tab:CreateToggle({
    Name = "Player ESP (มองเห็นผู้เล่นสีขาว)",
    CurrentValue = false,
    Callback = function(v)
        state.espEnabled = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then CreateESP(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("TND_ESP") then
                    p.Character.TND_ESP:Destroy()
                end
            end
        end
    end
})

-- บันทึกการเพิ่มผู้เล่นใหม่เข้า ESP
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if state.espEnabled then
            task.wait(0.5)
            CreateESP(p)
        end
    end)
end)

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "ยินดีต้อนรับสู่ Forsaken Hub! ระบบคีย์ถูกปิดการใช้งานแล้ว",
    Duration = 5
})
