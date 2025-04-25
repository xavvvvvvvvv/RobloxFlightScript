
-- Файл: playerScript.lua

-- Получаем необходимые сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Защита от смерти
character:FindFirstChildOfClass("Humanoid").BreakJointsOnDeath = false

-- Настройка вращения
local rotationSpeed = 9999999 -- супер высокая скорость
local flingForce = 10000000 -- сила отталкивания

-- Добавляем вращение
RunService.Stepped:Connect(function()
    hrp.Velocity = Vector3.new(100, 100, 100) -- нужна высокая скорость для флинг-эффекта
    hrp.RotVelocity = Vector3.new(rotationSpeed, rotationSpeed, rotationSpeed)
end)

-- Отталкивание других игроков при касании
hrp.Touched:Connect(function(hit)
    local otherHRP = hit and hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
    if otherHRP and otherHRP ~= hrp then
        otherHRP.Velocity = (otherHRP.Position - hrp.Position).Unit * flingForce
    end
end)
