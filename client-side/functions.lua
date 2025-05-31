--[[
    Client-side Functions
    Description: Core client functions for the commands system
]]--

while not ClientLoaded do
    Wait(1000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CORE FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local ClientFunctions = {
    notify = function(message)
        TriggerEvent("Notify", "Warning", message, "yellow", 10000)
    end
}

return ClientFunctions