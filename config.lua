--[[
    Configuration File
    Description: Main configuration file for the commands system
]]--

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
DebugSystem = {
    enabled = false, -- Enable/disable debug mode
    logLevel = "info" -- Available levels: debug, info, warning, error
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CommandSystem = {
    commands = {
        setClothes = "setclothes",
        removeClothes = "remclothes",
        setWeapons = "setweapons",
        removeWeapons = "remweapons",
        punish = "punish"
    },
    adminGroups = {
        Admin = {
            name = "Admin",
            level = 1
        },
        Moderator = {
            name = "Moderator",
            level = 2
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
ClothesSystem = {
    presets = {
        ["police"] = {
            ["mp_m_freemode_01"] = {
                ["pants"] = { item = 0, texture = 0 },
                ["arms"] = { item = 0, texture = 0 },
                ["tshirt"] = { item = 0, texture = 0 },
                ["vest"] = { item = 0, texture = 0 },
                ["torso"] = { item = 0, texture = 0 },
                ["shoes"] = { item = 0, texture = 0 },
                ["mask"] = { item = 0, texture = 0 },
                ["backpack"] = { item = 0, texture = 0 },
                ["hat"] = { item = 0, texture = 0 },
                ["glasses"] = { item = 0, texture = 0 },
                ["ear"] = { item = 0, texture = 0 },
                ["watch"] = { item = 0, texture = 0 },
                ["bracelet"] = { item = 0, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            }
        },
        ["paramedic"] = {
            ["mp_m_freemode_01"] = {
                ["pants"] = { item = 0, texture = 0 },
                ["arms"] = { item = 0, texture = 0 },
                ["tshirt"] = { item = 0, texture = 0 },
                ["vest"] = { item = 0, texture = 0 },
                ["torso"] = { item = 0, texture = 0 },
                ["shoes"] = { item = 0, texture = 0 },
                ["mask"] = { item = 0, texture = 0 },
                ["backpack"] = { item = 0, texture = 0 },
                ["hat"] = { item = 0, texture = 0 },
                ["glasses"] = { item = 0, texture = 0 },
                ["ear"] = { item = 0, texture = 0 },
                ["watch"] = { item = 0, texture = 0 },
                ["bracelet"] = { item = 0, texture = 0 },
                ["accessory"] = { item = 0, texture = 0 },
                ["decals"] = { item = 0, texture = 0 }
            }
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
WeaponsSystem = {
    presets = {
        ["police"] = {
            weapons = {
                ["WEAPON_PISTOL"] = 1,
                ["WEAPON_STUNGUN"] = 1,
                ["WEAPON_NIGHTSTICK"] = 1
            },
            items = {
                ["handcuffs"] = 1,
                ["police_radio"] = 1
            }
        },
        ["paramedic"] = {
            weapons = {
                ["WEAPON_STUNGUN"] = 1
            },
            items = {
                ["bandage"] = 5,
                ["medkit"] = 2,
                ["paramedic_radio"] = 1
            }
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PUNISHMENT SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
PunishmentSystem = {
    effects = {
        screenEffect = "DeathFailOut",
        duration = 1000,
        loop = true
    },
    restrictions = {
        disableMovement = true,
        disableCombat = true,
        disableInventory = true
    }
}
