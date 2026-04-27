local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("tokopp", "DarkTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =========================
-- SAFE GETTERS
local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function hum()
    return char():WaitForChild("Humanoid")
end

local function hrp()
    return char():WaitForChild("HumanoidRootPart")
end

-- =========================
-- SPEED
Section:NewButton("Speed 100", "", function()
    hum().WalkSpeed = 100
end)

Section:NewToggle("Speed Toggle", "", function(v)
    hum().WalkSpeed = v and 100 or 16
end)

Section:NewTextBox("Set Speed", "", function(t)
    hum().WalkSpeed = tonumber(t) or 16
end)

Section:NewKeybind("Toggle UI", "", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)

-- =========================
-- FLY
local flying = false
local flySpeed = 60
local bv, bg
local flyConn

local keys = {W=false,A=false,S=false,D=false,Space=false,Shift=false}

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if keys[i.KeyCode.Name] ~= nil then
        keys[i.KeyCode.Name] = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if keys[i.KeyCode.Name] ~= nil then
        keys[i.KeyCode.Name] = false
    end
end)

local function startFly()
    if flying then return end
    flying = true

    local root = hrp()

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.Parent = root

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if keys.W then dir += cam.CFrame.LookVector end
        if keys.S then dir -= cam.CFrame.LookVector end
        if keys.A then dir -= cam.CFrame.RightVector end
        if keys.D then dir += cam.CFrame.RightVector end
        if keys.Space then dir += cam.CFrame.UpVector end
        if keys.Shift then dir -= cam.CFrame.UpVector end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if flyConn then flyConn:Disconnect() end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

Section:NewToggle("Fly", "", function(v)
    if v then startFly() else stopFly() end
end)

Section:NewTextBox("Fly Speed", "", function(t)
    flySpeed = tonumber(t) or 60
end)

-- =========================
-- NOCLIP
local noclipConn

Section:NewToggle("NoClip", "", function(v)
    if v then
        noclipConn = RunService.Stepped:Connect(function()
            for _,v in ipairs(char():GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        for _,v in ipairs(char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

-- =========================
-- MULTI JUMP
local maxJumps = 5
local jumpCount = 0
local jumpEnabled = false
local jumpPower = 80

UIS.JumpRequest:Connect(function()
    if not jumpEnabled then return end
    if jumpCount >= maxJumps then return end

    jumpCount += 1
    hum():ChangeState(Enum.HumanoidStateType.Jumping)

    local r = hrp()
    r.Velocity = Vector3.new(r.Velocity.X, jumpPower, r.Velocity.Z)
end)

hum().StateChanged:Connect(function(_,new)
    if new == Enum.HumanoidStateType.Landed then
        jumpCount = 0
    end
end)

Section:NewToggle("Multi Jump", "", function(v)
    jumpEnabled = v
end)

Section:NewTextBox("Jump Power", "", function(t)
    jumpPower = tonumber(t) or 80
end)

Section:NewTextBox("Max Jump", "", function(t)
    maxJumps = tonumber(t) or 5
end)

-- =========================
-- 🎥 SOUL FREECAM + FOLLOW
local cam = workspace.CurrentCamera
local soul = false
local follow = false
local followTarget = nil
local camSpeed = 2
local camConn

Section:NewToggle("Soul Freecam", "", function(v)
    soul = v

    if v then
        hrp().Anchored = true
        cam.CameraType = Enum.CameraType.Scriptable

        camConn = RunService.RenderStepped:Connect(function()
            if follow and followTarget and followTarget.Character then
                local r = followTarget.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    cam.CFrame = CFrame.new(r.Position + Vector3.new(0,5,10), r.Position)
                    return
                end
            end

            local move = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

            if move.Magnitude > 0 then
                cam.CFrame += move.Unit * camSpeed
            end
        end)
    else
        if camConn then camConn:Disconnect() end
        cam.CameraType = Enum.CameraType.Custom
        hrp().Anchored = false
    end
end)

Section:NewTextBox("Cam Speed", "", function(t)
    camSpeed = tonumber(t) or 2
end)

Section:NewDropdown("Follow Player", "", (function()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then table.insert(t,p.Name) end
    end
    return t
end)(), function(name)
    followTarget = Players:FindFirstChild(name)
end)

Section:NewToggle("Follow Mode", "", function(v)
    follow = v
end)

-- =========================
-- 🧲 CLICK TP (ADDED)

local clickTP = false
local targetTP = nil

Section:NewDropdown("TP Target", "", (function()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then table.insert(t,p.Name) end
    end
    return t
end)(), function(name)
    targetTP = Players:FindFirstChild(name)
end)

Section:NewToggle("Click TP Mode", "", function(v)
    clickTP = v
end)

mouse.Button1Down:Connect(function()
    if not clickTP then return end
    if not targetTP then return end
    if not targetTP.Character then return end

    local my = char()
    local t = targetTP.Character

    local myR = my:FindFirstChild("HumanoidRootPart")
    local tR = t:FindFirstChild("HumanoidRootPart")

    if myR and tR then
        myR.CFrame = tR.CFrame + Vector3.new(2,0,2)
    end
end)
