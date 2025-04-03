local QBCore = exports['qb-core']:GetCoreObject()

-- Table to store heist cooldowns
local HeistCooldowns = {}

-- Function to get player role based on job
local function GetPlayerRole(player)
    if not player or not player.PlayerData then return "Civilian" end

    local job = player.PlayerData.job
    if not job or not job.name then return "Civilian" end

    if Config.Jobs[job.name] then
        local jobLabel = Config.Jobs[job.name].label or job.name
        local jobGrade = job.grade and job.grade.name or ""

        if job.onduty then
            return jobLabel .. (jobGrade ~= "" and " - " .. jobGrade or "")
        else
            return jobLabel .. " (Off Duty)"
        end
    end
    
    return "Civilian"
end

local function GetPoliceCount()
    local policeCount = 0
    local players = QBCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        local player = QBCore.Functions.GetPlayer(playerId)
        if player and player.PlayerData.job.name == "police" and player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    
    return policeCount
end

local function GetAllPlayers()
    local players = {}
    local xPlayers = QBCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(xPlayers) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer then
            local playerData = {
                id = playerId,
                name = Config.HidePlayerNames and GetHiddenName(xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname) or xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname,
                role = GetPlayerRole(xPlayer),
                ping = GetPlayerPing(playerId)
            }
            table.insert(players, playerData)
        end
    end
    
    return players
end

function GetHiddenName(name)
    if not name or name == "" then return "Unknown" end
    if #name <= 2 then return name end
    return string.sub(name, 1, 2) .. string.rep("*", math.min(#name - 2, 5))
end

local function GetAllJobs()
    local jobs = {}
    local xPlayers = QBCore.Functions.GetPlayers()
    
    for jobName, jobData in pairs(Config.Jobs or {}) do
        jobs[jobName] = {
            label = jobData.label,
            icon = jobData.icon,
            players = 0
        }
    end
    
    for _, playerId in ipairs(xPlayers) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer and jobs[xPlayer.PlayerData.job.name] then
            jobs[xPlayer.PlayerData.job.name].players = jobs[xPlayer.PlayerData.job.name].players + 1
        end
    end
    
    return jobs
end

local function GetHeistStatus()
    local heists = {}
    local policeCount = GetPoliceCount()
    local currentTime = os.time()
    
    for heistId, heistData in pairs(Config.Heists or {}) do
        local cooldownEnd = HeistCooldowns[heistId] or 0
        local isOnCooldown = currentTime < cooldownEnd
        local cooldownRemaining = isOnCooldown and (cooldownEnd - currentTime) or 0
        
        local cooldownText = ""
        if isOnCooldown then
            local minutes = math.floor(cooldownRemaining / 60)
            local hours = math.floor(minutes / 60)
            minutes = minutes % 60
            
            if hours > 0 then
                cooldownText = string.format("%dh %dm", hours, minutes)
            else
                cooldownText = string.format("%dm", minutes)
            end
        end
        
        heists[heistId] = {
            name = heistData.name,
            description = heistData.description,
            image = heistData.image,
            icon = heistData.icon,
            available = not isOnCooldown,
            cooldown = isOnCooldown,
            cooldownText = cooldownText,
            requiredPolice = heistData.requiredPolice or 0
        }
    end
    
    return heists
end

RegisterNetEvent('qb-scoreboard:server:GetPlayersData', function()
    local src = source
    
    local players = GetAllPlayers()
    local jobs = GetAllJobs()
    local heists = GetHeistStatus()
    local policeCount = GetPoliceCount()
    
    TriggerClientEvent('qb-scoreboard:client:PlayersData', src, players, jobs, heists, policeCount)
end)

RegisterNetEvent('qb-scoreboard:server:saveSettings', function()
end)

exports('SetHeistCooldown', function(heistId, cooldownMinutes)
    if not heistId or not Config.Heists[heistId] then
        print("^1[qb-scoreboard] Error: Invalid heist ID for cooldown: " .. tostring(heistId) .. "^7")
        return false
    end
    
    if not cooldownMinutes or type(cooldownMinutes) ~= "number" or cooldownMinutes <= 0 then
        cooldownMinutes = Config.Heists[heistId].defaultCooldown or 60
    end
    
    local cooldownEnd = os.time() + (cooldownMinutes * 60)
    HeistCooldowns[heistId] = cooldownEnd
    
    print("^2[qb-scoreboard] Set cooldown for " .. heistId .. " for " .. cooldownMinutes .. " minutes^7")
    return true
end)

exports('IsHeistOnCooldown', function(heistId)
    if not heistId or not Config.Heists[heistId] then
        return false, 0
    end
    
    local cooldownEnd = HeistCooldowns[heistId] or 0
    local currentTime = os.time()
    local isOnCooldown = currentTime < cooldownEnd
    local remainingTime = isOnCooldown and (cooldownEnd - currentTime) or 0
    
    return isOnCooldown, remainingTime
end)

exports('ClearHeistCooldown', function(heistId)
    if not heistId or not Config.Heists[heistId] then
        return false
    end
    
    HeistCooldowns[heistId] = nil
    print("^2[qb-scoreboard] Cleared cooldown for " .. heistId .. "^7")
    return true
end)
