local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- 1. สร้างหน้ากากหลัก (Full Screen)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phoenix_Intro_System"
ScreenGui.IgnoreGuiInset = true -- ทำให้บังเต็มหน้าจอจริงๆ
pcall(function() ScreenGui.Parent = CoreGui end)

-- 2. พื้นหลังสีดำสนิท (เหมือน Kahoot ตอนเริ่ม)
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- 3. เส้นขอบเรืองแสง (Shinee Rainbow)
local BorderStroke = Instance.new("UIStroke")
BorderStroke.Thickness = 4
BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BorderStroke.Parent = Background

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})
Gradient.Parent = BorderStroke

-- ทำให้ขอบหมุน (Shinee Effect)
task.spawn(function()
    while true do
        Gradient.Rotation = Gradient.Rotation + 1
        RunService.RenderStepped:Wait()
    end
end)

-- 4. ชื่อตรงกลาง "T&D Phoenix A"
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 0, 50)
Title.Position = UDim2.new(0.5, -200, 0.5, -30)
Title.BackgroundTransparency = 1
Title.Text = "T&D Phoenix A"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 40
Title.TextTransparency = 1 -- เริ่มจากล่องหน
Title.Parent = Background

-- 5. แถบโหลด (Progress Bar) ใต้ชื่อ
local BarBack = Instance.new("Frame")
BarBack.Size = UDim2.new(0, 300, 0, 4)
BarBack.Position = UDim2.new(0.5, -150, 0.5, 30)
BarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BarBack.BorderSizePixel = 0
BarBack.BackgroundTransparency = 1
BarBack.Parent = Background

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0) -- เริ่มจาก 0
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBack

-- [[ LOGIC การทำงานแบบสมูท ]] --

task.spawn(function()
    local fastInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    -- ปรากฏชื่อและแถบโหลด
    TweenService:Create(Title, fastInfo, {TextTransparency = 0}):Play()
    TweenService:Create(BarBack, fastInfo, {BackgroundTransparency = 0}):Play()
    task.wait(1)
    
    -- โหลดแถบสีขาวให้เต็ม (ใช้เวลา 3 วินาทีให้ดูขลัง)
    local loadTween = TweenService:Create(BarFill, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    loadTween:Play()
    loadTween.Completed:Wait()
    
    task.wait(0.5)
    
    -- ค่อยๆ หายไปแบบ Kahoot (Fade Out)
    local fadeInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(Title, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(BarBack, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Background, fadeInfo, {BackgroundTransparency = 1}):Play()
    
    task.wait(1.5)
    
    -- ลบ Intro และรันสคริปต์หลักของเรา!
    ScreenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/T%26D.lua"))()
end)
