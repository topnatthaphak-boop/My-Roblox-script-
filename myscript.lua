local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "tokopp Hub",
    LoadingTitle = "Loading tokopp...",
    LoadingSubtitle = "UI System",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Main")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- =========================
-- SAFE CHARACTER
local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function hum()
    local c = char()
    return c and c:FindFirstChild("Humanoid")
end

local function hrp()
    local c = char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- =========================
-- STATE (รวมทุกระบบ)
local state = {
    fly = false,
    god = false,
    noclip = false,
    invis = false,
    infiniteJump = false,
    esp = false,
    lock = false,
    clickTP = false,
    fakeImmortal = false
}

-- =========================
-- SPEED
Tab:CreateToggle({
    Name = "Speed Toggle",
    CurrentValue = false,
    Callback = function(v)
        local h = hum()
        if h then
            h.WalkSpeed = v and 100 or 16
        end
    end
})

-- =========================
-- GOD MODE
RunService.Heartbeat:Connect(function()
    if state.god then
        local h = hum()
        if h and h.Health < h.MaxHealth then
            h.Health = h.MaxHealth
        end
    end
end)

Tab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(v)
        state.god = v
    end
})

-- =========================
-- FLY
local flyConn, bv

Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        state.fly = v

        if flyConn then flyConn:Disconnect() end
        if bv then bv:Destroy() end

        if v then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            bv.Parent = hrp()

            flyConn = RunService.RenderStepped:Connect(function()
                if state.fly and bv then
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                end
            end)
        end
    end
})

-- =========================
-- NOCLIP
RunService.Stepped:Connect(function()
    if state.noclip then
        local c = char()
        for _,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(v)
        state.noclip = v
    end
})

-- =========================
-- CLICK TP
local targetPlayer

Tab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Callback = function(v)
        for _,p in ipairs(Players:GetPlayers()) do
            if p.Name == v then
                targetPlayer = p
            end
        end
    end
})

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not state.clickTP then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if targetPlayer and targetPlayer.Character then
            local t = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local me = hrp()

            if t and me then
                me.CFrame = t.CFrame * CFrame.new(2,0,2)
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Click TP",
    CurrentValue = false,
    Callback = function(v)
        state.clickTP = v
    end
})

-- =========================
-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
    if state.infiniteJump then
        local h = hum()
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        state.infiniteJump = v
    end
})

-- =========================
-- INVISIBILITY
local invisConn

local function setInvisible(v)
    local c = char()
    for _,x in pairs(c:GetDescendants()) do
        if x:IsA("BasePart") then
            x.LocalTransparencyModifier = v and 1 or 0
        elseif x:IsA("Decal") then
            x.Transparency = v and 1 or 0
        end
    end
end

Tab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Callback = function(v)
        state.invis = v

        if invisConn then invisConn:Disconnect() end

        if v then
            invisConn = RunService.Heartbeat:Connect(function()
                setInvisible(true)
            end)
        else
            setInvisible(false)
        end
    end
})

-- =========================
-- ESP
local espConnections = {}

local function makeESP(plr)
    if plr == player then return end

    local function setup(c)
        task.wait(0.2)
        if not state.esp then return end

        local old = c:FindFirstChild("ESP")
        if old then old:Destroy() end

        local h = Instance.new("Highlight")
        h.Name = "ESP"
        h.FillColor = Color3.fromRGB(0,255,0)
        h.OutlineColor = Color3.fromRGB(0,255,0)
        h.Parent = c
    end

    if plr.Character then setup(plr.Character) end

    espConnections[plr] = plr.CharacterAdded:Connect(setup)
end

Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v)
        state.esp = v

        if v then
            for _,p in ipairs(Players:GetPlayers()) do
                makeESP(p)
            end
        else
            for _,p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ESP") then
                    p.Character.ESP:Destroy()
                end
            end
        end
    end
})

-- =========================
-- LOCK POSITION
local lockCF
local lockConn

Tab:CreateToggle({
    Name = "Lock Position",
    CurrentValue = false,
    Callback = function(v)
        state.lock = v

        if lockConn then lockConn:Disconnect() end

        if v then
            lockCF = hrp().CFrame

            lockConn = RunService.Heartbeat:Connect(function()
                local r = hrp()
                if r then
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.CFrame = lockCF
                end
            end)
        end
    end
})

-- =========================
-- 🔥 FAKE IMMORTAL (HP 1 LOCK)
local fakeConn

local function setupFakeImmortal()
    local h = hum()
    if not h then return end

    h.BreakJointsOnDeath = false

    if fakeConn then fakeConn:Disconnect() end

    fakeConn = h.HealthChanged:Connect(function()
        if state.fakeImmortal and h.Health <= 1 then
            h.Health = 1
        end
    end)
end

Tab:CreateToggle({
    Name = "Fake Immortal (HP 1 LOCK)",
    CurrentValue = false,
    Callback = function(v)
        state.fakeImmortal = v

        if v then
            setupFakeImmortal()
        else
            if fakeConn then
                fakeConn:Disconnect()
                fakeConn = nil
            end
        end
    end
})

player.CharacterAdded:Connect(function()
    task.wait(1)
    if state.fakeImmortal then
        setupFakeImmortal()
    end
end)
