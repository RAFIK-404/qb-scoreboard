local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isScoreboardOpen = false
local playerSettings = {}

-- Load player settings from KVP storage
local function LoadPlayerSettings()
    local settings = GetResourceKvpString("qb-scoreboard:settings")
    if settings then
        playerSettings = json.decode(settings)
    else
        playerSettings = Config.DefaultSettings
    end
end

-- Save player settings to KVP storage
local function SavePlayerSettings()
    SetResourceKvp("qb-scoreboard:settings", json.encode(playerSettings))
end

-- Open scoreboard
function OpenScoreboard()
    SendNUIMessage({
        action = "open",
        settings = playerSettings,
        serverInfo = {
            name = Config.ServerName or "Server Name",
            logo = Config.ServerLogo or ""
        },
        config = {
            hidePlayerNames = Config.HidePlayerNames,
            heists = Config.Heists
        }
    })
    
    TriggerServerEvent("qb-scoreboard:server:GetPlayersData")
    SetNuiFocus(true, true)
end

-- Close scoreboard
function CloseScoreboard()
    SendNUIMessage({
        action = "close"
    })
    SetNuiFocus(false, false)
end

-- Initialize
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    LoadPlayerSettings()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Toggle scoreboard
RegisterCommand('scoreboard', function()
    isScoreboardOpen = not isScoreboardOpen
    if isScoreboardOpen then
        OpenScoreboard()
    else
        CloseScoreboard()
    end
end, false)

local openKey = Config.OpenKey
if not openKey or openKey == "" then
    openKey = "HOME"
end

RegisterKeyMapping('scoreboard', 'Toggle Scoreboard', 'keyboard', openKey)

-- Receive player data from server
RegisterNetEvent('qb-scoreboard:client:PlayersData', function(playersData, jobsData, heistData, policeCount)
    SendNUIMessage({
        action = "updateData",
        players = playersData,
        jobs = jobsData,
        heists = heistData,
        policeCount = policeCount
    })
end)

-- NUI Callbacks
RegisterNUICallback('close', function(_, cb)
    isScoreboardOpen = false
    CloseScoreboard()
    cb('ok')
end)

RegisterNUICallback('saveSettings', function(data, cb)
    playerSettings = data
    SavePlayerSettings()
    cb('ok')
end)

-- Update data every few seconds when scoreboard is open
CreateThread(function()
    while true do
        if isScoreboardOpen then
            TriggerServerEvent("qb-scoreboard:server:GetPlayersData")
        end
        Wait(Config.RefreshRate or 5000)
    end
end)
