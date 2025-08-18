--// Gui-Tween & Instant-Tp Remote launcher
--// Fixed version: GUI shows properly
--------------------------------------------------------------------
local ts   = game:GetService("TweenService")
local rs   = game:GetService("ReplicatedStorage")
local lp   = game:GetService("Players").LocalPlayer

-- locate grass part
local GRASS_PART = workspace:WaitForChild("GrassFolder"):WaitForChild("Level3_16_Grass")

-- locate remotes
local DRIVE_REMOTE = rs:WaitForChild("RemoteEvents"):WaitForChild("Main"):WaitForChild("Drive")

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name  = "FarmGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui") -- ✅ always shows

local tweenBtn = Instance.new("TextButton")
tweenBtn.Size            = UDim2.new(0,130,0,40)
tweenBtn.Position        = UDim2.new(0.5,-135,0.9,-20)
tweenBtn.AnchorPoint     = Vector2.new(0.5,0.5)
tweenBtn.Text            = "Auto Farm"
tweenBtn.TextScaled      = true
tweenBtn.BackgroundColor3= Color3.fromRGB(60,60,60)
tweenBtn.BorderSizePixel = 0
tweenBtn.TextColor3      = Color3.new(1,1,1)
tweenBtn.Parent          = gui

local tpBtn = tweenBtn:Clone()
tpBtn.Position = UDim2.new(0.5,5,0.9,-20)
tpBtn.Text     = "Instant TP Farm"
tpBtn.Parent   = gui

--------------------------------------------------------------------
-- helpers
--------------------------------------------------------------------
local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local runTween, runTP  -- loop handles
--------------------------------------------------------------------
-- Normal tween farm
--------------------------------------------------------------------
local function startTweenFarm()
    if runTween then return end

    tweenBtn.Text = "Stop"
    runTween = true

    task.spawn(function()
        while runTween do
            DRIVE_REMOTE:FireServer("Ready")

            -- tween button to grass
            local cam = workspace.CurrentCamera
            local pos, vis = cam:WorldToViewportPoint(GRASS_PART.Position)
            local endPos = vis and UDim2.new(0,pos.X,0,pos.Y)
                        or  UDim2.new(0.5,0,0,50)

            local tween = ts:Create(tweenBtn, tweenInfo, {Position = endPos})
            tween:Play()
            tween.Completed:Wait()

            DRIVE_REMOTE:FireServer("return")

            -- reset button position
            tweenBtn.Position = UDim2.new(0.5,-135,0.9,-20)
        end
    end)
end

local function stopTweenFarm()
    runTween = false
    tweenBtn.Text = "Auto Farm"
end

--------------------------------------------------------------------
-- Instant-TP farm
--------------------------------------------------------------------
local function startTPFarm()
    if runTP then return end

    tpBtn.Text = "Stop"
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
    tpBtn.Text = "Instant TP Farm"
end

--------------------------------------------------------------------
-- click handlers
--------------------------------------------------------------------
tweenBtn.MouseButton1Click:Connect(function()
    if runTween then stopTweenFarm() else startTweenFarm() end
end)

tpBtn.MouseButton1Click:Connect(function()
    if runTP then stopTPFarm() else startTPFarm() end
end)
