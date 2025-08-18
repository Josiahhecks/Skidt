repeat task.wait() until game:IsLoaded()

local ts = game:GetService("TweenService")
local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- locate grass part
local GRASS_PART = workspace:WaitForChild("GrassFolder"):WaitForChild("Level3_16_Grass")

-- locate remotes
local DRIVE_REMOTE = rs:WaitForChild("RemoteEvents"):WaitForChild("Main"):WaitForChild("Drive")

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FarmGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui") -- ✅ executor-safe
