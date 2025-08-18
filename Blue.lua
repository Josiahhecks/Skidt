--//  Flashlight Hub – Manual Base Touch + Helpers (Mobile-Friendly)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUI.lua"))()

local win = Library:Window({
    Title = "Base Touch & Helpers",
    Desc  = "Manual touch + Fly / Speed / Wall-Noclip",
    Icon  = 105059922903197,
    Theme = "Dark",
    Config = { Keybind = Enum.KeyCode.RightControl, Size = UDim2.new(0, 320, 0, 350) }
})

local tab = win:Tab({Title = "Main", Icon = "hand-pointer"})
tab:Section({Title = "Base Touch"})
tab:Section({Title = "Helpers"})

-----------------------------------------------------------------
--  Manual Base Touch
-----------------------------------------------------------------
local function fireTouch(part)
    local touch = part:FindFirstChild("TouchInterest")
    if touch then
        local root = game.Players.LocalPlayer.Character and
                     game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then touch:FireServer(root) end
    end
end

tab:Toggle({
    Title = "Touch All Bases",
    Desc  = "Fire TouchInterest on Base1→Base10 once",
    Value = false,
    Callback = function(on)
        if not on then return end
        for i = 1, 10 do
            local base = workspace.Bases:FindFirstChild("Base"..i)
            if base and base:FindFirstChild("TouchingPart") then
                fireTouch(base.TouchingPart)
            end
        end
    end
})

-----------------------------------------------------------------
--  Fly
-----------------------------------------------------------------
local flyEnabled = false
local flyLoop

tab:Toggle({
    Title = "Fly",
    Desc  = "Space ↑  Shift ↓",
    Value = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            local hum = game.Players.LocalPlayer.Character and
                        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            hum.PlatformStand = true
            flyLoop = game:GetService("RunService").Heartbeat:Connect(function(dt)
                local root = hum.Parent and hum.Parent:FindFirstChild("HumanoidRootPart")
                if not root or not flyEnabled then return end
                local vel = Vector3.zero
                local cam = workspace.CurrentCamera
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space)  then vel = vel + Vector3.new(0,1,0) end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel + Vector3.new(0,-1,0) end
                local move = Vector3.new(
                    cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z
                ).Unit * (cam.CFrame.LookVector * vel).Magnitude
                root.Velocity = (move + vel) * 50
            end)
        else
            if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
            local hum = game.Players.LocalPlayer.Character and
                        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
})

-----------------------------------------------------------------
--  Speed Boost
-----------------------------------------------------------------
local speedConn
tab:Slider({
    Title = "Speed Boost",
    Desc  = "WalkSpeed 16 → 100",
    Min   = 16,
    Max   = 100,
    Value = 16,
    Callback = function(v)
        if speedConn then speedConn:Disconnect() end
        speedConn = game:GetService("RunService").Heartbeat:Connect(function()
            local hum = game.Players.LocalPlayer.Character and
                        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end)
    end
})

-----------------------------------------------------------------
--  Wall-Only Noclip
-----------------------------------------------------------------
local noclipEnabled = false
local noclipLoop

tab:Toggle({
    Title = "Wall Noclip",
    Desc  = "Walk through parts but keep floor collision",
    Value = false,
    Callback = function(v)
        noclipEnabled = v
        if v then
            noclipLoop = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        if part.Name ~= "HumanoidRootPart" then  -- keep floor collision
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipLoop then noclipLoop:Disconnect(); noclipLoop = nil end
            local char = game.Players.LocalPlayer.Character
            if char then
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

-----------------------------------------------------------------
--  Fix “black window” on mobile
-----------------------------------------------------------------
task.wait(0.2) -- let UI finish drawing
local scroller = tab["Main"]["ScrollingFrame"]
if scroller then
    scroller.CanvasSize = UDim2.new(0,0,0, scroller.UIListLayout.AbsoluteContentSize.Y + 10)
end

-----------------------------------------------------------------
win:Notify({Title = "Loaded", Desc = "Ready to use on mobile or PC", Time = 3})
