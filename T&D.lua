local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "T&D Phoenix A",
    LoadingTitle = "Loading Phoenix A...",
    LoadingSubtitle = "The Ultimate Black Hole System",
    ConfigurationSaving = {Enabled = false}
})

-- สร้างแท็บทั้งหมด
local Tab = Window:CreateTab("Main")
local OthersTab = Window:CreateTab("Others (อื่นๆ)")
local DevTab = Window:CreateTab("Dev Tools (พัฒนา)")
local UpdateTab = Window:CreateTab("Updates (อัปเดต)")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function char() return player.Character or player.CharacterAdded:Wait() end
local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end
local state = { fly = false, god = false, noclip = false, esp = false, infiniteJump = false }

-- [ MAIN TAB ] (โค้ดเดิมของคุณ)
Tab:CreateToggle({
    Name = "Speed Toggle (วิ่งเร็ว)",
    CurrentValue = false,
    Callback = function(v)
        local h = hum()
        if h then h.WalkSpeed = v and 100 or 16 end
    end
})

Tab:CreateToggle({
    Name = "NoClip (ทะลุกำแพง)",
    CurrentValue = false,
    Callback = function(v) state.noclip = v end
})

RunService.Stepped:Connect(function()
    if state.noclip then
        local c = char()
        for _,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ... (ESP, God Mode, Infinite Jump โค้ดส่วนที่เหลือของคุณ) ...
-- [ข้ามมาที่ส่วน Others เพื่อเพิ่มปุ่มใหม่]

-- [ OTHERS TAB ] - คลังแสงของ Phoenix A
OthersTab:CreateButton({
    Name = "Fly (บิน) - Legend Script",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f4253b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator"))()
    end,
})

-- [[ เพิ่มปุ่มใหม่ของทีม T&D ตรงนี้ ]]
OthersTab:CreateButton({
    Name = "Fly.T&D",
    Callback = function()
        -- เริ่มรันโค้ดระบบ Fly/Movement ที่เราสร้างร่วมกัน
        local rootPart = char():WaitForChild("HumanoidRootPart")
        local hmd = hum()
        
        local isLocked = false
        local isNoclipping = false
        local isSpd = false
        local moveDistance = 5
        local floatForce = nil
        local noclipConn = nil

        local screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.Name = "TD_Movement_Final"

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 160, 0, 120)
        mainFrame.Position = UDim2.new(0, 50, 0.5, -60)
        mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.CellSize = UDim2.new(0, 50, 0, 35)
        gridLayout.CellPadding = UDim2.new(0, 2, 0, 2)
        gridLayout.Parent = mainFrame

        local function createBox(text, order, color)
            local box = Instance.new("TextButton")
            box.Text = text
            box.LayoutOrder = order
            box.BackgroundColor3 = color
            box.TextColor3 = Color3.new(1, 1, 1)
            box.Font = Enum.Font.GothamBold
            box.TextSize = 10
            box.BorderSizePixel = 0
            box.Parent = mainFrame
            return box
        end

        local upBtn = createBox("UP", 1, Color3.fromRGB(140, 80, 250))
        local titleLabel = createBox("gui by T&D", 2, Color3.fromRGB(100, 50, 200))
        local downBtn = createBox("DOWN", 3, Color3.fromRGB(140, 80, 250))
        local lockBtn = createBox("L (OFF)", 4, Color3.fromRGB(60, 20, 120))
        local noclipBtn = createBox("Clip(OFF)", 5, Color3.fromRGB(40, 40, 40))
        local speedBtn = createBox("SPD(OFF)", 6, Color3.fromRGB(40, 40, 40))

        lockBtn.MouseButton1Click:Connect(function()
            isLocked = not isLocked
            if isLocked then
                if not floatForce then
                    floatForce = Instance.new("BodyVelocity")
                    floatForce.MaxForce = Vector3.new(0, math.huge, 0)
                    floatForce.Velocity = Vector3.new(0, 0, 0)
                    floatForce.Parent = rootPart
                end
                lockBtn.Text = "L (ON)"
                lockBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
            else
                if floatForce then floatForce:Destroy() floatForce = nil end
                lockBtn.Text = "L (OFF)"
                lockBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 120)
            end
        end)

        noclipBtn.MouseButton1Click:Connect(function()
            isNoclipping = not isNoclipping
            if isNoclipping then
                noclipConn = RunService.Stepped:Connect(function()
                    for _, v in pairs(char():GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end)
                noclipBtn.Text = "Noclipping"
                noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            else
                if noclipConn then noclipConn:Disconnect() noclipConn = nil end
                noclipBtn.Text = "Clip(OFF)"
                noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end)

        speedBtn.MouseButton1Click:Connect(function()
            isSpd = not isSpd
            if hmd then hmd.WalkSpeed = isSpd and 100 or 16 end
            speedBtn.Text = isSpd and "SPD (100)" or "SPD (OFF)"
            speedBtn.BackgroundColor3 = isSpd and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(40, 40, 40)
        end)

        upBtn.MouseButton1Click:Connect(function() if isLocked then rootPart.CFrame = rootPart.CFrame * CFrame.new(0, moveDistance, 0) end end)
        downBtn.MouseButton1Click:Connect(function() if isLocked then rootPart.CFrame = rootPart.CFrame * CFrame.new(0, -moveDistance, 0) end end)
        
        Rayfield:Notify({Title = "T&D System", Content = "Fly.T&D Activated!", Duration = 3})
    end,
})

-- ... (ปุ่มอื่นๆ F3X, IY, Hexagon โค้ดเดิมของคุณ) ...
