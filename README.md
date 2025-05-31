# Command System

A FiveM command system that allows managing player clothes, weapons, and punishments.

## Project Structure

```
commands-system/
├── client-side/
│   └── main.lua
├── server-side/
│   └── main.lua
├── database/
│   ├── punishments.json
│   └── README.md
├── config.lua
└── README.md
```

## Features

### Clothing System
- `/setclothes` command - Sets clothes for a player
- `/remclothes` command - Removes clothes from a player
- Support for different presets (police, paramedic, etc.)
- Automatic saving of previous clothing state

### Weapon System
- `/setweapons` command - Sets weapons for a player
- `/remweapons` command - Removes weapons from a player
- Support for different presets (police, paramedic, etc.)
- Automatic saving of previous inventory

### Punishment System
- `/punish` command - Applies/removes punishment from a player
- Configurable visual effects and restrictions
- Punishment persistence in database
- Permission system based on groups

## Configuration

### Administration Groups
```lua
CommandSystem.adminGroups = {
    Admin = {
        name = "Admin",
        level = 1
    },
    Moderator = {
        name = "Moderator",
        level = 2
    }
}
```

### Clothing Presets
```lua
ClothesSystem.presets = {
    ["police"] = {
        ["mp_m_freemode_01"] = {
            ["pants"] = { item = 0, texture = 0 },
            -- ... other components
        }
    }
}
```

### Weapon Presets
```lua
WeaponsSystem.presets = {
    ["police"] = {
        weapons = {
            ["WEAPON_PISTOL"] = 1,
            -- ... other weapons
        },
        items = {
            ["handcuffs"] = 1,
            -- ... other items
        }
    }
}
```

## Database

The system uses a JSON file to store punishment information:

```json
{
    "schema_version": "1.0",
    "punishments": {
        "player_id": {
            "active": true,
            "started_at": "2024-03-21 10:00:00",
            "reason": "Punishment reason",
            "admin_id": "admin_id"
        }
    },
    "metadata": {
        "last_updated": "2024-03-21 10:00:00",
        "total_punishments": 1
    }
}
```

## Debug

The system includes a debug mode that can be enabled in the configuration file:

```lua
DebugSystem = {
    enabled = false,
    logLevel = "info" -- debug, info, warning, error
}
```

## Requirements

- FiveM Server
- vRP Framework
- Configured administrator permissions

## Installation

1. Copy the `commands-system` folder to your server's `resources` directory
2. Add `ensure commands-system` to your `server.cfg`
3. Configure administration groups and presets in the `config.lua` file
4. Restart the server

## Contribution

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Commands System Database

This directory contains the database files for the commands system.

## Structure

```
database
```

## punishments.json

JSON file that stores information about player punishments.

### File Structure

```json
{
    "schema_version": "1.0",
    "punishments": {
        "player_id": {
            "active": true,
            "started_at": "2024-03-21 10:00:00",
            "reason": "Punishment reason",
            "admin_id": "admin_id"
        }
    },
    "metadata": {
        "last_updated": "2024-03-21 10:00:00",
        "total_punishments": 1
    }
}
```

### Fields

- `schema_version`: Database schema version
- `punishments`: Object containing active punishments
  - `player_id`: ID of the punished player
    - `active`: Punishment status (true/false)
    - `started_at`: Date and time when punishment started
    - `reason`: Reason for the punishment
    - `admin_id`: ID of the admin who applied the punishment
- `metadata`: Database metadata
  - `last_updated`: Date and time of last update
  - `total_punishments`: Total number of punishments

## Backup and Maintenance

Recommendations for database maintenance:

1. Regularly backup the `punishments.json` file
2. Keep the file organized and clean
3. Periodically check for old punishments that can be removed
4. Keep `schema_version` updated when there are structure changes

## Security

- The `punishments.json` file should have read/write permissions only for the server
- Do not share the file with players
- Keep backups in a secure location
- Regularly check for unauthorized file manipulation

## Cleanup

To clean old or inactive punishments:

1. Backup the current file
2. Remove desired punishments manually or use a script
3. Update the `total_punishments` field in metadata
4. Update the `last_updated` field in metadata

## Cleanup Script Example

```lua
local function cleanOldPunishments()
    local file = LoadResourceFile("commands-system", "./database/punishments.json")
    local jsonData = json.decode(file)
    
    if jsonData and jsonData.punishments then
        local currentTime = os.time()
        local removedCount = 0
        
        for playerId, punishment in pairs(jsonData.punishments) do
            -- Remove punishments older than 7 days
            if os.time(os.date("!*t", punishment.started_at)) < (currentTime - 604800) then
                jsonData.punishments[playerId] = nil
                removedCount = removedCount + 1
            end
        end
        
        jsonData.metadata.last_updated = os.date("%Y-%m-%d %H:%M:%S")
        jsonData.metadata.total_punishments = jsonData.metadata.total_punishments - removedCount
        
        SaveResourceFile("commands-system", "./database/punishments.json", json.encode(jsonData, { indent = true }), -1)
    end
end 