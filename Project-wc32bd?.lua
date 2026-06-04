-- ==================================================
-- 🌐 PROJECT WC32BD | What can 32bit do?
-- ✅ UI BASE: RAYFIELD (แก้ไขแสดงผล 100%)
-- ✅ หมวดหมู่ 1: fly    | ฟังก์ชัน: Fly FE
-- ✅ หมวดหมู่ 2: ck     | ฟังก์ชัน: Cookidd
-- ✅ หมวดหมู่ 3: 1x     | ฟังก์ชัน: 1x1x1x1 (เรียกใช้จาก GitHub โดยตรง)
-- ✅ หมวดหมู่ 4: mimic  | ฟังก์ชัน: Mimic (เลียนแบบ)
-- 🛠️ DEVELOPER: topnatthaphak-boop | MOD: T&D
-- ==================================================

-- โหลดไลบรารี Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก
local Window = Rayfield:CreateWindow({
    Name = "WC32BD | What can 32bit do?",
    LoadingTitle = "กำลังโหลดระบบ...",
    LoadingSubtitle = "สถาปัตยกรรม 32 บิต | รวมตำนาน",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

-- ==================================================
-- 📂 หมวดหมู่ที่ 1: fly
-- ==================================================
local FlyTab = Window:CreateTab("fly")

-- ✅ ฟังก์ชัน: Fly FE
FlyTab:CreateButton({
    Name = "Fly FE",
    Callback = function()
        -- 🔗 เรียกใช้สคริปต์ระบบบิน FE
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqvi1/universal-invincible-characters-fly-by-GioBolqv1/refs/heads/main/universal.txt"))()
    end
})

-- ==================================================
-- 📂 หมวดหมู่ที่ 2: ck
-- ==================================================
local CkTab = Window:CreateTab("ck")

-- ✅ ฟังก์ชัน: Cookidd
CkTab:CreateButton({
    Name = "Cookidd",
    Callback = function()
        -- 🔗 เรียกใช้สคริปต์ตำนาน Cookidd
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MiRw3b/c00lgui-v3rx/main/c00lguiv3rx.lua"))()
    end
})

-- ==================================================
-- 📂 หมวดหมู่ที่ 3: 1x
-- ==================================================
local OnexTab = Window:CreateTab("1x")

-- ✅ ฟังก์ชัน: 1x1x1x1 (เรียกใช้ผ่านลิงก์ GitHub ของคุณเอง)
OnexTab:CreateButton({
    Name = "1x1x1x1",
    Callback = function()
        -- 🔗 เรียกใช้สคริปต์ 1x1x1x1 จาก GitHub ที่คุณรวมไว้แล้ว
        loadstring(game:HttpGet("https://raw.githubusercontent.com/topnatthaphak-boop/My-Roblox-script-/refs/heads/main/1x1x1x1.lua"))()
    end
})

-- ==================================================
-- 📂 หมวดหมู่ที่ 4: mimic
-- ==================================================
local MimicTab = Window:CreateTab("mimic")

-- ✅ ฟังก์ชัน: Mimic Player
MimicTab:CreateButton({
    Name = "✨ Mimic Player",
    Callback = function()
        -- 🔗 เรียกใช้สคริปต์เลียนแบบของ Zyro
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZyroOnTop/CopyMimicScript/refs/heads/main/byZyro"))()
    end
})

-- ==================================================
-- ✅ บังคับโหลดและแสดงผล UI
-- ==================================================
Rayfield:LoadConfiguration()
Rayfield:Show()
Rayfield:Notify({
    Title = "WC32BD",
    Text = "โหลดสำเร็จ | ใช้งานลิงก์ 1x1x1x1 ใหม่แล้ว",
    Duration = 3
})

print("✅ [SUCCESS] WC32BD | All Modules Loaded Successfully!")
