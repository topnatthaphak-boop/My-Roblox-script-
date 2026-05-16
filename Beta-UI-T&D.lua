local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [[ PROJECT X24 DATA ]]
local _OWNER = "T&D Phoenix A"
local _AUTH_VAL = 1163
local _SECURE_KEY = "X24-PRO"
local _is_authorized = false

-- ตรวจสอบชื่อเจ้าของ (XD Formula)
local function verify_integrity()
    local val = 0
    for i = 1, #_OWNER do val = val + string.byte(_OWNER, i) end
    return val
end

-- [[ UI LIBRARY CORE ]]
function PhoenixLib:CreateWindow(name)
    local self = setmetatable({}, PhoenixLib)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PhoenixProjectX24"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end
    self.ScreenGui = ScreenGui

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.Position = UDim2.new(0.5, -260, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.Parent = ScreenGui
    self.Main = Main

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(0, 255, 255)
    Stroke.Parent = Main
    local Grad = Instance.new("UIGradient", Stroke)
    Grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))})

    -- Sidebar & Content
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0, 130, 1, -50)
    TabBar.Position = UDim2.new(0, 10, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    
    local TabList = Instance.new("UIListLayout", TabBar)
    TabList.Padding = UDim.new(0, 5)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Size = UDim2.new(1, -155, 1, -50)
    ContainerHolder.Position = UDim2.new(0, 145, 0, 40)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = Main
    self.ContainerHolder = ContainerHolder

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "  " .. name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    self.Tabs = {}
    return self
end

function PhoenixLib:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Parent = self.Main.Frame -- จะถูกย้ายไป TabBar อัตโนมัติจาก UIListLayout
    TabBtn.Parent = self.Main:FindFirstChild("Frame") or self.Main:GetChildren()[3] -- fallback
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = self.ContainerHolder
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _,v in pairs(self.Tabs) do v.Page.Visible = false v.Btn.TextColor3 = Color3.fromRGB(200, 200, 200) end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    end)

    table.insert(self.Tabs, {Btn = TabBtn, Page = Page})
    if #self.Tabs == 1 then Page.Visible = true TabBtn.TextColor3 = Color3.fromRGB(0, 255, 255) end

    local TabObj = {}
    function TabObj:CreateButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = Page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
    end
    return TabObj
end

-- [[ START INTEGRATION LOGIC ]]
local UI = PhoenixLib:CreateWindow(_OWNER)

-- Intro หลุมดำ
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
    TweenService:Create(Logo, TweenInfo.new(1.5), {Size = UDim2.new(0, 350, 0, 350)}):Play()
    task.wait(2.5)
    TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Logo, TweenInfo.new(1), {ImageTransparency = 1}):Play()
    UI.Main.Visible = true
    IntroFrame:Destroy()
end)

-- หน้า Key System (จำลองใน Tab แรก)
local KeyTab = UI:CreateTab("Secure Access")
KeyTab:CreateButton("Verify Key: " .. _SECURE_KEY, function()
    if verify_integrity() == _AUTH_VAL then
        _is_authorized = true
        print("Authorized Success!")
        -- เปิด Tab อื่นๆ ที่ซ่อนไว้ (หรือสร้างใหม่)
    else
        player:Kick("X24: ตรวจพบการดัดแปลง!")
    end
end)

-- หน้าฟังก์ชัน (Main)
local MainTab = UI:CreateTab("Main (Cheats)")
local xd_speed = (verify_integrity() / 11.63)

MainTab:CreateButton("Speed Hack (XD Power)", function()
    local h = player.Character.Humanoid
    h.WalkSpeed = xd_speed
end)

MainTab:CreateButton("Infinite Jump", function()
    UIS.JumpRequest:Connect(function()
        player.Character.Humanoid:ChangeState("Jumping")
    end)
end)

-- หน้าอื่นๆ
local Others = UI:CreateTab("Others")
Others:CreateButton("Destroy UI", function() UI.ScreenGui:Destroy() end)

-- ระบบ NoClip จากไฟล์ที่คุณส่งมา
local noclip = false
RunService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
Others:CreateButton("Toggle NoClip", function() noclip = not noclip end)
