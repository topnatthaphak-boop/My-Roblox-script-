local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib

local TweenService = game:GetService("TweenService")

function PhoenixLib:CreateWindow()
    local self = setmetatable({}, PhoenixLib)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PhoenixReborn"
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
    self.ScreenGui = ScreenGui

    -- Main Window (ปรับให้ดูเพรียวและทันสมัยขึ้น)
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.BackgroundTransparency = 0.1 -- ให้ดูเหมือนกระจก
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    -- เพิ่มความมนแบบโค้งมน (Modern Rounded)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Main

    -- เส้นขอบนีออนแบบ Glow (เพิ่มความสว่าง)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1.8
    UIStroke.Color = Color3.fromRGB(0, 255, 255)
    UIStroke.Parent = Main
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    })
    UIGradient.Parent = UIStroke

    -- Title Bar
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "T&D PHOENIX A"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Main

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -30, 1, -70)
    Container.Position = UDim2.new(0, 15, 0, 55)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 0 -- ซ่อน Scrollbar ให้ดูสะอาด
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.Parent = Main

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 12) -- เพิ่มระยะห่างปุ่มให้ดูแพง
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.Parent = Container

    self.Container = Container
    return self
end

function PhoenixLib:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundTransparency = 0.95 -- ปุ่มแบบใสๆ
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = self.Container

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.8
    Stroke.Parent = Button

    -- Modern Hover Effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = 0.85, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.4}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        local circle = Instance.new("Frame") -- เอฟเฟกต์วงกลมตอนกด (Ripple)
        circle.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        circle.Size = UDim2.new(0, 0, 0, 0)
        circle.Position = UDim2.new(0.5, 0, 0.5, 0)
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.Parent = Button
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        TweenService:Create(circle, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 2, 0), BackgroundTransparency = 1}):Play()
        task.delay(0.4, function() circle:Destroy() end)
        
        callback()
    end)
end

-- สั่งรัน
local Win = PhoenixLib:CreateWindow()
Win:CreateButton("Speed Hack", function() end)
Win:CreateButton("Infinite Jump", function() end)
Win:CreateButton("Teleport to Home", function() end)
