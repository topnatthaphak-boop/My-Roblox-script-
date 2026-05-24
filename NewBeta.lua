local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "T&D Phoenix A | Classic Hub",
    LoadingTitle = "Loading Phoenix A...",
    LoadingSubtitle = "The Ultimate Black Hole System",
    ConfigurationSaving = {Enabled = false}
})

-- [ สร้างแท็บทั้งหมด ] --
local Tab = Window:CreateTab("Main (หลัก)")
local PlayerTab = Window:CreateTab("Player (ผู้เล่น)")
local SpecialTab = Window:CreateTab("Phoenix Special (พิเศษ)") -- แท็บใหม่สำหรับ 14 ฟังก์ชัน
local VisualTab = Window:CreateTab("Visual (การมองเห็น)")
local TrollTab = Window:CreateTab("Troll (เกรียน)")
local OthersTab = Window:CreateTab("Others (อื่นๆ)")
local UtilityTab = Window:CreateTab("Utility (เครื่องมือ)")
local WorldTab = Window:CreateTab("World (โลก)")
local DevTab = Window:CreateTab("Dev Tools (พัฒนา)")
local UpdateTab = Window:CreateTab("Updates (อัปเดต)")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end
local function root() local c = char() return c and c:FindFirstChild("HumanoidRootPart") end

local state = { noclip = false }
local targetPlaceId = 0
local targetPlayer = ""

-- [ MAIN TAB ] --
Tab:CreateToggle({
    Name = "Speed Toggle (วิ่งเร็ว)",
    CurrentValue = false,
    Callback = function(v)
        local h = hum()
        if h then h.WalkSpeed = v and 100 or 16 end
    end
})

Tab:CreateToggle({
    Name = "NoClip (ทะลุกำแพง)",
    CurrentValue = false,
    Callback = function(v) state.noclip = v end
})

Tab:CreateButton({
    Name = "ESP (มองทะลุตัวละคร)",
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
    Name = "God Mode (อมตะ/เลือดเด้งเร็ว)",
    Callback = function()
        RunService.RenderStepped:Connect(function()
            local h = hum()
            if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end)
    end
})

Tab:CreateToggle({
    Name = "Infinite Jump (กระโดดรัวๆ)",
    CurrentValue = false,
    Callback = function(v)
        _G.infinjump = v
        UserInputService.JumpRequest:Connect(function()
            if _G.infinjump then hum():ChangeState("Jumping") end
        end)
    end
})

-- [ PLAYER TAB ] --
PlayerTab:CreateInput({
    Name = "Target Player (ชื่อผู้เล่นเป้าหมาย)",
    PlaceholderText = "ใส่ชื่อผู้เล่นที่นี่...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) targetPlayer = Text end,
})

PlayerTab:CreateButton({
    Name = "🚀 TP To Player (วาร์ปไปหาผู้เล่น)",
    Callback = function()
        local t = Players:FindFirstChild(targetPlayer)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            char().HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
        end
    end
})

PlayerTab:CreateButton({
    Name = "👆 Ctrl + Click TP (กด Ctrl+คลิก เพื่อวาร์ป)",
    Callback = function()
        mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                char().HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "❤️ Auto Heal (เพิ่มเลือดอัตโนมัติ)",
    CurrentValue = false,
    Callback = function(v)
        _G.autoheal = v
        while _G.autoheal do
            task.wait(0.2)
            local h = hum()
            if h then h.Health = math.min(h.Health + 2, h.MaxHealth) end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "🐰 Bunny Hop (กระโดดต่อเนื่อง)",
    CurrentValue = false,
    Callback = function(v)
        _G.bhop = v
        while _G.bhop do task.wait() hum():ChangeState("Jumping") end
    end
})

PlayerTab:CreateToggle({
    Name = "🌀 Spin Jump (กระโดดหมุนตัว)",
    CurrentValue = false,
    Callback = function(v)
        _G.spinjump = v
        while _G.spinjump do
            task.wait()
            char().HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(25), 0)
            hum():ChangeState("Jumping")
        end
    end
})

PlayerTab:CreateButton({
    Name = "👁️ Spectate (ดูหน้าจอคนอื่น)",
    Callback = function()
        local t = Players:FindFirstChild(targetPlayer)
        if t and t.Character then workspace.CurrentCamera.CameraSubject = t.Character:FindFirstChild("Humanoid") end
    end
})

PlayerTab:CreateButton({
    Name = "🔄 Reset Camera (รีเซ็ตกล้องกลับมาที่ตัวเอง)",
    Callback = function() workspace.CurrentCamera.CameraSubject = hum() end
})

PlayerTab:CreateButton({
    Name = "🎯 Hitbox Expander (ขยายหัว/ตีง่ายขึ้น)",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local head = p.Character:FindFirstChild("Head")
                if head then head.Size = Vector3.new(7, 7, 7) head.Transparency = 0.5 head.Material = Enum.Material.Neon end
            end
        end
    end
})

-- [ PHOENIX SPECIAL - รวม 14 โค้ดใหม่ (แปลไทย) ] --
SpecialTab:CreateSection("ระบบเคลื่อนที่ & พลัง")

SpecialTab:CreateButton({
    Name = "🛸 Air Dash (พุ่งตัวกลางอากาศ)",
    Callback = function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(999999,999999,999999)
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 120
        bv.Parent = root()
        game.Debris:AddItem(bv, 0.25)
    end
})

local wallClimbOn = false
SpecialTab:CreateToggle({
    Name = "🕷️ Wall Climb (ไต่กำแพง)",
    CurrentValue = false,
    Callback = function(v)
        wallClimbOn = v
        task.spawn(function()
            while wallClimbOn do
                local ray = Ray.new(root().Position, root().CFrame.LookVector * 3)
                local hit = workspace:FindPartOnRay(ray, char())
                if hit then root().Velocity = Vector3.new(root().Velocity.X, 50, root().Velocity.Z) end
                task.wait()
            end
        end)
    end
})

local spiderWalkOn = false
SpecialTab:CreateToggle({
    Name = "🕸️ Spider Walk (เดินบนกำแพง)",
    CurrentValue = false,
    Callback = function(v)
        spiderWalkOn = v
        task.spawn(function()
            while spiderWalkOn do
                local rc = workspace:Raycast(root().Position, Vector3.new(0,-5,0))
                if rc then root().CFrame = CFrame.lookAt(root().Position, root().Position + workspace.CurrentCamera.CFrame.LookVector, rc.Normal) end
                task.wait()
            end
        end)
    end
})

SpecialTab:CreateToggle({
    Name = "🌌 Reverse Gravity (กลับแรงโน้มถ่วง)",
    CurrentValue = false,
    Callback = function(v) workspace.Gravity = v and -50 or 196.2 end
})

SpecialTab:CreateButton({
    Name = "🥷 TP Behind Player (วาร์ปไปหลังผู้เล่นเป้าหมาย)",
    Callback = function()
        local t = Players:FindFirstChild(targetPlayer)
        if t and t.Character then root().CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,5) end
    end
})

SpecialTab:CreateButton({
    Name = "👥 Ghost Clone Army (สร้างกองทัพเลียนแบบ)",
    Callback = function()
        for i = 1, 10 do
            char().Archivable = true
            local clone = char():Clone()
            clone.Parent = workspace
            clone:SetPrimaryPartCFrame(root().CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15)))
            for _,v in pairs(clone:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.5 v.Material = Enum.Material.Neon end end
            game.Debris:AddItem(clone, 5)
        end
    end
})

SpecialTab:CreateButton({
    Name = "🔥 Phoenix Transform (แปลงร่างฟีนิกซ์)",
    Callback = function()
        hum().WalkSpeed = 60
        local f = Instance.new("Fire", root()) f.Size = 15
        local l = Instance.new("PointLight", root()) l.Range = 20 l.Brightness = 5
        workspace.CurrentCamera.FieldOfView = 110
    end
})

SpecialTab:CreateToggle({
    Name = "⏳ Time Stop (หยุดเวลาโลก)",
    CurrentValue = false,
    Callback = function(v)
        for _,p in pairs(workspace:GetDescendants()) do if p:IsA("BasePart") and not p:IsDescendantOf(char()) then p.Anchored = v end end
        Lighting.ClockTime = v and 0 or 14
    end
})

SpecialTab:CreateButton({
    Name = "🌀 Create Portal (สร้างประตูมิติ)",
    Callback = function()
        local p = Instance.new("Part", workspace) p.Shape = "Cylinder" p.Size = Vector3.new(1,10,10) p.Anchored = true p.CanCollide = false p.Material = "Neon" p.Color = Color3.fromRGB(0,255,255)
        p.CFrame = root().CFrame * CFrame.new(0,0,-10) * CFrame.Angles(0,0,math.rad(90))
        p.Touched:Connect(function(h) if h.Parent:FindFirstChild("HumanoidRootPart") then h.Parent.HumanoidRootPart.CFrame = root().CFrame * CFrame.new(0,0,20) end end)
    end
})

SpecialTab:CreateSection("ระบบช่วยเหลือ & กลั่นแกล้ง")

SpecialTab:CreateButton({ Name = "🧠 Detect Admins (ตรวจจับแอดมิน)", Callback = function() for _,p in pairs(Players:GetPlayers()) do if p:GetRankInGroup(game.CreatorId) >= 200 then Rayfield:Notify({Title="ADMIN DETECTED", Content=p.Name, Duration=5}) end end end })
SpecialTab:CreateButton({ Name = "🧲 Auto Collect Tools (ดูดของอัตโนมัติ)", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") and v:FindFirstChild("Handle") then firetouchinterest(root(), v.Handle, 0) firetouchinterest(root(), v.Handle, 1) end end end })
SpecialTab:CreateToggle({ Name = "🌑 Corrupted Mode (โหมดมืดดำ)", CurrentValue = false, Callback = function(v) Lighting.ClockTime = v and 0 or 14 if v then local c = Instance.new("ColorCorrectionEffect", Lighting) c.Name = "Corrupt" c.TintColor = Color3.new(1,0,0) c.Saturation = -1 else if Lighting:FindFirstChild("Corrupt") then Lighting.Corrupt:Destroy() end end end })
SpecialTab:CreateButton({ Name = "☠️ Fake Ban Screen (แกล้งโดนแบน)", Callback = function() 
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(1,0,1,0) frame.BackgroundColor3 = Color3.new(0,0,0)
    local txt = Instance.new("TextLabel", frame) txt.Size = UDim2.new(1,0,0,100) txt.Position = UDim2.new(0,0,0.4,0) txt.BackgroundTransparency = 1 txt.TextScaled = true txt.Font = "GothamBold" txt.TextColor3 = Color3.new(1,0,0) txt.Text = "Your account has been terminated.\nReason: Exploiting Detected\nError Code: 267"
end })

-- [ VISUAL TAB ] --
VisualTab:CreateButton({
    Name = "☀️ FullBright (เพิ่มความสว่าง/ปิดเงา)",
    Callback = function()
        game.Lighting.Brightness = 5 game.Lighting.ClockTime = 14 game.Lighting.FogEnd = 100000 game.Lighting.GlobalShadows = false
    end
})

VisualTab:CreateButton({
    Name = "🌫️ Remove Fog (ลบหมอกออก)",
    Callback = function() game.Lighting.FogEnd = 100000 end
})

VisualTab:CreateButton({
    Name = "🩻 X-Ray Map (มองทะลุแมพ)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.LocalTransparencyModifier = 0.5 end
        end
    end
})

VisualTab:CreateButton({
    Name = "🌊 Remove Water (ลบน้ำออก/ทำให้น้ำใส)",
    Callback = function() workspace.Terrain.WaterTransparency = 1 end
})

VisualTab:CreateToggle({
    Name = "🌈 Rainbow Character (ตัวสีรุ้ง)",
    CurrentValue = false,
    Callback = function(v)
        _G.rainbow = v
        while _G.rainbow do
            task.wait()
            for _, part in pairs(char():GetChildren()) do
                if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick()%5/5, 1, 1) end
            end
        end
    end
})

VisualTab:CreateButton({
    Name = "🌙 Night Mode (โหมดกลางคืน)",
    Callback = function() game.Lighting.ClockTime = 0 end
})

VisualTab:CreateButton({
    Name = "👻 Invisible (ตัวล่องหน)",
    Callback = function()
        for _, v in pairs(char():GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 1 end end
    end
})

VisualTab:CreateButton({
    Name = "🏷️ Name ESP (แสดงชื่อผู้เล่นทะลุกำแพง)",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local bill = Instance.new("BillboardGui", p.Character.Head)
                bill.Size = UDim2.new(0, 100, 0, 40) bill.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1, 0, 1, 0) txt.Text = p.Name txt.BackgroundTransparency = 1 txt.TextColor3 = Color3.new(1, 0, 0)
            end
        end
    end
})

-- [ TROLL TAB ] --
TrollTab:CreateButton({
    Name = "☠️ Fake Death (แกล้งตาย)",
    Callback = function() hum():ChangeState(Enum.HumanoidStateType.Dead) end
})

TrollTab:CreateButton({
    Name = "💥 Fling Spin (สะบัดตัวให้คนอื่นกระเด็น)",
    Callback = function() char().HumanoidRootPart.RotVelocity = Vector3.new(99999, 99999, 99999) end
})

TrollTab:CreateToggle({
    Name = "🪑 Sit Spam (นั่งรัวๆ)",
    CurrentValue = false,
    Callback = function(v)
        _G.sitspam = v
        while _G.sitspam do task.wait(0.2) hum().Sit = true end
    end
})

TrollTab:CreateButton({
    Name = "🙃 Head Stand (ท่าเอาหัวเดิน)",
    Callback = function() char().HumanoidRootPart.CFrame *= CFrame.Angles(math.rad(90), 0, 0) end
})

TrollTab:CreateToggle({
    Name = "🌀 Spin Bot (ตัวหมุน)",
    CurrentValue = false,
    Callback = function(v)
        _G.spinning = v
        while _G.spinning do RunService.RenderStepped:Wait() char().HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(20), 0) end
    end
})

TrollTab:CreateToggle({
    Name = "📶 Fake Lag (ทำให้คนอื่นเห็นเรารันแลค)",
    CurrentValue = false,
    Callback = function(v)
        _G.fakelag = v
        while _G.fakelag do task.wait(0.3) char().HumanoidRootPart.Anchored = true task.wait(0.1) char().HumanoidRootPart.Anchored = false end
    end
})

TrollTab:CreateButton({
    Name = "☁️ Floating Platform (สร้างพื้นลอย)",
    Callback = function()
        local p = Instance.new("Part", workspace)
        p.Anchored = true p.Size = Vector3.new(10, 1, 10) p.CFrame = char().HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
    end
})

TrollTab:CreateToggle({
    Name = "🛸 Orbit Player (บินวนรอบเป้าหมาย)",
    CurrentValue = false,
    Callback = function(v)
        _G.orbiting = v local angle = 0
        while _G.orbiting do
            task.wait() local t = Players:FindFirstChild(targetPlayer)
            if t and t.Character then
                angle += 0.1
                local pos = t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(angle)*10, 3, math.sin(angle)*10)
                char().HumanoidRootPart.CFrame = CFrame.new(pos, t.Character.HumanoidRootPart.Position)
            end
        end
    end
})

-- [ OTHERS TAB ] --
OthersTab:CreateSection("ระบบวาร์ปข้ามแมพ")
OthersTab:CreateButton({ Name = "📋 Copy ID", Callback = function() setclipboard(tostring(game.PlaceId)) end })
OthersTab:CreateInput({ Name = "ใส่เลข ID แมพ", PlaceholderText = "วาง ID...", Callback = function(T) targetPlaceId = tonumber(T) end })
OthersTab:CreateButton({ Name = "🚀 TP ไปยัง ID", Callback = function() if targetPlaceId then TeleportService:Teleport(targetPlaceId) end end })

OthersTab:CreateSection("สคริปต์เสริมอื่นๆ")
OthersTab:CreateButton({ Name = "🛸 T&D V5.3 Pro (Fly & Sync)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/T%26D.lua"))() end })
OthersTab:CreateButton({ Name = "🔨 F3X Tool", Callback = function() pcall(function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end) end })
OthersTab:CreateButton({ Name = "♾️ IY (Infinite Yield)", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-IY-InfiniteYield-137097"))() end })
OthersTab:CreateButton({ Name = "🏙️ Hexagon Brookhaven", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ToraIsMe/ToraIsMe/main/0Hexagon')) end })
OthersTab:CreateButton({ Name = "👑 Hack Lord (1x1x1x1)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Atreous-Scripts/Hacklord/main/Hacklord.lua"))() end })

-- [ UTILITY TAB ] --
UtilityTab:CreateButton({ Name = "📋 Copy Username (ก๊อปชื่อไอดี)", Callback = function() setclipboard(player.Name) end })
UtilityTab:CreateButton({ Name = "🆔 Copy DisplayName (ก๊อปชื่อที่แสดง)", Callback = function() setclipboard(player.DisplayName) end })
UtilityTab:CreateButton({ Name = "📊 FPS Counter (แสดงค่า FPS ใน Console)", Callback = function() print("FPS: "..math.floor(workspace:GetRealPhysicsFPS())) end })
UtilityTab:CreateButton({ Name = "🗑️ Destroy Phoenix GUI (ปิดสคริปต์นี้)", Callback = function() game.CoreGui.Rayfield:Destroy() end })
UtilityTab:CreateButton({ Name = "🔄 Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, player) end })
UtilityTab:CreateButton({ Name = "💤 Anti AFK", Callback = function() local vu = game:GetService("VirtualUser") player.Idled:Connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end) end })

-- [ WORLD TAB ] --
WorldTab:CreateButton({ Name = "🌱 Remove Grass (ลบหญ้า)", Callback = function() workspace.Terrain.Decoration = false end })
WorldTab:CreateButton({ Name = "☁️ Remove Sky (ลบท้องฟ้า)", Callback = function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end })
WorldTab:CreateButton({ Name = "📉 Low Render (ลดระยะการมองเห็น/ลดแลค)", Callback = function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01 end })
WorldTab:CreateButton({ Name = "✨ Remove Particles (ลบเอฟเฟกต์พาร์ทิเคิล)", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end })
WorldTab:CreateButton({ Name = "⚡ FPS Boost", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 end end end })
WorldTab:CreateButton({ Name = "🗑️ Destroy Textures", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end end })

-- [ DEV & UPDATE ] --
DevTab:CreateButton({ Name = "Run Dex + SimpleSpy", Callback = function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SECURE-DEX-AND-REMOTE-SPY-205256"))() end) pcall(function() loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))() end) end })
UpdateTab:CreateLabel("Version: 5.0 (Ultimate Full Update)")
UpdateTab:CreateLabel("Developer: topnatthaphak-boop")

-- [ AUTO ESCAPE VOID ] --
local LastSafePosition = root().Position
RunService.Heartbeat:Connect(function()
    if root().Position.Y > 0 then LastSafePosition = root().Position end
    if root().Position.Y < -30 then root().CFrame = CFrame.new(LastSafePosition + Vector3.new(0,5,0)) end
end)

RunService.Stepped:Connect(function() if state.noclip then for _,v in pairs(char():GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
Rayfield:LoadConfiguration()
