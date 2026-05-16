-- [[ T&D PHOENIX A: PROJECT X24 (NO KEY VERSION) ]]
local _OWNER = "T&D Phoenix A"
local _AUTH_VAL = 1163

local function verify_integrity()
    local val = 0
    for i = 1, #_OWNER do val = val + string.byte(_OWNER, i) end
    return val
end

-- ตรวจสอบเครดิต (ถ้าแก้ชื่อเจ้าของ สคริปต์จะไม่ทำงาน)
if verify_integrity() ~= _AUTH_VAL then
    game.Players.LocalPlayer:Kick("X24: ตรวจพบการดัดแปลงเครดิตเจ้าของ!")
    return
end

local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

function PhoenixLib:CreateWindow(name)
    local self = setmetatable({}, PhoenixLib)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "PhoenixX24_NoKey"
    self.ScreenGui = ScreenGui

    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.Position = UDim2.new(0.5, -260, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Thickness = 2
    local Grad = Instance.new("UIGradient", Stroke)
    Grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))})

    local TabBar = Instance.new("Frame", Main)
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 130, 1, -60)
    TabBar.Position = UDim2.new(0, 10, 0, 50)
    TabBar.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabBar).Padding = UDim.new(0, 5)

    local ContainerHolder = Instance.new("Frame", Main)
    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Size = UDim2.new(1, -155, 1, -60)
    ContainerHolder.Position = UDim2.new(0, 145, 0, 50)
    ContainerHolder.BackgroundTransparency = 1
    self.ContainerHolder = ContainerHolder

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Text = "  " .. name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    self.Tabs = {}
    return self
end

function PhoenixLib:CreateTab(name)
    local TabBtn = Instance.new("TextButton", self.ScreenGui.MainWindow.TabBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame", self.ContainerHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
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
        local b = Instance.new("TextButton", Page)
        b.Size = UDim2.new(0.95, 0, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamMedium
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(callback)
    end
    return TabObj
end

-- [[ เริ่มรัน UI ]]
local UI = PhoenixLib:CreateWindow(_OWNER)

-- Intro Phoenix (รูปของคุณ)
local Intro = Instance.new("Frame", UI.ScreenGui)
Intro.Size = UDim2.new(1,0,1,0)
Intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
Intro.ZIndex = 100

local Logo = Instance.new("ImageLabel", Intro)
Logo.Size = UDim2.new(0,0,0,0)
Logo.Position = UDim2.new(0.5,0,0.5,0)
Logo.AnchorPoint = Vector2.new(0.5,0.5)
Logo.Image = "rbxassetid://74595572137034"
Logo.BackgroundTransparency = 1
Logo.ZIndex = 101

task.spawn(function()
    TweenService:Create(Logo, TweenInfo.new(1.5), {Size = UDim2.new(0, 350, 0, 350)}):Play()
    task.wait(2.5)
    TweenService:Create(Intro, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.8), {ImageTransparency = 1}):Play()
    UI.Main.Visible = true
    task.wait(0.8)
    Intro:Destroy()
end)

-- [[ เพิ่มหมวดหมู่และปุ่ม ]]
local MainTab = UI:CreateTab("Main Cheats")
MainTab:CreateButton("Speed Hack (100)", function() player.Character.Humanoid.WalkSpeed = 100 end)
MainTab:CreateButton("Infinite Jump", function()
    UIS.JumpRequest:Connect(function() player.Character.Humanoid:ChangeState("Jumping") end)
end)

local Others = UI:CreateTab("Others")
local noclip = false
RunService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
Others:CreateButton("Toggle NoClip", function() noclip = not noclip end)
Others:CreateButton("Destroy UI", function() UI.ScreenGui:Destroy() end)

local CreditTab = UI:CreateTab("Credits")
CreditTab:CreateButton("Dev: " .. _OWNER, function() setclipboard(_OWNER) end)
