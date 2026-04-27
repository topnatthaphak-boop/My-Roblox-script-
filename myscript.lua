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
    return char():WaitForChild("Humanoid")
end

local function hrp()
    return char():WaitForChild("HumanoidRootPart")
end

-- =========================
-- STATE (กันชนกัน)
local state = {
    fly = false,
    god = false,
    noclip = false,
    invis = false,
    lock = false,
    tp = false,
    infiniteJump = false,
}

-- =========================
-- SPEED
Tab:CreateToggle({
    Name = "Speed Toggle",
    CurrentValue = false,
    Callback = function(v)
        hum().WalkSpeed = v and 100 or 16
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
-- FLY (FIXED NO CONFLICT)
local flyConn
local bv

Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        state.fly = v

        if flyConn then flyConn:Disconnect() flyConn = nil end
        if bv then bv:Destroy() bv = nil end

        if v then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            bv.Parent = hrp()

            flyConn = RunService.RenderStepped:Connect(function()
                if not state.fly then return end
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
            end)
        end
    end
})

-- =========================
-- NOCLIP (ไม่ชน Fly)
RunService.Stepped:Connect(function()
    if state.noclip then
        for _,v in pairs(char():GetDescendants()) do
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
        if not v then
            for _,v in pairs(char():GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

-- =========================
-- CLICK TP (กัน spam + reset list)
local targetPlayer

Tab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Callback = function(v)
        targetPlayer = Players:FindFirstChild(v)
    end
})

local function refreshDropdown(dropdown)
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(list, p.Name)
        end
    end
    dropdown:Refresh(list)
end

-- =========================
-- CLICK TP LOGIC
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not state.tp then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not targetPlayer or not targetPlayer.Character then return end

        local my = hrp()
        local t = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

        if my and t then
            my.CFrame = t.CFrame * CFrame.new(2,0,2)
        end
    end
end)

Tab:CreateToggle({
    Name = "Click TP",
    CurrentValue = false,
    Callback = function(v)
        state.tp = v
    end
})

-- =========================
-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
    if state.infiniteJump then
        hum():ChangeState(Enum.HumanoidStateType.Jumping)
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
-- INVISIBILITY (FIXED + SAFE)
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

        if invisConn then invisConn:Disconnect() invisConn = nil end

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
-- HIGHLIGHT (NO LEAK)
local function highlightPlayer(plr)
    if plr == player then return end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)

        local old = char:FindFirstChild("GreenHighlight")
        if old then old:Destroy() end

        local h = Instance.new("Highlight")
        h.Name = "GreenHighlight"
        h.FillColor = Color3.fromRGB(0,255,0)
        h.OutlineColor = Color3.fromRGB(0,255,0)
        h.FillTransparency = 0.3
        h.Parent = char
    end)
end

for _,p in ipairs(Players:GetPlayers()) do
    highlightPlayer(p)
end

Players.PlayerAdded:Connect(highlightPlayer)

-- =========================
-- LOCK POSITION (NO CONFLICT WITH FLY)
local lockPos
local lockCF
local lockConn

Tab:CreateToggle({
    Name = "Lock Position",
    CurrentValue = false,
    Callback = function(v)
        lockPos = v

        if lockConn then lockConn:Disconnect() lockConn = nil end

        if v then
            lockCF = hrp().CFrame

            lockConn = RunService.Heartbeat:Connect(function()
                if not lockPos then return end
                local r = hrp()
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                r.CFrame = lockCF
            end)
        end
    end
})

player.CharacterAdded:Connect(function()
    task.wait(1)
    if lockPos then
        lockCF = hrp().CFrame
    end
end)
