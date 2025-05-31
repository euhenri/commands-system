--[[
    Server-side Functions
    Description: Core server functions for the commands system
]]--


while not ServerLoaded do
    Wait(1000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CORE FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local ServerFunctions = {
    getPlayerId = vRP.Passport,
    getPlayerSource = vRP.Source,
    hasPlayerGroup = vRP.HasGroup,

    generateItem = vRP.GenerateItem,
    giveItem = vRP.GiveItem,

    
    notify = function(source, message)
        TriggerClientEvent("Notify", source, "Warning", message, "yellow", 10000)
    end
}

return ServerFunctions