local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function PhoenixLib:CreateWindow()
    local self = setmetatable({}, PhoenixLib)
    
    -- 1. สร้าง ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TD_Phoenix_A_X24"
    ScreenGui.ResetOnSpawn = false
    -- ตรวจสอบสิทธิ์สำหรับ Delta
    pcall(function() 
        ScreenGui.Parent = CoreGui 
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = ScreenGui

    -- 2. Intro: Black Hole & Logo Reveal
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IntroFrame.ZIndex = 100
    IntroFrame.Parent = ScreenGui

    local Logo = Instance.new("ImageLabel")
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    Logo.Size = UDim2.new(0, 0, 0, 0) -- เริ่มจากจุดศูนย์กลาง
    Logo.Image = "rbxassetid://74595572137034" -- ID ของคุณ
    Logo.BackgroundTransparency = 1
    Logo.ZIndex = 101
    Logo.Parent = IntroFrame

    -- 3. Main Window Design (สวยแปลกใหม่)
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 500, 0, 320)
    Main.Position = UDim2.new(0.5, -250, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false
    Main.Parent = ScreenGui
    self.Main = Main

    -- เส้นขอบเรืองแสงสไตล์ Phoenix
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), -- Cyan
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))  -- Magenta
    })
    Gradient.Parent = UIStroke
    UIStroke.Parent = Main

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main

    -- Container สำหรับปุ่ม
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -30, 1, -50)
    Container.Position = UDim2.new(0, 15, 0, 25)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.Parent = Main
    self.Container = Container

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 8)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.Parent = Container

    -- 4. เล่น Animation เปิดตัว
    task.spawn(function()
        local info = TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        
        -- หลุมดำขยายโลโก้ออกมา
        TweenService:Create(Logo, info, {Size = UDim2.new(0, 380, 0, 380)}):Play()
        task.wait(2.5)
        
        -- ค่อยๆ จางโลโก้และเปิดหน้าต่าง Main
        TweenService:Create(IntroFrame, info, {BackgroundTransparency = 1}):Play()
        TweenService:Create(Logo, info, {ImageTransparency = 1, Size = UDim2.new(0, 600, 0, 600)}):Play()
        
        task.wait(0.3)
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, info, {Size = UDim2.new(0, 500, 0, 320)}):Play()
        
        task.wait(1.5)
        IntroFrame:Destroy()
    end)

    return self
end

function PhoenixLib:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(0.95, 0, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Button.Text = "  " .. text
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false
    Button.Parent = self.Container

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(0, 255, 255)
    Stroke.Transparency = 0.7
    Stroke.Parent = Button

    -- Interaction Effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0, Thickness = 1.5}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 35), TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.7, Thickness = 1}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        local clickEffect = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(0.9, 0, 0, 38)})
        clickEffect:Play()
        callback()
    end)
end

-- [[ ส่วนเรียกใช้งาน ]]
local MyWindow = PhoenixLib:CreateWindow()

MyWindow:CreateButton("Phoenix Speed (100)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

MyWindow:CreateButton("High Jump (150)", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
end)

MyWindow:CreateButton("Destroy UI", function()
    MyWindow.ScreenGui:Destroy()
end)
