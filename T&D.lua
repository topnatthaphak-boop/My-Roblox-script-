local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "tokopp Hub",
    LoadingTitle = "Loading tokopp...",
    LoadingSubtitle = "UI System",
    ConfigurationSaving = {Enabled = false}
})

-- สร้างแท็บทั้งหมด
local Tab = Window:CreateTab("Main")
local OthersTab = Window:CreateTab("Others (อื่นๆ)")
local DevTab = Window:CreateTab("Dev Tools (พัฒนา)")
local UpdateTab = Window:CreateTab("Updates (อัปเดต)")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end
local state = { fly = false, god = false, noclip = false, esp = false, infiniteJump = false }

-- [ MAIN TAB ]
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

RunService.Stepped:Connect(function()
    if state.noclip then
        local c = char()
        for _,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

Tab:CreateToggle({
    Name = "ESP (มองทะลุตัวละคร)",
    CurrentValue = false,
    Callback = function(v)
        state.esp = v
        if v then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "ESP"
                    h.FillColor = Color3.fromRGB(0,255,0)
                end
            end
        else
            for _,p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ESP") then p.Character.ESP:Destroy() end
            end
        end
    end
})

Tab:CreateToggle({
    Name = "God Mode (เลือดไม่ลด)",
    CurrentValue = false,
    Callback = function(v) state.god = v end
})

RunService.Heartbeat:Connect(function()
    if state.god then
        local h = hum()
        if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
    end
end)

Tab:CreateToggle({
    Name = "Infinite Jump (กระโดดไม่จำกัด)",
    CurrentValue = false,
    Callback = function(v) state.infiniteJump = v end
})

UIS.JumpRequest:Connect(function()
    if state.infiniteJump then
        local h = hum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==========================================
-- [ OTHERS TAB ] - คืนค่าฟังก์ชันทั้งหมดที่หายไป
-- ==========================================

-- 1. Fly
OthersTab:CreateButton({
    Name = "Fly (บิน) - Legend Script",
    Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
    end,
})

-- 2. F3X
OthersTab:CreateButton({
    Name = "F3X Building Tool",
    Callback = function()
        pcall(function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end)
    end,
})

-- 3. IY
OthersTab:CreateButton({
    Name = "IY (Infinite Yield)",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-IY-InfiniteYield-137097"))()
    end,
})

-- 4. ลำโพง
OthersTab:CreateButton({
    Name = "ลำโพง (Music Player)",
    Callback = function()
        -- [Speaker UI Code...]
        local screenGui = Instance.new("ScreenGui", player.PlayerGui)
        local frame = Instance.new("Frame", screenGui)
        frame.Size = UDim2.new(0, 300, 0, 150)
        frame.Position = UDim2.new(0.5, -150, 0.5, -75)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.Draggable = true
        frame.Active = true
        
        local input = Instance.new("TextBox", frame)
        input.Size = UDim2.new(0, 200, 0, 40)
        input.Position = UDim2.new(0.5, -100, 0.2, 0)
        input.PlaceholderText = "ใส่ ID เพลงตรงนี้"
        
        local play = Instance.new("TextButton", frame)
        play.Size = UDim2.new(0, 80, 0, 40)
        play.Position = UDim2.new(0.3, -40, 0.6, 0)
        play.Text = "เล่น"
        play.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        local sound = Instance.new("Sound", workspace)
        play.MouseButton1Click:Connect(function()
            sound.SoundId = "rbxassetid://" .. input.Text
            sound:Play()
        end)
    end,
})

-- 5. Hexagon Client
OthersTab:CreateButton({
    Name = "Hexagon Client",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-HX-Hexagon-Client-90722"))()
    end,
})

-- 6. แชทด่วน
OthersTab:CreateButton({
    Name = "แชทด่วน (Quick Chat)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/qJwH9964"))()
    end,
})

-- 7. Hack Lord
OthersTab:CreateButton({
    Name = "Hack Lord (1x1x1x1)",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-1x1x1x1-lord-by-White-Hat-71150"))()
    end,
})

-- 8. ย้อนเวลา
OthersTab:CreateButton({
    Name = "Time Travel (ย้อนเวลา)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/L"))()
    end,
})

-- [ DEV TOOLS TAB ]
DevTab:CreateButton({
    Name = "Run Dex + SimpleSpy (เรียกใช้พร้อมกัน)",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-SECURE-DEX-AND-REMOTE-SPY-205256"))() end)
        pcall(function() loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))() end)
        Rayfield:Notify({Title = "Success", Content = "เครื่องมือวิเคราะห์กำลังโหลด...", Duration = 3})
    end,
})

-- [ UPDATES TAB ]
UpdateTab:CreateSection("รายการที่กำลังพัฒนา")
UpdateTab:CreateParagraph({
    Title = "🐍 Python Developer Project", 
    Content = "ชื่อสคริปต์: Auto Farm V3\nสถานะ: [กำลังทดสอบ 🧪]\nแมพ: Blox Fruits\nรายละเอียด: ใช้ระบบวิเคราะห์ข้อมูลแบบใหม่เพื่อความปลอดภัย"
})

Rayfield:LoadConfiguration()
