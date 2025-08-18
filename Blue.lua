repeat task.wait() until game:IsLoaded()

local gui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,200,0,50)
btn.Position = UDim2.new(0.5,-100,0.5,-25)
btn.Text = "Executor GUI Test"
btn.Parent = gui
