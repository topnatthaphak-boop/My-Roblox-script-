local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "T&D Phoenix A | ภาษาไทย",
    LoadingTitle = "กำลังโหลด Phoenix A...",
    LoadingSubtitle = "ระบบแบล็คโฮลขั้นสุดยอด",
    ConfigurationSaving = {Enabled = false}
})

-- [ บริการเสริมและตัวแปรหลัก ] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end
local state = { noclip = false }
local targetPlaceId = 0
local targetPlayer = ""
local songId = "" -- ตัวแปรเก็บ ID เพลง
local currentSound = nil -- ตัวแปรเก็บ Object เสียง

local function getPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    return names
end

-- [ 1. แท็บหลัก (Main) ] --
local Tab = Window:CreateTab("หลัก (Main)")

Tab:CreateToggle({
    Name = "วิ่งเร็ว (Speed)",
    CurrentValue = false,
    Callback = function(v)
        local h = hum()
        if h then h.WalkSpeed = v and 100 or 16 end
    end
})

Tab:CreateToggle({
    Name = "เดินทะลุ (NoClip)",
    CurrentValue = false,
    Callback = function(v) state.noclip = v end
})

Tab:CreateButton({
    Name = "ESP (มองเห็นผู้เล่น)",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(0, 255, 0)
            end
        end
    end
})

Tab:CreateButton({
    Name = "โหมดอมตะ (God Mode)",
    Callback = function()
        RunService.RenderStepped:Connect(function()
            local h = hum()
            if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end)
    end
})

Tab:CreateToggle({
    Name = "กระโดดรัวๆ (Inf Jump)",
    CurrentValue = false,
    Callback = function(v)
        _G.infinjump = v
        UserInputService.JumpRequest:Connect(function()
            if _G.infinjump then hum():ChangeState("Jumping") end
        end)
    end
})

-- [ 2. แท็บผู้เล่น (Player) ] --
local PlayerTab = Window:CreateTab("ผู้เล่น (Player)")

local PlayerDropdown = PlayerTab:CreateDropdown({
    Name = "เลือกเป้าหมาย (Target)",
    Options = getPlayerNames(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(Option) targetPlayer = Option[1] end,
})

Players.PlayerAdded:Connect(function() PlayerDropdown:Refresh(getPlayerNames(), true) end)
Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(getPlayerNames(), true) end)

PlayerTab:CreateButton({
    Name = "🚀 วาร์ปไปหาเป้าหมาย",
    Callback = function()
        local t = Players:FindFirstChild(targetPlayer)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            char().HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
        end
    end
})

PlayerTab:CreateButton({
    Name = "👆 Ctrl + คลิก เพื่อวาร์ป",
    Callback = function()
        mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                char().HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "❤️ ปั๊มเลือด (Auto Heal)",
    CurrentValue = false,
    Callback = function(v)
        _G.autoheal = v
        while _G.autoheal do task.wait(0.2)
            local h = hum()
            if h then h.Health = math.min(h.Health + 2, h.MaxHealth) end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "🐰 บันนี่ฮอป (B-Hop)",
    CurrentValue = false,
    Callback = function(v)
        _G.bhop = v
        while _G.bhop do task.wait() hum():ChangeState("Jumping") end
    end
})

PlayerTab:CreateToggle({
    Name = "🌀 กระโดดหมุน (Spin Jump)",
    CurrentValue = false,
    Callback = function(v)
        _G.spinjump = v
        while _G.spinjump do task.wait()
            char().HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(25), 0)
            hum():ChangeState("Jumping")
        end
    end
})

PlayerTab:CreateButton({
    Name = "👁️ ส่องดูผู้เล่น (Spectate)",
    Callback = function()
        local t = Players:FindFirstChild(targetPlayer)
        if t and t.Character then workspace.CurrentCamera.CameraSubject = t.Character:FindFirstChild("Humanoid") end
    end
})

PlayerTab:CreateButton({
    Name = "🔄 คืนค่ากล้องเดิม",
    Callback = function() workspace.CurrentCamera.CameraSubject = hum() end
})

PlayerTab:CreateButton({
    Name = "🎯 ขยายหัว (Hitbox)",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local head = p.Character:FindFirstChild("Head")
                if head then head.Size = Vector3.new(7, 7, 7) head.Transparency = 0.5 head.Material = Enum.Material.Neon end
            end
        end
    end
})

-- [ 3. แท็บการมองเห็น (Visual) ] --
local VisualTab = Window:CreateTab("มองเห็น (Visual)")

VisualTab:CreateButton({
    Name = "☀️ เปิดไฟสว่าง (FullBright)",
    Callback = function()
        game.Lighting.Brightness = 5 game.Lighting.ClockTime = 14 game.Lighting.FogEnd = 100000 game.Lighting.GlobalShadows = false
    end
})

VisualTab:CreateButton({
    Name = "🌫️ ลบหมอก (Remove Fog)",
    Callback = function() game.Lighting.FogEnd = 100000 end
})

VisualTab:CreateButton({
    Name = "🩻 เอ็กซ์เรย์ (X-Ray)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.LocalTransparencyModifier = 0.5 end end
    end
})

VisualTab:CreateButton({
    Name = "🌊 ทำให้น้ำใส",
    Callback = function() workspace.Terrain.WaterTransparency = 1 end
})

VisualTab:CreateToggle({
    Name = "🌈 ตัวสีรุ้ง",
    CurrentValue = false,
    Callback = function(v)
        _G.rainbow = v
        while _G.rainbow do task.wait()
            for _, part in pairs(char():GetChildren()) do if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick()%5/5, 1, 1) end end
        end
    end
})

VisualTab:CreateButton({
    Name = "🌙 โหมดกลางคืน",
    Callback = function() game.Lighting.ClockTime = 0 end
})

VisualTab:CreateButton({
    Name = "👻 ตัวล่องหน",
    Callback = function()
        for _, v in pairs(char():GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 1 end end
    end
})

VisualTab:CreateButton({
    Name = "🏷️ แสดงชื่อผู้เล่น (Name ESP)",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local bill = Instance.new("BillboardGui", p.Character.Head)
                bill.Size = UDim2.new(0, 100, 0, 40) bill.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1, 0, 1, 0) txt.Text = p.Name txt.TextColor3 = Color3.new(1, 0, 0) txt.BackgroundTransparency = 1
            end
        end
    end
})

-- [ 4. แท็บเกรียน (Troll) ] --
local TrollTab = Window:CreateTab("เกรียน (Troll)")

TrollTab:CreateButton({
    Name = "☠️ แกล้งตาย (Fake Death)",
    Callback = function() hum():ChangeState(Enum.HumanoidStateType.Dead) end
})

TrollTab:CreateButton({
    Name = "💥 ตัวดีดสะบัด (Fling)",
    Callback = function() char().HumanoidRootPart.RotVelocity = Vector3.new(99999, 99999, 99999) end
})

TrollTab:CreateToggle({
    Name = "🪑 นั่งรัวๆ (Sit Spam)",
    CurrentValue = false,
    Callback = function(v) _G.sitspam = v while _G.sitspam do task.wait(0.2) hum().Sit = true end end
})

TrollTab:CreateButton({
    Name = "🙃 ท่าหัวเดินพื้น",
    Callback = function() char().HumanoidRootPart.CFrame *= CFrame.Angles(math.rad(90), 0, 0) end
})

local spinning = false
TrollTab:CreateToggle({
    Name = "🌀 ตัวหมุน (Spin Bot)",
    CurrentValue = false,
    Callback = function(v) spinning = v while spinning do RunService.RenderStepped:Wait() char().HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(20), 0) end end
})

local fakelag = false
TrollTab:CreateToggle({
    Name = "📶 แกล้งแลค (Fake Lag)",
    CurrentValue = false,
    Callback = function(v) fakelag = v while fakelag do task.wait(0.3) char().HumanoidRootPart.Anchored = true task.wait(0.1) char().HumanoidRootPart.Anchored = false end end
})

TrollTab:CreateButton({
    Name = "☁️ สร้างพื้นลอย",
    Callback = function()
        local p = Instance.new("Part", workspace)
        p.Anchored = true p.Size = Vector3.new(10, 1, 10) p.CFrame = char().HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
    end
})

local orbiting = false
TrollTab:CreateToggle({
    Name = "🛸 บินวนรอบเป้าหมาย",
    CurrentValue = false,
    Callback = function(v)
        orbiting = v local angle = 0
        while orbiting do task.wait() local t = Players:FindFirstChild(targetPlayer)
            if t and t.Character then angle += 0.1
                local pos = t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(angle)*10, 3, math.sin(angle)*10)
                char().HumanoidRootPart.CFrame = CFrame.new(pos, t.Character.HumanoidRootPart.Position)
            end
        end
    end
})

-- [ 5. แท็บอื่นๆ (Others) ] --
local OthersTab = Window:CreateTab("อื่นๆ (Others)")

-- เพิ่มระบบเล่นเพลง ID (ฟังก์ชันใหม่)
OthersTab:CreateSection("🎵 ระบบเครื่องเล่นเพลง (Music Player)")

OthersTab:CreateInput({
    Name = "ใส่ ID เพลง (Song ID)",
    PlaceholderText = "วาง ID เพลงที่นี่...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        songId = Text
    end,
})

OthersTab:CreateButton({
    Name = "▶️ เล่น ID เพลง",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
        end
        if songId ~= "" then
            currentSound = Instance.new("Sound")
            currentSound.Parent = game:GetService("SoundService")
            currentSound.SoundId = "rbxassetid://" .. songId
            currentSound.Volume = 2
            currentSound:Play()
            Rayfield:Notify({Title = "เล่นเพลง", Content = "กำลังเล่นเพลง ID: "..songId, Duration = 3})
        else
            Rayfield:Notify({Title = "แจ้งเตือน", Content = "กรุณาใส่ ID เพลงก่อน", Duration = 3})
        end
    end
})

OthersTab:CreateButton({
    Name = "⏹️ หยุดเล่นเพลง",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
            currentSound = nil
        end
    end
})

OthersTab:CreateSection("วาร์ปข้ามแมพ")
OthersTab:CreateButton({ Name = "📋 ก๊อป ID แมพ", Callback = function() setclipboard(tostring(game.PlaceId)) end })
OthersTab:CreateInput({ Name = "ใส่ ID แมพ", PlaceholderText = "วางที่นี่...", Callback = function(T) targetPlaceId = tonumber(T) end })
OthersTab:CreateButton({ Name = "🚀 ไปยังแมพ ID", Callback = function() if targetPlaceId then TeleportService:Teleport(targetPlaceId) end end })

OthersTab:CreateSection("สคริปต์เสริม")
OthersTab:CreateButton({ Name = "🛸 T&D V5.3 (บิน)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/T%26D.lua"))() end })
OthersTab:CreateButton({ Name = "🔨 F3X (สร้างของ)", Callback = function() pcall(function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end) end })
OthersTab:CreateButton({ Name = "♾️ Infinite Yield", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-IY-InfiniteYield-137097"))() end })
OthersTab:CreateButton({ Name = " kings Brookhaven", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ToraIsMe/ToraIsMe/main/0Hexagon'))() end })
OthersTab:CreateButton({ Name = "👑 Hack Lord", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Atreous-Scripts/Hacklord/main/Hacklord.lua"))() end })

-- [ 6. แท็บเครื่องมือ (Utility) ] --
local UtilityTab = Window:CreateTab("เครื่องมือ (Tool)")
UtilityTab:CreateButton({ Name = "📋 ก๊อปชื่อ ID", Callback = function() setclipboard(player.Name) end })
UtilityTab:CreateButton({ Name = "📊 เช็ค FPS", Callback = function() print("FPS: "..math.floor(workspace:GetRealPhysicsFPS())) end })
UtilityTab:CreateButton({ Name = "🗑️ ปิดเมนู Phoenix", Callback = function() game.CoreGui.Rayfield:Destroy() end })
UtilityTab:CreateButton({ Name = "🔄 เริ่มใหม่ (Rejoin)", Callback = function() TeleportService:Teleport(game.PlaceId, player) end })
UtilityTab:CreateButton({ Name = "💤 ป้องกัน AFK", Callback = function() local vu = game:GetService("VirtualUser") player.Idled:Connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end) end })

-- [ 7. แท็บโลก (World) ] --
local WorldTab = Window:CreateTab("โลก (World)")
WorldTab:CreateButton({ Name = "🌱 ลบหญ้า", Callback = function() workspace.Terrain.Decoration = false end })
WorldTab:CreateButton({ Name = "☁️ ลบท้องฟ้า", Callback = function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end })
WorldTab:CreateButton({ Name = "📉 ลดระยะแมพ (ลดแลค)", Callback = function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01 end })
WorldTab:CreateButton({ Name = "✨ ลบเอฟเฟกต์", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end })
WorldTab:CreateButton({ Name = "⚡ FPS Boost", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 end end end })
WorldTab:CreateButton({ Name = "🗑️ ลบ Textures", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end end })

-- [ 8. แท็บพัฒนา (Dev) ] --
local DevTab = Window:CreateTab("พัฒนา (Dev)")
DevTab:CreateButton({ Name = "Run Dex + SimpleSpy", Callback = function() 
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SECURE-DEX-AND-REMOTE-SPY-205256"))() end) 
    pcall(function() loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))() end) 
end })

-- [ 9. แท็บอัปเดต (Update) ] --
local UpdateTab = Window:CreateTab("อัปเดต (Update)")
UpdateTab:CreateLabel("Version: 4.5 (Thai & Dropdown)")
UpdateTab:CreateLabel("Developer: topnatthaphak-boop")

-- [ Noclip Logic ] --
RunService.Stepped:Connect(function() if state.noclip then for _,v in pairs(char():GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

Rayfield:LoadConfiguration()
