-- load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Window
local Window = OrionLib:MakeWindow({
    Name = "Farm Hub",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

-- Services
local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local vu = game:GetService("VirtualUser") -- for simulating keypresses

-- Game stuff
local GRASS_PART = workspace:WaitForChild("GrassFolder"):WaitForChild("Level3_16_Grass")
local DRIVE_REMOTE = rs:WaitForChild("RemoteEvents"):WaitForChild("Main"):WaitForChild("Drive")

-- Vars
local runW = false
local runTP = false

--------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------
-- Auto-hold W
local function startWFarm()
    if runW then return end
    runW = true
    task.spawn(function()
        while runW do
            -- simulate holding down W
            vu:SetKeyDown("W")
            task.wait(0.1)
        end
        vu:SetKeyUp("W") -- release W when stopped
    end)
end

local function stopWFarm()
    runW = false
end

-- Instant-TP farm
local function startTPFarm()
    if runTP then return end
    runTP = true
    task.spawn(function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp  = char:WaitForChild("HumanoidRootPart")

        while runTP do
            DRIVE_REMOTE:FireServer("Ready")
            hrp.CFrame = GRASS_PART.CFrame + Vector3.new(0,3,0)
            task.wait(0.05)
            DRIVE_REMOTE:FireServer("return")
            task.wait(0.05)
        end
    end)
end

local function stopTPFarm()
    runTP = false
end

--------------------------------------------------------------------
-- Orion Tabs & Toggles
--------------------------------------------------------------------
local Tab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "Auto Walk Forward (Hold W)",
    Default = false,
    Callback = function(Value)
        if Value then
            startWFarm()
        else
            stopWFarm()
        end
    end
})

Tab:AddToggle({
    Name = "Instant TP Farm",
    Default = false,
    Callback = function(Value)
        if Value then
            startTPFarm()
        else
            stopTPFarm()
        end
    end
})

-- init
OrionLib:Init()
