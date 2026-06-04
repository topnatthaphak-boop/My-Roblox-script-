local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- 1. สร้างหน้ากากหลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Phoenix_Intro_System"
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)

-- 2. พื้นหลัง
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- 3. เส้นขอบเรืองแสง
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

task.spawn(function()
    while true do
        Gradient.Rotation = Gradient.Rotation + 1
        RunService.RenderStepped:Wait()
    end
end)

-- 4. ระบบเพลง (Sound System)
local BackgroundMusic = Instance.new("Sound")
BackgroundMusic.Name = "T&D_BGM"
BackgroundMusic.SoundId = "rbxassetid://88927553987952"
BackgroundMusic.Looped = true
BackgroundMusic.Volume = 0.5
BackgroundMusic.Parent = Background
BackgroundMusic:Play()

-- 5. ปุ่มควบคุมเพลง + ปุ่มใหม่ W (เรียงลำดับ: P | L | W)
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0, 150, 0, 40) -- ขยายขนาดเพิ่มเพราะมีปุ่ม W
ControlFrame.Position = UDim2.new(1, -160, 0, 10) -- ขยับตำแหน่งให้อยู่ตรงมุมพอดี
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = ScreenGui

local function CreateMusicButton(name, text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = ControlFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = color
    stroke.Parent = btn
    
    return btn
end

-- ปุ่มเดิมคงเดิมเป๊ะ
local StopBtn = CreateMusicButton("StopBtn", "P", UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 85, 85))
local PlayBtn = CreateMusicButton("PlayBtn", "L", UDim2.new(0, 50, 0, 0), Color3.fromRGB(85, 255, 85))
-- ✅ ปุ่มใหม่ W (วางต่อจาก L เลย)
local WBtn = CreateMusicButton("WBtn", "W", UDim2.new(0, 100, 0, 0), Color3.fromRGB(255, 255, 85))

-- ฟังก์ชันปุ่มเดิม
StopBtn.MouseButton1Click:Connect(function()
    BackgroundMusic:Stop()
end)

PlayBtn.MouseButton1Click:Connect(function()
    if not BackgroundMusic.IsPlaying then
        BackgroundMusic:Play()
    end
end)

-- ✅ ฟังก์ชันปุ่ม W: กดแล้วรัน Project-wc32bd?.lua
WBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/Project-wc32bd%3F.lua"))()
end)

-- 6. ชื่อและแถบโหลด
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

local BarBack = Instance.new("Frame")
BarBack.Size = UDim2.new(0, 300, 0, 4)
BarBack.Position = UDim2.new(0.5, -150, 0.5, 30)
BarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BarBack.BackgroundTransparency = 1
BarBack.Parent = Background

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBack

-- 7. Logic การทำงาน (เหมือนเดิมเป๊ะ เพียงเพิ่มปุ่ม W เข้ามาในระบบ)
task.spawn(function()
    local fastInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(Title, fastInfo, {TextTransparency = 0}):Play()
    TweenService:Create(BarBack, fastInfo, {BackgroundTransparency = 0}):Play()
    
    task.wait(1)
    
    local loadTween = TweenService:Create(BarFill, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    loadTween:Play()
    loadTween.Completed:Wait()
    
    task.wait(0.5)
    
    local fadeInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(Title, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(BarBack, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Background, fadeInfo, {BackgroundTransparency = 1}):Play()
    
    task.wait(1.5)
    
    -- ย้าย Sound และ ปุ่มทั้งหมด (P, L, W) ไปที่ ScreenGui ก่อนลบพื้นหลัง
    BackgroundMusic.Parent = ScreenGui
    ControlFrame.Parent = ScreenGui
    Background:Destroy()
    
    -- รันสคริปต์หลัก NewBeta.lua เหมือนเดิม
    loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/NewBeta.lua"))()
end)
