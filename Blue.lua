--// Wait for the game to load
repeat task.wait() until game:IsLoaded()

--------------------------------------------------------------------
-- Services
--------------------------------------------------------------------
local rs      = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local run     = game:GetService("RunService")
local guiServ = game:GetService("CoreGui")

--------------------------------------------------------------------
-- Remotes
--------------------------------------------------------------------
local DRIVE_REMOTE = rs:WaitForChild("RemoteEvents"):WaitForChild("Main"):WaitForChild("Drive")

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FarmGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiServ

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.4, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0, 15)
button.BackgroundColor3 = Color3.fromRGB(60,60,60)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "Auto Drive: OFF"
button.Parent = frame

--------------------------------------------------------------------
-- Logic
--------------------------------------------------------------------
local running = false
local heartbeat = nil

-- Helper: send the correct key state to the server
local function sendKeyState(isDown)
    -- Try different variations of the remote event
    local success, err = pcall(function()
        DRIVE_REMOTE:FireServer(isDown and "W" or "WUp")
    end)
    
    if not success then
        success, err = pcall(function()
            DRIVE_REMOTE:FireServer(isDown and "WDown" or "WUp")
        end)
    end
    
    if not success then
        success, err = pcall(function()
            DRIVE_REMOTE:FireServer(isDown)
        end)
    end
    
    if not success then
        warn("Failed to send key state:", err)
    end
end

button.MouseButton1Click:Connect(function()
    running = not running
    button.Text = running and "Auto Drive: ON" or "Auto Drive: OFF"

    if running then
        -- Start by sending a key down event
        sendKeyState(true)
        
        -- Start the loop to keep the key pressed
        heartbeat = run.Heartbeat:Connect(function()
            sendKeyState(true)
        end)
    else
        -- Stop the loop and release the key
        if heartbeat then
            heartbeat:Disconnect()
            heartbeat = nil
        end
        sendKeyState(false)
    end
end)
