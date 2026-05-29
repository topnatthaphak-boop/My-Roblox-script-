-- // T&D QUEST UI - กดครบ 1,000 ครั้ง (แต่แสดง 10 ล้าน!) รับสคริปต์! // --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- ลบ UI เก่าออกก่อน
if PlayerGui:FindFirstChild("TD_QUEST_UI") then
    PlayerGui:FindFirstChild("TD_QUEST_UI"):Destroy()
end

-- ✅ ระบบนับจำนวนครั้งกด (ตัวเลขจริงคือ 1,000 แต่แสดงเป็น 10 ล้าน!)
local ClickCount = 0
-- ✅ ค่าความจริง VS ค่าที่โชว์
local REAL_TARGET = 1000    -- ของจริงต้องแค่ 1,000 ครั้ง
local FAKE_TARGET = 10000000 -- แต่โชว์บนจอว่า 10,000,000 ครั้ง! 😈

-- ข้อความปกติ 1 - 999 ครั้ง และ 1,001+ ครั้ง
local TextNormal = "zโพเเดง | Failed project "
-- ข้อความครบ 1,000 ครั้ง (สคริปต์เต็ม)
local TextScript = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/Beta-NewUI-T%26D.lua"))()'

-- สร้าง GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TD_QUEST_UI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- กล่องหลัก (ตรงกลาง + ขนาดเดิม)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(55, 25, 95)
MainFrame.BorderColor3 = Color3.fromRGB(170, 100, 255)
MainFrame.BorderSizePixel = 3
MainFrame.Size = UDim2.new(0, 520, 0, 400)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
MainFrame.Active = true -- ลากขยับได้แบบเดิม

-- ✅ ระบบลาก/ขยับ (ครบถ้วนเหมือนเดิม)
local DragToggle, DragInput, DragStart, StartPos
local function UpdateDrag(Input)
    Delta = Input.Position - DragStart
    MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end

MainFrame.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DragToggle = true
        DragStart = Input.Position
        StartPos = MainFrame.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                DragToggle = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        DragInput = Input
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if DragToggle and DragInput then
        UpdateDrag(DragInput)
    end
end)

-- แถบหัวบน
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(90, 40, 160)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.Position = UDim2.new(0, 0, 0, 0)

-- โลโก้ T&D ซ้ายบน
local LogoTD = Instance.new("TextLabel")
LogoTD.Name = "LogoTD"
LogoTD.Parent = TopBar
LogoTD.BackgroundTransparency = 1
LogoTD.Position = UDim2.new(0.05, 0, 0, 0)
LogoTD.Size = UDim2.new(0, 60, 1, 0)
LogoTD.Font = Enum.Font.GothamBold
LogoTD.Text = "T&D"
LogoTD.TextColor3 = Color3.new(1,1,1)
LogoTD.TextSize = 22

-- หัวข้อตรงกลาง
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.25, 0, 0, 0)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "T&D QUEST"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22

-- ปุ่มปิด
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Position = UDim2.new(0.90, 0, 0.1, 0)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- พื้นหลังเนื้อหา
local ContentBG = Instance.new("Frame")
ContentBG.Name = "ContentBG"
ContentBG.Parent = MainFrame
ContentBG.BackgroundColor3 = Color3.fromRGB(40, 20, 70)
ContentBG.BorderSizePixel = 0
ContentBG.Size = UDim2.new(0.92, 0, 0.62, 0)
ContentBG.Position = UDim2.new(0.04, 0, 0.15, 0)

-- กล่องรางวัลซ้าย
local RewardBox = Instance.new("Frame")
RewardBox.Name = "RewardBox"
RewardBox.Parent = ContentBG
RewardBox.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
RewardBox.BorderColor3 = Color3.fromRGB(200, 160, 255)
RewardBox.BorderSizePixel = 2
RewardBox.Size = UDim2.new(0, 110, 0, 100)
RewardBox.Position = UDim2.new(0.20, 0, 0.08, 0)

local RewardText = Instance.new("TextLabel")
RewardText.Name = "RewardText"
RewardText.Parent = RewardBox
RewardText.BackgroundTransparency = 1
RewardText.Size = UDim2.new(1,0,1,0)
RewardText.Font = Enum.Font.GothamBold
RewardText.Text = "T&D\nscript"
RewardText.TextColor3 = Color3.new(1,1,1)
RewardText.TextSize = 18
RewardText.TextWrapped = true

-- คำว่า Reward ใต้กล่อง
local RewardLabel = Instance.new("TextLabel")
RewardLabel.Name = "RewardLabel"
RewardLabel.Parent = ContentBG
RewardLabel.BackgroundTransparency = 1
RewardLabel.Position = UDim2.new(0.20, 0, 0.40, 0)
RewardLabel.Size = UDim2.new(0, 120, 0, 18)
RewardLabel.Font = Enum.Font.Gotham
RewardLabel.Text = "Reward"
RewardLabel.TextColor3 = Color3.new(1,1,1)
RewardLabel.TextSize = 14

-- กล่องขวา: T&D script
local RewardBox2 = Instance.new("Frame")
RewardBox2.Name = "RewardBox2"
RewardBox2.Parent = ContentBG
RewardBox2.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
RewardBox2.BorderColor3 = Color3.fromRGB(100, 50, 180)
RewardBox2.BorderSizePixel = 2
RewardBox2.Size = UDim2.new(0, 180, 0, 38)
RewardBox2.Position = UDim2.new(0.48, 0, 0.18, 0)

local RewardText2 = Instance.new("TextLabel")
RewardText2.Name = "RewardText2"
RewardText2.Parent = RewardBox2
RewardText2.BackgroundTransparency = 1
RewardText2.Size = UDim2.new(1,0,1,0)
RewardText2.Font = Enum.Font.GothamBold
RewardText2.Text = "T&D script"
RewardText2.TextColor3 = Color3.new(1,1,1)
RewardText2.TextSize = 16

-- ✅ คำอธิบายภาษาไทย+อังกฤษ ครบถ้วนเหมือนเดิมเป๊ะ
local DescText = Instance.new("TextLabel")
DescText.Name = "DescText"
DescText.Parent = ContentBG
DescText.BackgroundTransparency = 1
DescText.Size = UDim2.new(0.95,0,0.48,0)
DescText.Position = UDim2.new(0.025,0,0.52,0)
DescText.Font = Enum.Font.Gotham
DescText.TextColor3 = Color3.new(0.9,0.9,0.9)
DescText.TextSize = 13
DescText.TextWrapped = true
DescText.TextXAlignment = Enum.TextXAlignment.Left
DescText.Text = [[1. Join my Discord by messaging me in the video comments, I will send you the Discord link, once you join I will send you the script.
2. Paste the copied text on TikTok, follow or comment on the latest video.

🇹🇭 วิธีปลดล็อค:
1. เข้าดิสคอร์ดผมโดยทักแชท/คอมเม้นในคลิป ตอนผมแจกลิงก์แล้วเข้ามา ผมจะส่งสคริปต์ให้
2. นำข้อความที่คัดลอกไปพิมพ์/คอมเม้น และกดติดตามคลิปล่าสุด
3. เสร็จสิ้น รับสิทธิ์ใช้งานได้ทันที]]

-- ปุ่ม รับ
local ClaimBtn = Instance.new("TextButton")
ClaimBtn.Name = "ClaimBtn"
ClaimBtn.Parent = MainFrame
ClaimBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
ClaimBtn.BorderColor3 = Color3.fromRGB(20, 120, 50)
ClaimBtn.BorderSizePixel = 2
ClaimBtn.Size = UDim2.new(0.85, 0, 0, 42)
ClaimBtn.Position = UDim2.new(0.075, 0, 0.83, 0)
ClaimBtn.Font = Enum.Font.GothamBold
ClaimBtn.Text = "รับ"
ClaimBtn.TextColor3 = Color3.new(1,1,1)
ClaimBtn.TextSize = 20

-- แจ้งเตือน
local Notify = Instance.new("TextLabel")
Notify.Name = "Notify"
Notify.Parent = MainFrame
Notify.BackgroundColor3 = Color3.fromRGB(20,20,20)
Notify.BackgroundTransparency = 0.4
Notify.Size = UDim2.new(0.7,0,0,28)
Notify.Position = UDim2.new(0.15,0,0.75,0)
Notify.Font = Enum.Font.Gotham
Notify.TextColor3 = Color3.new(1,1,1)
Notify.TextSize = 13
Notify.Visible = false

-- ✅ ฟังก์ชันกดปุ่ม: เกรียนโคตรๆ ตามสั่ง!
ClaimBtn.MouseButton1Click:Connect(function()
    ClickCount += 1 -- นับเพิ่มทุกครั้ง

    local CopyThis, Message

    -- ✅ เงื่อนไขหลัก
    if ClickCount < REAL_TARGET then
        -- ช่วง 1 - 999 ครั้ง: แสดงเป้าหมาย 10 ล้าน!
        CopyThis = TextNormal
        Message = "✅ คัดลอกแล้ว ("..ClickCount.." / "..FAKE_TARGET.."): "..TextNormal

    elseif ClickCount == REAL_TARGET then
        -- ครั้งที่ 1,000 พอดี: ได้สคริปต์! โชว์ข้อความเท่ๆ
        CopyThis = TextScript
        Message = "🔥 โว้ย! กดครบแล้วนี่หว่า ("..ClickCount.." / "..FAKE_TARGET..") | ได้สคริปต์แล้ว!"

    else
        -- ✅ ครั้งที่ 1,001 ขึ้นไป: ย้อนกลับไปเป็นชื่อช่องเหมือนเดิม! เหมือนทำพลาด 🤣
        CopyThis = TextNormal
        Message = "❌ กดเกินแล้วว่ะ! กดใหม่สิ ("..ClickCount.." / "..FAKE_TARGET.."): "..TextNormal
    end

    -- คัดลอกข้อความ
    setclipboard(CopyThis)

    -- แสดงแจ้งเตือน
    Notify.Text = Message
    Notify.Visible = true
    task.delay(3, function() Notify.Visible = false end)
end)

print("✅ T&D QUEST UI | โหมดเกรียน: แสดง 10 ล้าน / ของจริง 1,000 / กดเกิน = เริ่มใหม่! 😈🤣")
