--[[
    Server-side Main
    Description: Main server file for the commands system
]]--

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPENDENCIES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

local CommandsSystem = {}
Tunnel.bindInterface("commands-system", CommandsSystem)
vCLIENT = Tunnel.getInterface("commands-system")
vSKINSHOP = Tunnel.getInterface("skinshop")

ServerLoaded = true

local playerLastClothes = {}
local playerLastInventory = {}
local playerPunishments = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function savePunishmentData(targetId, adminId, reason)
	local file = LoadResourceFile("commands-system", "./database/punishments.json")
	local jsonData = json.decode(file) or {
		schema_version = "1.0",
		punishments = {},
		metadata = {
			last_updated = os.date("%Y-%m-%d %H:%M:%S"),
			total_punishments = 0
		}
	}

	jsonData.punishments[targetId] = {
		active = true,
		started_at = os.date("%Y-%m-%d %H:%M:%S"),
		reason = reason or "No reason provided",
		admin_id = adminId
	}


	jsonData.metadata.last_updated = os.date("%Y-%m-%d %H:%M:%S")
	jsonData.metadata.total_punishments = jsonData.metadata.total_punishments + 1

	SaveResourceFile("commands-system", "./database/punishments.json", json.encode(jsonData, { indent = true }), -1)
	playerPunishments[targetId] = jsonData.punishments[targetId]
end

local function removePunishmentData(targetId)
	local file = LoadResourceFile("commands-system", "./database/punishments.json")
	local jsonData = json.decode(file) or {
		schema_version = "1.0",
		punishments = {},
		metadata = {
			last_updated = os.date("%Y-%m-%d %H:%M:%S"),
			total_punishments = 0
		}
	}
	
	if jsonData.punishments[targetId] then
		jsonData.punishments[targetId] = nil
		jsonData.metadata.last_updated = os.date("%Y-%m-%d %H:%M:%S")
		jsonData.metadata.total_punishments = jsonData.metadata.total_punishments - 1
		SaveResourceFile("commands-system", "./database/punishments.json", json.encode(jsonData, { indent = true }), -1)
		playerPunishments[targetId] = nil
	end
end

local function loadPunishmentData()
	local file = LoadResourceFile("commands-system", "./database/punishments.json")
	if file then
		local jsonData = json.decode(file)
		if jsonData and jsonData.punishments then
			playerPunishments = jsonData.punishments
		end
	end
end


CreateThread(function()
	Wait(500)
	loadPunishmentData()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND HANDLERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while not ServerFunctionsLoaded do
		Wait(1000)
	end

	
	RegisterCommand(CommandSystem.commands.setClothes, function(source, args)
		if not args[1] then
			ServerFunctions.notify(source, "Please specify a clothes category")
			return
		end

		local playerId = ServerFunctions.getPlayerId(source)
		if not ServerFunctions.hasPlayerGroup(playerId, CommandSystem.adminGroups.Admin.name, CommandSystem.adminGroups.Admin.level) then
			ServerFunctions.notify(source, "No permission")
			return
		end

		local presetType = args[1]
		if ClothesSystem.presets[presetType] then
			TriggerClientEvent("commands-system:InitSphere", source, "SetClothes", presetType)
		else
			ServerFunctions.notify(source, "Clothes category not found")
		end
	end, false)

	
	RegisterCommand(CommandSystem.commands.removeClothes, function(source)
		local playerId = ServerFunctions.getPlayerId(source)
		if not ServerFunctions.hasPlayerGroup(playerId, CommandSystem.adminGroups.Admin.name, CommandSystem.adminGroups.Admin.level) then
			ServerFunctions.notify(source, "No permission")
			return
		end

		TriggerClientEvent("commands-system:InitSphere", source, "RemClothes")
	end, false)

	
	RegisterCommand(CommandSystem.commands.setWeapons, function(source, args)
		if not args[1] then
			ServerFunctions.notify(source, "Please specify a weapons category")
			return
		end

		local playerId = ServerFunctions.getPlayerId(source)
		if not ServerFunctions.hasPlayerGroup(playerId, CommandSystem.adminGroups.Admin.name, CommandSystem.adminGroups.Admin.level) then
			ServerFunctions.notify(source, "No permission")
			return
		end

		local presetType = args[1]
		if WeaponsSystem.presets[presetType] then
			TriggerClientEvent("commands-system:InitSphere", source, "SetWeapons", presetType)
		else
			ServerFunctions.notify(source, "Weapons category not found")
		end
	end, false)

	
	RegisterCommand(CommandSystem.commands.removeWeapons, function(source)
		local playerId = ServerFunctions.getPlayerId(source)
		if not ServerFunctions.hasPlayerGroup(playerId, CommandSystem.adminGroups.Admin.name, CommandSystem.adminGroups.Admin.level) then
			ServerFunctions.notify(source, "No permission")
			return
		end

		TriggerClientEvent("commands-system:InitSphere", source, "RemWeapons")
	end, false)

	RegisterCommand(CommandSystem.commands.punish, function(source, args)
		if not args[1] then
			ServerFunctions.notify(source, "Please specify a player ID")
			return
		end

		local adminId = ServerFunctions.getPlayerId(source)
		if not ServerFunctions.hasPlayerGroup(adminId, CommandSystem.adminGroups.Admin.name, CommandSystem.adminGroups.Admin.level) then
			ServerFunctions.notify(source, "No permission")
			return
		end

		local targetId = args[1]
		local targetSource = ServerFunctions.getPlayerSource(targetId)
		local reason = args[2] or "No reason provided"

		if playerPunishments[targetId] then
			removePunishmentData(targetId)
			if targetSource then
				TriggerClientEvent("commands-system:StopPunishment", targetSource)
			end
			ServerFunctions.notify(source, "Player removed from punishment successfully")
		else
			savePunishmentData(targetId, adminId, reason)
			if targetSource then
				TriggerClientEvent("commands-system:InitPunishment", targetSource)
			end
			ServerFunctions.notify(source, "Player punished successfully")
		end
	end, false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENT HANDLERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("commands-system:ApplyClothes", function(players, presetType)
	for _, targetSource in pairs(players) do
		if targetSource ~= source then
			Citizen.CreateThreadNow(function()
				local passport = vRP.Passport(targetSource)
				if passport then
					local selectedClothes = ClothesSystem.presets[presetType]
					local model = vRP.ModelPlayer(targetSource)
					
					if selectedClothes[model] then
						playerLastClothes[passport] = vSKINSHOP.Customization(targetSource)
						TriggerClientEvent("skinshop:Apply", targetSource, selectedClothes[model])
						TriggerClientEvent("updateRoupas", targetSource, selectedClothes[model])
					end
				end
			end)
		end
	end
end)

RegisterNetEvent("commands-system:RemClothes", function(players)
	for _, targetSource in pairs(players) do
		if targetSource ~= source then
			Citizen.CreateThreadNow(function()
				local passport = vRP.Passport(targetSource)
				if passport and playerLastClothes[passport] then
					TriggerClientEvent("skinshop:Apply", targetSource, playerLastClothes[passport])
					TriggerClientEvent("updateRoupas", targetSource, playerLastClothes[passport])
					playerLastClothes[passport] = nil
				end
			end)
		end
	end
end)

RegisterNetEvent("commands-system:ApplyWeapons", function(players, presetType)
	for _, targetSource in pairs(players) do
		if targetSource ~= source then
			Citizen.CreateThreadNow(function()
				local passport = vRP.Passport(targetSource)
				if passport then
					local selectedWeapons = WeaponsSystem.presets[presetType]
					if selectedWeapons then
						playerLastInventory[passport] = vRP.Inventory(passport)
						vRP.ClearInventory(passport)

						for weapon, amount in pairs(selectedWeapons.weapons) do
							ServerFunctions.generateItem(passport, weapon, amount, false)
						end

						for item, amount in pairs(selectedWeapons.items) do
							ServerFunctions.generateItem(passport, item, amount, false)
						end
					end
				end
			end)
		end
	end
end)

-- Remove Weapons Event
RegisterNetEvent("commands-system:RemWeapons", function(players)
	for _, targetSource in pairs(players) do
		if targetSource ~= source then
			Citizen.CreateThreadNow(function()
				local passport = vRP.Passport(targetSource)
				if passport and playerLastInventory[passport] then
					vRP.ClearInventory(passport)
					for slot, data in pairs(playerLastInventory[passport]) do
						ServerFunctions.giveItem(passport, data.item, data.amount, false)
					end
					playerLastInventory[passport] = nil
				end
			end)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION HANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(passport, source)
	if playerLastClothes[passport] then
		TriggerClientEvent("skinshop:Apply", source, playerLastClothes[passport])
		TriggerClientEvent("updateRoupas", source, playerLastClothes[passport])
		playerLastClothes[passport] = nil
	end

	if playerLastInventory[passport] then
		vRP.ClearInventory(passport)
		for slot, data in pairs(playerLastInventory[passport]) do
			ServerFunctions.giveItem(passport, data.item, data.amount, false)
		end
		playerLastInventory[passport] = nil
	end

	if playerPunishments[tostring(passport)] then
		TriggerClientEvent("commands-system:InitPunishment", source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function _print(str)
	if DebugSystem.enabled then
		local date = os.date("^3[%H:%M:%S]:^0")
		local message = date .. " " .. str
		return print(message)
	end
end
