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

local player = Players.LocalPlayer
local mouse = player:GetMouse()

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
-- SPEED
Tab:CreateButton({
    Name = "Speed 100",
    Callback = function()
        hum().WalkSpeed = 100
    end
})

Tab:CreateToggle({
    Name = "Speed Toggle",
    CurrentValue = false,
    Callback = function(v)
        hum().WalkSpeed = v and 100 or 16
    end
})

-- =========================
-- GOD MODE (stable)
local god = false

Tab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(v)
        god = v

        RunService.Heartbeat:Connect(function()
            if god then
                local h = hum()
                if h and h.Health < h.MaxHealth then
                    h.Health = h.MaxHealth
                end
            end
        end)
    end
})

-- =========================
-- FLY (stable)
local flying = false
local bv

Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        flying = v

        local root = hrp()

        if v then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            bv.Parent = root

            RunService.RenderStepped:Connect(function()
                if flying and bv then
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                end
            end)
        else
            if bv then
                bv:Destroy()
                bv = nil
            end
        end
    end
})

-- =========================
-- NOCLIP (stable)
local noclip = false
local noclipConn

Tab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(v)
        noclip = v

        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end

        if v then
            noclipConn = RunService.Stepped:Connect(function()
                for _,p in pairs(char():GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end)
        else
            for _,p in pairs(char():GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = true
                end
            end
        end
    end
})

-- =========================
-- 🧲 CLICK TP TO PLAYER (MERGED VERSION)
local targetPlayer = nil
local clickTP = false

-- Dropdown เลือกผู้เล่น
Tab:CreateDropdown({
    Name = "Select Player",
    Options = (function()
        local t = {}
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= player then
                table.insert(t, p.Name)
            end
        end
        return t
    end)(),
    Callback = function(v)
        targetPlayer = Players:FindFirstChild(v)
    end
})

-- Toggle เปิดระบบ
Tab:CreateToggle({
    Name = "Click TP to Player",
    CurrentValue = false,
    Callback = function(v)
        clickTP = v
    end
})

-- คลิกแล้ววาร์ปไปผู้เล่น
mouse.Button1Down:Connect(function()
    if not clickTP then return end
    if not targetPlayer then return end
    if not targetPlayer.Character then return end

    local myHRP = hrp()
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

    if myHRP and targetHRP then
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2,0,2)
    end
end)
