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

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = false
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
        local moveDir = Vector3.zero

        if keys.W then moveDir += cam.CFrame.LookVector end
        if keys.S then moveDir -= cam.CFrame.LookVector end
        if keys.A then moveDir -= cam.CFrame.RightVector end
        if keys.D then moveDir += cam.CFrame.RightVector end
        if keys.Space then moveDir += cam.CFrame.UpVector end
        if keys.Shift then moveDir -= cam.CFrame.UpVector end

        bv.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if bv then bv:Destroy() bv=nil end
    if bg then bg:Destroy() bg=nil end
end

Section:NewToggle("Fly", "", function(state)
    if state then startFly() else stopFly() end
end)

Section:NewTextBox("Fly Speed", "", function(txt)
    flySpeed = tonumber(txt) or 60
end)

-- =========================
-- NOCLIP

local noclipConn

local function setNoClip(state)
    if state then
        if noclipConn then noclipConn:Disconnect() end

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
        if noclipConn then noclipConn:Disconnect() noclipConn=nil end

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

Section:NewToggle("NoClip", "", function(state)
    setNoClip(state)
end)

-- =========================
-- MULTI JUMP

local maxJumps = 5
local jumpCount = 0
local boostPower = 80
local jumpEnabled = false
local stateConn

local function setupChar(char)
    local humanoid = char:WaitForChild("Humanoid")
    jumpCount = 0

    if stateConn then stateConn:Disconnect() end

    stateConn = humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then
            jumpCount = 0
        end
    end)
end

player.CharacterAdded:Connect(setupChar)
if player.Character then setupChar(player.Character) end

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

Section:NewToggle("Multi Jump", "", function(state)
    jumpEnabled = state
end)

Section:NewTextBox("Jump Power", "", function(txt)
    boostPower = tonumber(txt) or 80
end)

Section:NewTextBox("Max Jumps", "", function(txt)
    maxJumps = tonumber(txt) or 5
end)

-- =========================
-- DAMAGE PROTECTION

local protectEnabled = false
local hpConn

local function applyProtection(char)
    local humanoid = char:WaitForChild("Humanoid")

    if hpConn then hpConn:Disconnect() hpConn=nil end

    hpConn = humanoid.HealthChanged:Connect(function()
        if protectEnabled then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

player.CharacterAdded:Connect(applyProtection)
if player.Character then applyProtection(player.Character) end

Section:NewToggle("Damage Protection", "", function(state)
    protectEnabled = state
end)

-- =========================
-- HIGHLIGHT PLAYERS

local highlightEnabled = false
local highlights = {}

local function createHighlight(plr)
    if plr == player then return end

    local function onChar(char)
        if not highlightEnabled then return end

        if highlights[plr] then
            highlights[plr]:Destroy()
        end

        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(0,255,0)
        hl.OutlineColor = Color3.fromRGB(0,100,0)
        hl.FillTransparency = 0.4
        hl.Parent = char

        highlights[plr] = hl
    end

    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(onChar)
end

for _,p in ipairs(Players:GetPlayers()) do
    createHighlight(p)
end

Players.PlayerAdded:Connect(createHighlight)

Section:NewToggle("Highlight Players", "", function(state)
    highlightEnabled = state

    if not state then
        for _,hl in pairs(highlights) do
            hl:Destroy()
        end
        highlights = {}
    else
        for _,p in ipairs(Players:GetPlayers()) do
            if p.Character then
                createHighlight(p)
            end
        end
    end
end)
