
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.3, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.Text = "Flight Speed"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -20, 0.3, 0)
speedBox.Position = UDim2.new(0, 10, 0.4, 0)
speedBox.PlaceholderText = "Enter speed"
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedBox.Parent = frame

-- Flight Logic
local flying = false
local speed = tonumber(speedBox.Text) or 50
local bodyGyro
local bodyVelocity
local direction = Vector3.zero

speedBox.FocusLost:Connect(function()
	local newSpeed = tonumber(speedBox.Text)
	if newSpeed then
		speed = newSpeed
	end
end)

function startFlying()
	character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.Parent = humanoidRootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = humanoidRootPart

	flying = true
end

function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		if flying then
			stopFlying()
		else
			startFlying()
		end
	end
end)

runService.RenderStepped:Connect(function()
	if flying then
		local hrp = character:WaitForChild("HumanoidRootPart")
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		direction = Vector3.zero
		if uis:IsKeyDown(Enum.KeyCode.W) then
			direction = direction + workspace.CurrentCamera.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.S) then
			direction = direction - workspace.CurrentCamera.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.A) then
			direction = direction - workspace.CurrentCamera.CFrame.RightVector
		end
		if uis:IsKeyDown(Enum.KeyCode.D) then
			direction = direction + workspace.CurrentCamera.CFrame.RightVector
		end
		if direction.Magnitude > 0 then
			bodyVelocity.Velocity = direction.Unit * speed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
	end
end)
