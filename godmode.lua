-- 🔒 God Mode Total
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Proteção contínua
local function applyGodMode()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		-- Impede a morte
		humanoid.Name = "GodHumanoid" -- renomeia para evitar ser destruído por scripts padrão
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge

		-- Se tentarem remover o Humanoid, recoloca
		character.ChildRemoved:Connect(function(child)
			if child:IsA("Humanoid") then
				wait()
				local newHumanoid = Instance.new("Humanoid")
				newHumanoid.Name = "GodHumanoid"
				newHumanoid.Parent = character
				character.PrimaryPart = character:FindFirstChild("HumanoidRootPart")
			end
		end)

		-- Impede dano
		humanoid.HealthChanged:Connect(function()
			if humanoid.Health < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
	end
end

-- Anti-void e reaplicação
RunService.Heartbeat:Connect(function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		if hrp.Position.Y < -20 then -- caiu no void
			hrp.Velocity = Vector3.zero
			hrp.CFrame = CFrame.new(0, 10, 0)
		end
	end

	-- Reaplica God Mode sempre que morrer/reaparecer
	if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		applyGodMode()
	end
end)

-- Auto aplicar
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	applyGodMode()
end)

-- Inicial
if LocalPlayer.Character then
	applyGodMode()
end
