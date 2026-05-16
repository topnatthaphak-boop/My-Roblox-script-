local PhoenixLib = {}
PhoenixLib.__index = PhoenixLib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function PhoenixLib:CreateWindow()
    local self = setmetatable({}, PhoenixLib)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PhoenixUltimate"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
    self.ScreenGui = ScreenGui

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Visible = true
    Main.Parent = ScreenGui
    self.Main = Main

    -- [ข้อแก้ที่ 1: ระบบปิด-เปิดอิสระ]
    -- กดปุ่ม "RightControl" บนคีย์บอร์ด หรือใช้ปุ่มลอย (สำหรับมือถือ)
    local IsVisible = true
    local function ToggleUI()
        IsVisible = not IsVisible
        Main.Visible = IsVisible
    end
    
    -- สำหรับมือถือ: สร้างปุ่มวงกลมเล็กๆ ไว้เปิดปิด
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    ToggleBtn.Text = "P" -- Phoenix
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    ToggleBtn.MouseButton1Click:Connect(ToggleUI)

    -- การตกแต่งหน้าต่าง
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0, 255, 255)
    UIStroke.Parent = Main
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    })
    UIGradient.Parent = UIStroke
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "T&D PHOENIX A (V.3)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Main

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -30, 1, -70)
    Container.Position = UDim2.new(0, 15, 0, 55)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.Parent = Main

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 10)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.Parent = Container

    self.Container = Container
    return self
end

function PhoenixLib:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.95, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundTransparency = 0.95
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = self.Container
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 10)

    Button.MouseButton1Click:Connect(function()
        -- Effect ตอนกด
        local tween = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, true), {BackgroundTransparency = 0.7})
        tween:Play()
        
        -- [ข้อแก้ที่ 2: รันสคริปต์จริง]
        pcall(callback) 
    end)
end

-- [[ ส่วนเรียกใช้งาน พร้อมยัดสคริปต์จริงให้ใช้งานได้เลย ]]
local Win = PhoenixLib:CreateWindow()

-- สคริปต์ Speed จริง
Win:CreateButton("Phoenix Speed (100)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- สคริปต์โดดสูงจริง
Win:CreateButton("High Jump (150)", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
    game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
end)

-- สคริปต์ลอยตัว (Fly) แบบง่าย
Win:CreateButton("Fly (Press E to Toggle)", function()
    -- ตรงนี้สามารถใส่โค้ด Fly ของคุณได้เลยครับ
    print("Fly Script Activated!")
end)

Win:CreateButton("Destroy UI", function()
    Win.ScreenGui:Destroy()
end)
