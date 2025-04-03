# QB-Scoreboard

An enhanced scoreboard for QBCore servers with player list, job information, and heist status tracking.

## Screenshots

![Players Tab](https://i.ibb.co/ZzcbxRWf/image.png)
![Jobs Tab](https://i.ibb.co/TD1FhPmQ/image.png)
![Heist Tab](https://i.ibb.co/HTtLTpVv/image.png)
![Settings Tab](https://i.ibb.co/4Z5Jg6G4/image.png)


## Features

- Player list with roles and ping
- Job information with player counts
- Heist status tracking with cooldowns
- Customizable UI with themes and colors
- Settings saved locally for each player

## Installation

1. Extract the resource to your server's resources folder
2. Add `ensure qb-scoreboard` to your server.cfg
3. Configure the settings in `config.lua`
4. Restart your server

## Usage

### Player Commands

- Press `HOME` key (or configured key) to open/close the scoreboard
- Use the tabs to switch between Players, Jobs, and Heists views
- Customize the UI in the settings panel

## Exports

### Server Exports

```lua
-- Set a heist on cooldown
-- @param heistId: The ID of the heist (must match an ID in Config.Heists)
-- @param minutes: The cooldown duration in minutes (optional, uses default from config if not provided)
-- @return boolean: Whether the cooldown was set successfully
exports['qb-scoreboard']:SetHeistCooldown(heistId, minutes)

-- Clear a heist cooldown
-- @param heistId: The ID of the heist
-- @return boolean: Whether the cooldown was cleared successfully
exports['qb-scoreboard']:ClearHeistCooldown(heistId)

-- Get the remaining cooldown time for a heist
-- @param heistId: The ID of the heist
-- @return number: Remaining cooldown time in seconds (0 if no cooldown)
exports['qb-scoreboard']:GetHeistCooldown(heistId)
