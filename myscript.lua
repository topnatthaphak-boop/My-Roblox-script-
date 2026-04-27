local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("tokopp", "DarkTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- =========================
-- SAFE GETTERS

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getChar():WaitForChild("Humanoid")
end

local function getHRP()
    return getChar():WaitForChild("HumanoidRootPart")
end

-- =========================
-- SPEED

Section:NewButton("Speed 100", "", function()
    getHumanoid().WalkSpeed = 100
end)

Section:NewToggle("Speed Toggle", "", function(state)
    getHumanoid().WalkSpeed = state and 100 or 20
end)

Section:NewTextBox("Set Speed", "", function(txt)
    getHumanoid().WalkSpeed = tonumber(txt) or 20
end)

Section:NewKeybind("Toggle UI", "", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)

-- =========================
-- FLY

local flying = false
local flySpeed = 60
local flyConn
local bv, bg

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

    local hrp = getHRP()

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.Parent = hrp

    flying = true

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

local function setNoClip(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _,v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        local char = player.Character
        if char then
            for _,v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

Section:NewToggle("NoClip", "", setNoClip)

-- =========================
-- MULTI JUMP

local maxJumps = 5
local jumpCount = 0
local boostPower = 80
local jumpEnabled = false

UIS.JumpRequest:Connect(function()
    if not jumpEnabled then return end

    local humanoid = getHumanoid()
    local hrp = getHRP()

    if jumpCount < maxJumps then
        jumpCount += 1
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        hrp.Velocity = Vector3.new(hrp.Velocity.X, boostPower, hrp.Velocity.Z)
    end
end)

Section:NewToggle("Multi Jump", "", function(v)
    jumpEnabled = v
end)

Section:NewTextBox("Jump Power", "", function(t)
    boostPower = tonumber(t) or 80
end)

Section:NewTextBox("Max Jumps", "", function(t)
    maxJumps = tonumber(t) or 5
end)

-- =========================
-- SOUL FREECAM + FOLLOW MODE

local cam = workspace.CurrentCamera
local soul = false
local camSpeed = 2
local followTarget = nil
local camConn

local function startSoul()
    if soul then return end
    soul = true

    getHRP().Anchored = true
    cam.CameraType = Enum.CameraType.Scriptable

    camConn = RunService.RenderStepped:Connect(function()
        if not soul then return end

        local cf = cam.CFrame

        -- 🎯 FOLLOW MODE
        if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = followTarget.Character.HumanoidRootPart
            cam.CFrame = hrp.CFrame * CFrame.new(0,5,12)
            return
        end

        -- 🎥 FREECAM
        local dir = Vector3.zero

        if keys.W then dir += cf.LookVector end
        if keys.S then dir -= cf.LookVector end
        if keys.A then dir -= cf.RightVector end
        if keys.D then dir += cf.RightVector end
        if keys.Space then dir += cf.UpVector end
        if keys.Shift then dir -= cf.UpVector end

        if dir.Magnitude > 0 then
            cam.CFrame = cf + dir.Unit * camSpeed
        end
    end)
end

local function stopSoul()
    soul = false
    followTarget = nil

    if camConn then camConn:Disconnect() end
    cam.CameraType = Enum.CameraType.Custom
    getHRP().Anchored = false
end

Section:NewToggle("Soul Freecam", "", function(v)
    if v then startSoul() else stopSoul() end
end)

Section:NewTextBox("Cam Speed", "", function(t)
    camSpeed = tonumber(t) or 2
end)

Section:NewTextBox("Follow Player", "", function(t)
    local p = Players:FindFirstChild(t)
    followTarget = p
end)
