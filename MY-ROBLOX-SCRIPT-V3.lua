local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ================= UI SETUP =================
local Window = Rayfield:CreateWindow({
    Name = "T&D Hub | Forsaken Pro",
    LoadingTitle = "Extracting Data...",
    LoadingSubtitle = "by Tokopp & Dola",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local Tab = Window:CreateTab("🚀 Forsaken Features")

local state = {
    infStamina = false,
    autoGen = false,
    espEnabled = false
}

-- [แกะระบบจาก V4] 1. Infinite Stamina (เทคนิค Force Value & Attribute)
-- เทคนิคนี้จะไล่เช็คทุก Object ที่เกี่ยวข้องกับค่า Stamina ไม่ว่าจะอยู่ในตัวละครหรือใน Folder ข้อมูล
task.spawn(function()
    while task.wait(0.1) do
        if state.infStamina then
            pcall(function()
                -- 1. เช็คใน Character (ส่วนใหญ่แมพ Forsaken จะเก็บไว้ที่นี่)
                local char = player.Character
                if char then
                    -- บังคับค่า Attribute (แมพใหม่ๆ ชอบใช้แบบนี้)
                    char:SetAttribute("Stamina", 100)
                    char:SetAttribute("StaminaValue", 100)
                    
                    -- ไล่หา Value ที่ชื่อ Stamina ในตัวละคร
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            if v.Name:lower():find("stamina") or v.Name:lower():find("stam") then
                                v.Value = 100
                            end
                        end
                    end
                end
                
                -- 2. เช็คใน Folder ข้อมูลผู้เล่น (เผื่อบางเวอร์ชันเก็บไว้ใน PlayerData)
                local data = player:FindFirstChild("leaderstats") or player:FindFirstChild("Data")
                if data then
                    local st = data:FindFirstChild("Stamina")
                    if st then st.Value = 100 end
                end
            end)
        end
    end
end)

Tab:CreateToggle({
    Name = "Infinite Stamina (แกะสูตร V4)",
    CurrentValue = false,
    Callback = function(v)
        state.infStamina = v
    end
})

-- 2. Safe Speed (ปรับปรุงให้ลื่นขึ้น)
Tab:CreateSlider({
    Name = "Safe Speed (16 - 40)",
    Range = {16, 40},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- 3. Auto Generator (อ้างอิงชื่อจาก Data แมพ Forsaken)
task.spawn(function()
    while task.wait(0.5) do
        if state.autoGen then
            for _, v in pairs(workspace:GetDescendants()) do
                -- แมพ Forsaken มักใช้ชื่อ Gen หรือ RepairStation
                if v.Name == "Generator" or v.Name:find("Repair") then
                    if player:DistanceFromCharacter(v:GetModelCFrame().p) < 15 then
                        -- ส่งสัญญาณไปที่ Remote (อ้างอิงจากโครงสร้าง V4)
                        local rem = v:FindFirstChildOfClass("RemoteEvent") 
                        if rem then
                            rem:FireServer()
                        end
                    end
                end
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Auto Generator",
    CurrentValue = false,
    Callback = function(v) state.autoGen = v end
})

-- 4. ESP (มองเห็นคนสีขาว)
local function CreateESP(p)
    if p == player or not p.Character then return end
    if p.Character:FindFirstChild("TND_Highlight") then return end
    
    local h = Instance.new("Highlight")
    h.Name = "TND_Highlight"
    h.Adornee = p.Character
    h.FillColor = Color3.fromRGB(255, 255, 255)
    h.OutlineColor = Color3.fromRGB(200, 200, 200)
    h.FillTransparency = 0.5
    h.Parent = p.Character
end

Tab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        state.espEnabled = v
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("TND_Highlight") then
                    p.Character.TND_Highlight:Destroy()
                end
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if state.espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            CreateESP(p)
        end
    end
end)

Rayfield:Notify({
    Title = "Script Ready",
    Content = "ดึงข้อมูล Stamina จาก V4 เรียบร้อยแล้ว!",
    Duration = 5
})
