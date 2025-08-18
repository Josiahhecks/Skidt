repeat task.wait() until game:IsLoaded()

local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- remotes
local DRIVE_REMOTE = rs:WaitForChild("RemoteEvents"):WaitForChild("Main"):WaitForChild("Drive")

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FarmGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.4, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0, 15)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "Auto Drive: OFF"

--------------------------------------------------------------------
-- Logic
--------------------------------------------------------------------
local running = false

button.MouseButton1Click:Connect(function()
    running = not running
    button.Text = running and "Auto Drive: ON" or "Auto Drive: OFF"

    if running then
        task.spawn(function()
            while running and task.wait(0.1) do
                -- simulate holding "W"
                DRIVE_REMOTE:FireServer("Start")  
            end
        end)
    end
end)

-- auto stop when fuel is 0 (if game handles it by server)
