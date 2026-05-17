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
    ScreenGui.Name = "PhoenixProjectX24_Updated"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end
    self.ScreenGui = ScreenGui

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.Parent = ScreenGui
    self.Main = Main

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

    -- [[ 3. RGB Border Logic ]]
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2.5
    Stroke.Parent = Main
    
    task.spawn(function()
        local hue = 0
        while task.wait() do
            hue = hue + (1/300) -- ความเร็วในการเปลี่ยนสี
            if hue > 1 then hue = 0 end
            Stroke.Color = Color3.fromHSV(hue, 1, 1)
        end
    end)

    -- Sidebar & Content
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 140, 1, -50)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    
    local TabList = Instance.new("UIListLayout", TabBar)
    TabList.Padding = UDim.new(0, 6)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -170, 1, -55)
    ContainerHolder.Position = UDim2.new(0, 155, 0, 45)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = Main
    self.ContainerHolder = ContainerHolder

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "  " .. name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    self.Tabs = {}
    return self
end

function PhoenixLib:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Parent = self.Main:FindFirstChild("TabBar")
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = self.ContainerHolder
    
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 8)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    TabBtn.MouseButton1Click:Connect(function()
        for _,v in pairs(self.Tabs) do 
            v.Page.Visible = false 
            v.Btn.TextColor3 = Color3.fromRGB(200, 200, 200) 
            v.Btn.BackgroundTransparency = 0.5
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        TabBtn.BackgroundTransparency = 0.2
    end)

    table.insert(self.Tabs, {Btn = TabBtn, Page = Page})
    if #self.Tabs == 1 then 
        Page.Visible = true 
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255) 
    end

    local TabObj = {}
    
    function TabObj:CreateButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 42)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.Parent = Page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
    end

    function TabObj:CreateToggle(text, callback)
        local enabled = false
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 42)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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

-- [[ LOGIC SETUP ]]
local state = { noclip = false, god = false, infiniteJump = false }
local UI = PhoenixLib:CreateWindow("T&D Phoenix A")

-- Create Tabs
local MainTab = UI:CreateTab("Main")
local OthersTab = UI:CreateTab("Others")
local DevTab = UI:CreateTab("Dev Tools")
local UpdateTab = UI:CreateTab("Updates")

-- [[ MAIN TAB FUNCTIONS ]]
MainTab:CreateToggle("Speed Hack (วิ่งเร็ว)", function(v)
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

-- [[ OTHERS TAB FUNCTIONS ]]
OthersTab:CreateButton("Fly (บิน) - Legend Script", function()
    loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\\49\\52\\101\\55\\52\\102\\52\\50\\53\\98\\48\\54\\48\\100\\102\\53\\50\\51\\51\\52\\51\\99\\102\\51\\48\\98\\55\\56\\55\\48\\55\\52\\101\\98\\51\\99\\53\\100\\50\\47\\97\\114\\119\\47\\101\\114\\99\\101\\117\\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

OthersTab:CreateButton("IY (Infinite Yield)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

OthersTab:CreateButton("Destroy UI", function() UI.ScreenGui:Destroy() end)

-- [[ DEV TOOLS ]]
DevTab:CreateButton("Run Dex + SimpleSpy", function()
    pcall(function() loadstring(game:HttpGet("https://gist.githubusercontent.com/Tesker-103/a6befb538ace942399d01015477f00e4/raw/d5d510fd6676d50eb64a71a2ac84fdce0a571ab0/secure_dexbytesker103"))() end)
    pcall(function() loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))() end)
end)

-- [[ NEW INTRO: BLACK HOLE EFFECT ]]
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
    -- ขยาย Logo ออกมาตอนเริ่ม
    TweenService:Create(Logo, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 300)}):Play()
    task.wait(2)
    
    -- จังหวะหลุมดำดูด: หมุน 360 องศา + บีบขนาดเหลือ 0
    local suckInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    TweenService:Create(Logo, suckInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = 360
    }):Play()
    
    -- ทำให้พื้นหลังค่อยๆ จางหายไปพร้อมกัน
    TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    
    task.wait(1)
    UI.Main.Visible = true -- แสดง UI หลักหลังจากโดนดูดเสร็จ
    IntroFrame:Destroy()
end)
