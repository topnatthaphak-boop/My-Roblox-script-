local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [[ UI LIBRARY CORE ]]
function PhoenixLib:CreateWindow(name)
    local self = setmetatable({}, PhoenixLib)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PhoenixProjectX24_Final"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end
    self.ScreenGui = ScreenGui

    -- [[ 1. ปรับพื้นหลังให้จางมองทะลุได้ (เทาจาง) ]]
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 560, 0, 390)
    Main.Position = UDim2.new(0.5, -280, 0.5, -195)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- สีเทาเข้ม
    Main.BackgroundTransparency = 0.3 -- ค่าความจางที่ทำให้มองทะลุได้นิดนึงแบบพรีเมียม
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.Parent = ScreenGui
    self.Main = Main

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- [[ RGB Border (ขอบไฟวิ่ง) ]]
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 3
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Main
    
    task.spawn(function()
        local hue = 0
        while task.wait() do
            hue = hue + (1/400)
            if hue > 1 then hue = 0 end
            Stroke.Color = Color3.fromHSV(hue, 0.8, 1)
        end
    end)

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 150, 1, -60)
    TabBar.Position = UDim2.new(0, 12, 0, 50)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    
    Instance.new("UIListLayout", TabBar).Padding = UDim.new(0, 7)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -185, 1, -65)
    ContainerHolder.Position = UDim2.new(0, 170, 0, 50)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = Main
    self.ContainerHolder = ContainerHolder

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 50)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    self.Tabs = {}
    return self
end

function PhoenixLib:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Parent = self.Main.TabBar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = self.ContainerHolder
    
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 10)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabBtn.MouseButton1Click:Connect(function()
        for _,v in pairs(self.Tabs) do 
            v.Page.Visible = false 
            v.Btn.TextColor3 = Color3.fromRGB(200, 200, 200) 
            v.Btn.BackgroundTransparency = 0.6
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        TabBtn.BackgroundTransparency = 0.3
    end)

    table.insert(self.Tabs, {Btn = TabBtn, Page = Page})
    if #self.Tabs == 1 then Page.Visible = true TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255) end

    local TabObj = {}
    function TabObj:CreateButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.BackgroundTransparency = 0.4
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = Page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
    end

    function TabObj:CreateToggle(text, callback)
        local enabled = false
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.BackgroundTransparency = 0.4
        btn.Text = text .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = Page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            btn.Text = text .. (enabled and ": ON" or ": OFF")
            btn.TextColor3 = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            callback(enabled)
        end)
    end
    return TabObj
end

-- [[ 2. ฟังก์ชันครบ 100% จาก Beta-T&D ]]
local state = { noclip = false, god = false, esp = false, infiniteJump = false }
local UI = PhoenixLib:CreateWindow("T&D Phoenix A")

local MainTab = UI:CreateTab("Main (พรรณนา)")
local OthersTab = UI:CreateTab("Others (อื่นๆ)")
local DevTab = UI:CreateTab("Dev Tools")
local UpdateTab = UI:CreateTab("Updates")

-- MAIN TAB
MainTab:CreateToggle("Speed Hack (พลัง XD)", function(v)
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = v and 100 or 16 end
end)

MainTab:CreateToggle("NoClip (ทะลุกำแพง)", function(v) state.noclip = v end)
RunService.Stepped:Connect(function()
    if state.noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

MainTab:CreateToggle("ESP (มองทะลุตัวละคร)", function(v)
    state.esp = v
    if v then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "X24_ESP"
                h.FillColor = Color3.fromRGB(0, 255, 0)
            end
        end
    else
        for _,p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("X24_ESP") then p.Character.X24_ESP:Destroy() end
        end
    end
end)

MainTab:CreateToggle("God Mode (เลือดไม่ลด)", function(v) state.god = v end)
RunService.Heartbeat:Connect(function()
    if state.god and player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
    end
end)

MainTab:CreateToggle("Infinite Jump", function(v) state.infiniteJump = v end)
UIS.JumpRequest:Connect(function()
    if state.infiniteJump and player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- OTHERS TAB (Fix Scripts)
OthersTab:CreateButton("Fly (บิน) - Legend Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/T%26D.lua"))()
end)

OthersTab:CreateButton("IY (Infinite Yield)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

OthersTab:CreateButton("Hexagon Client", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Ice-Yolks/Hexagon/main/Hexagon.lua"))()
end)

OthersTab:CreateButton("1x1x1x1 Lord", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/White-Hat-Hacker/1x1x1x1-Lord/main/Script.lua"))()
end)

OthersTab:CreateButton("Destroy UI", function() UI.ScreenGui:Destroy() end)

-- DEV TOOLS
DevTab:CreateButton("Run Secure Dex", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

DevTab:CreateButton("Run SimpleSpy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
end)

-- UPDATES
UpdateTab:CreateButton("Version: 2.0 (Fortress XD)", function() end)
UpdateTab:CreateButton("Status: Secured & NoKey", function() end)

-- [[ INTRO: BLACK HOLE EFFECT ]]
local IntroFrame = Instance.new("Frame", UI.ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
IntroFrame.ZIndex = 100

local Logo = Instance.new("ImageLabel", IntroFrame)
Logo.Size = UDim2.new(0,0,0,0)
Logo.Position = UDim2.new(0.5,0,0.5,0)
Logo.AnchorPoint = Vector2.new(0.5,0.5)
Logo.Image = "rbxassetid://74595572137034"
Logo.BackgroundTransparency = 1
Logo.ZIndex = 101

task.spawn(function()
    TweenService:Create(Logo, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 300)}):Play()
    task.wait(2.5)
    
    local suckInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    TweenService:Create(Logo, suckInfo, {Size = UDim2.new(0, 0, 0, 0), Rotation = 360}):Play()
    TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    
    task.wait(1)
    UI.Main.Visible = true
    IntroFrame:Destroy()
end)
