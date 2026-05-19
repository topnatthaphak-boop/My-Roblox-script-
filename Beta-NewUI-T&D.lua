local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- 1. ระบบเสียงแบบวนลูปต่อเนื่อง (Persistent Music)
local Music = Instance.new("Sound")
Music.Name = "Phoenix_Atmosphere"
Music.SoundId = "rbxassetid://88927553987952" 
Music.Volume = 0.5 -- ความดังแบบพอดี ไม่กวนการเล่น
Music.Looped = true -- ให้เพลงวนไปเรื่อยๆ ไม่หยุด
Music.Parent = SoundService -- เก็บไว้ใน SoundService เพื่อให้เล่นต่อเนื่องได้ดี

-- 2. สร้างหน้ากากหลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phoenix_Intro_System"
ScreenGui.IgnoreGuiInset = true 
pcall(function() ScreenGui.Parent = CoreGui end)

-- 3. พื้นหลังสีดำ
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- 4. เส้นขอบ Shiny
local BorderStroke = Instance.new("UIStroke")
BorderStroke.Thickness = 3
BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BorderStroke.Color = Color3.fromRGB(255, 255, 255)
BorderStroke.Transparency = 0.6
BorderStroke.Parent = Background

-- 5. เส้นแสงเฉียง (Shine Overlay)
local Shine = Instance.new("Frame")
Shine.Size = UDim2.new(0, 60, 2, 0)
Shine.Position = UDim2.new(-0.5, 0, -0.5, 0)
Shine.Rotation = 35
Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shine.BorderSizePixel = 0
Shine.Parent = Background

local ShineGradient = Instance.new("UIGradient")
ShineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 1)
})
ShineGradient.Parent = Shine

-- 6. ชื่อตรงกลาง
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 0, 50)
Title.Position = UDim2.new(0.5, -200, 0.5, -30)
Title.BackgroundTransparency = 1
Title.Text = "T&D Phoenix A"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 40
Title.TextTransparency = 1 
Title.Parent = Background

-- 7. แถบโหลด
local BarBack = Instance.new("Frame")
BarBack.Size = UDim2.new(0, 300, 0, 4)
BarBack.Position = UDim2.new(0.5, -150, 0.5, 30)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBack.BackgroundTransparency = 1
BarBack.Parent = Background

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBack

-- [[ LOGIC การทำงาน ]] --

local function playShine()
    Shine.Position = UDim2.new(-0.5, 0, -0.5, 0)
    TweenService:Create(Shine, TweenInfo.new(1.8, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
        Position = UDim2.new(1.5, 0, 1.5, 0)
    }):Play()
end

task.spawn(function()
    -- เริ่มเพลงทันที (ไม่มี Fade Out ตอนจบแล้ว)
    Music:Play()

    local fastInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    playShine()
    
    TweenService:Create(Title, fastInfo, {TextTransparency = 0}):Play()
    TweenService:Create(BarBack, fastInfo, {BackgroundTransparency = 0}):Play()
    task.wait(1)
    
    playShine()
    
    local loadTween = TweenService:Create(BarFill, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    loadTween:Play()
    loadTween.Completed:Wait()
    
    task.wait(0.5)
    
    -- เฉพาะหน้าจอ UI ที่จางหายไป (เพลงยังเล่นต่อ!)
    local fadeInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(Title, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(BarBack, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Background, fadeInfo, {BackgroundTransparency = 1}):Play()
    
    task.wait(1.2)
    
    ScreenGui:Destroy()
    -- รันสคริปต์หลัก โดยที่เพลงยังคงดังคลออยู่เบาๆ
    loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/T%26D.lua"))()
end)
