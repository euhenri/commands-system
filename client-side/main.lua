--[[
    Client-side Main
    Description: Main client file for the commands system
]]--

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPENDENCIES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")

local CommandsSystem = {}
Tunnel.bindInterface("commands-system", CommandsSystem)
vSERVER = Tunnel.getInterface("commands-system")

ClientLoaded = true
LocalPlayer["state"]:set("Punishment", false, true)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function drawText(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local function getClosestPlayers(radius)
	local selected = {}
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local gamePool = GetGamePool("CPed")

	for _, entity in pairs(gamePool) do
		local index = NetworkGetPlayerIndexFromPed(entity)

		if index and IsPedAPlayer(entity) and NetworkIsPlayerConnected(index) then
			if #(coords - GetEntityCoords(entity)) <= radius then
				selected[#selected + 1] = GetPlayerServerId(index)
			end
		end
	end

	return selected
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MAIN THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while not ClientFunctionsLoaded do
		Wait(1000)
	end

	RegisterNetEvent("commands-system:InitSphere", function(mode, presetType)
		if not SphereActive then
			SphereActive = true
			local ped = PlayerPedId()
			local r, g, b, a = table.unpack(ConfigMarkers[mode])
			local radius = 10.0

			while SphereActive do
				local coords = GetEntityCoords(ped)

				DrawMarker(28, coords.x, coords.y, coords.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, 0, 0, 0, 0)

				drawText("~y~E~w~  SELECT PLAYERS", 4, 0.015, 0.62, 0.38, 255, 255, 255, 255)
				drawText("~y~F~w~  CANCEL", 4, 0.015, 0.65, 0.38, 255, 255, 255, 255)
				drawText("~y~SCROLL UP~w~  INCREASE RADIUS", 4, 0.015, 0.68, 0.38, 255, 255, 255, 255)
				drawText("~y~SCROLL DOWN~w~  DECREASE RADIUS", 4, 0.015, 0.71, 0.38, 255, 255, 255, 255)

				-- Handle input
				if IsControlJustPressed(0, 38) then -- E key
					SphereActive = false
					local players = getClosestPlayers(radius)

					if mode == "SetClothes" then
						TriggerServerEvent("commands-system:ApplyClothes", players, presetType)
					elseif mode == "RemClothes" then
						TriggerServerEvent("commands-system:RemClothes", players)
					elseif mode == "SetWeapons" then
						TriggerServerEvent("commands-system:ApplyWeapons", players, presetType)
					elseif mode == "RemWeapons" then
						TriggerServerEvent("commands-system:RemWeapons", players)
					end
				end

				if IsControlJustPressed(0, 49) then -- F key
					SphereActive = false
				end

				if IsControlJustPressed(0, 180) then -- Scroll up
					radius = math.max(6, radius - 2.0)
				end

				if IsControlJustPressed(0, 181) then -- Scroll down
					radius = math.min(20, radius + 2.0)
				end

				Wait(4)
			end
		end
	end)

	RegisterNetEvent("commands-system:InitPunishment", function()
		LocalPlayer["state"]:set("Punishment", true, true)
		Notify("Modo punição ativo, siga as regras da próxima vez")
		
		CreateThread(function()
			while LocalPlayer["state"]["Punishment"] do
				local playerId = PlayerId()
				SetPlayerCanDoDriveBy(playerId, false)
				DisablePlayerFiring(playerId, true)
				DisableControlAction(0, 24)  -- LMB Attack
				DisableControlAction(0, 25)  -- RMB Aim
				DisableControlAction(0, 140) -- R Attack light
				DisableControlAction(0, 142) -- LMB Alternate
				DisableControlAction(0, 257) -- LMB Attack2
				
				Wait(4)
			end
		end)
	end)

	RegisterNetEvent("commands-system:StopPunishment", function()
		LocalPlayer["state"]:set("Punishment", false, true)
		Notify("Punishment mode disabled, follow the rules to avoid being punished again")
	end)
end)