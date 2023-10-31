VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

local activeAlerts = {}
local alertIdCounter = 0

RegisterServerEvent('fists-joblert:sendAlert')
AddEventHandler('fists-joblert:sendAlert', function(jobType, coords)
    print("Alert received:", jobType, coords)  -- Debug print
    alertIdCounter = alertIdCounter + 1
    local alert = {id = alertIdCounter, jobType = jobType, coords = coords}
    table.insert(activeAlerts, alert)
    TriggerClientEvent('fists-joblert:updateAlerts', -1, activeAlerts)
    SendJobNotification(jobType, 'New alert received!')
end)

RegisterServerEvent('fists-joblert:respondToAlert')
AddEventHandler('fists-joblert:respondToAlert', function(alertId)
    for i, alert in ipairs(activeAlerts) do
        if alert.id == alertId then
            table.remove(activeAlerts, i)
            break
        end
    end
    TriggerClientEvent('fists-joblert:updateAlerts', -1, activeAlerts)
end)

RegisterServerEvent('fists-joblert:cancelAlert')
AddEventHandler('fists-joblert:cancelAlert', function(alertId)
    for i, alert in ipairs(activeAlerts) do
        if alert.id == alertId then
            table.remove(activeAlerts, i)
            break
        end
    end
    TriggerClientEvent('fists-joblert:updateAlerts', -1, activeAlerts)
end)


RegisterServerEvent('fists-jobalert:checkJob')
AddEventHandler('fists-jobalert:checkJob', function(jobName)
    local _source = source
    local User = VorpCore.getUser(_source)
    
    if User then
        local Character = VorpCore.getUser(_source).getUsedCharacter
        if Character then
            local playerJob = Character.job
            local isJob = playerJob == jobName
            TriggerClientEvent('fists-jobalert:returnJobCheck', _source, isJob, playerJob)
        else
            print("Character object not found for player:", _source)
            TriggerClientEvent('fists-jobalert:returnJobCheck', _source, false, "Character object not found")
        end
    else
        print("User object not found for player:", _source)
        TriggerClientEvent('fists-jobalert:returnJobCheck', _source, false, "User object not found")
    end
end)


function SendJobNotification(jobType, message)
    local jobNames = Config[jobType..'Jobs']
    for _, jobName in pairs(jobNames) do
        TriggerClientEvent('vorp:TipRight', GetPlayersWithJob(jobName), message, 4000)
    end
end



function GetPlayersWithJob(jobName)
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        TriggerServerEvent('fists-joblert:checkJob', playerId, jobName)
        -- If the event returns true, add the player to the list
        table.insert(players, playerId)
    end
    return players
end


RegisterServerEvent('fists-joblert:respondToAlert')
AddEventHandler('fists-joblert:respondToAlert', function(alertId)
    for i, alert in ipairs(activeAlerts) do
        if alert.id == alertId then
            TriggerClientEvent('fists-joblert:setGps', source, alert.coords)
            table.remove(activeAlerts, i)
            break
        end
    end
    TriggerClientEvent('jobAlerts:updateAlerts', -1, activeAlerts)
end)
