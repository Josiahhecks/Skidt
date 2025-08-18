-- Simple Mobile GUI – Base Touch + Helpers
local Players  = game:GetService("Players")
local UIS      = game:GetService("UserInputService")
local Run      = game:GetService("RunService")

-- quick UI lib (lightweight, no external files)
local Screen = Instance.new("ScreenGui")
Screen.Name = "SimpleHelpers"
Screen.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,220,0,200)
Main.Position = UDim2.new(0.5,-110,0.5,-100)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.Parent = Screen
Main.Active = true
Main.Draggable = true

local UIList = Instance.new("UIListLayout")
UIList.Parent = Main
UIList.Padding = UDim.new(0,8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- helpers
local flyEnabled, noclipEnabled = false,false
local flyLoop, noclipLoop, speedLoop

local function fireTouch(part)
    local touch = part:FindFirstChild("TouchInterest")
    if touch then
        local root = Players.LocalPlayer.Character and
                     Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then touch:FireServer(root) end
    end
end

-- Touch all bases
local TouchBtn = Instance.new("TextButton")
TouchBtn.Size = UDim2.new(1,-16,0,30)
TouchBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
TouchBtn.Text = "Touch All Bases"
TouchBtn.TextColor3 = Color3.new(1,1,1)
TouchBtn.Font = Enum.Font.SourceSansBold
TouchBtn.Parent = Main
TouchBtn.MouseButton1Click:Connect(function()
    for i=1,10 do
        local base = workspace.Bases:FindFirstChild("Base"..i)
        if base and base:FindFirstChild("TouchingPart") then
            fireTouch(base.TouchingPart)
        end
    end
end)

-- Fly toggle
local FlyToggle = TouchBtn:Clone()
FlyToggle.Text = "Fly: OFF"
FlyToggle.Parent = Main
FlyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyToggle.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
    if flyEnabled then
        local hum = Players.LocalPlayer.Character and
                    Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        flyLoop = Run.Heartbeat:Connect(function()
            local root = Players.LocalPlayer.Character and
                         Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root or not flyEnabled then return end
            local vel = Vector3.zero
            local cam = workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel + Vector3.new(0,-1,0) end
            local move = Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit * 50
            root.Velocity = (move + vel) * 50
        end)
    else
        if flyLoop then flyLoop:Disconnect() end
        local hum = Players.LocalPlayer.Character and
                    Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)

-- Speed slider
local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(1,-16,0,20)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "Speed: 16"
SpeedText.TextColor3 = Color3.new(1,1,1)
SpeedText.Font = Enum.Font.SourceSans
SpeedText.Parent = Main

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Size = UDim2.new(1,-16,0,20)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedSlider.Text = "16"
SpeedSlider.TextColor3 = Color3.new(1,1,1)
SpeedSlider.Font = Enum.Font.SourceSans
SpeedSlider.Parent = Main

local dragging, sliderPos = false, 0
SpeedSlider.MouseButton1Down:Connect(function(x)
    dragging = true
    sliderPos = (x - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        sliderPos = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X,0,1)
        local speed = math.floor(16 + sliderPos*84)
        SpeedSlider.Text = tostring(speed)
        SpeedText.Text = "Speed: "..speed
    end
end)
UIS.InputEnded:Connect(function()
    dragging = false
end)
speedLoop = Run.Heartbeat:Connect(function()
    local hum = Players.LocalPlayer.Character and
                Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        local val = tonumber(SpeedSlider.Text) or 16
        hum.WalkSpeed = val
    end
end)

-- Wall-only noclip
local NoclipToggle = TouchBtn:Clone()
NoclipToggle.Text = "Wall Noclip: OFF"
NoclipToggle.Parent = Main
NoclipToggle.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipToggle.Text = noclipEnabled and "Wall Noclip: ON" or "Wall Noclip: OFF"
    if noclipEnabled then
        noclipLoop = Run.Stepped:Connect(function()
            local char = Players.LocalPlayer.Character
            if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.CanCollide = false
                end
            end
        end)
    else
        if noclipLoop then noclipLoop:Disconnect() end
        local char = Players.LocalPlayer.Character
        if char then
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)
