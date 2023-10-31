local activeAlerts = {}
local alertIdCounter = 0

RegisterServerEvent('fists-joblert:sendAlert')
AddEventHandler('fists-joblert:sendAlert', function(jobType, coords)
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
    TriggerClientEvent('jobAlerts:updateAlerts', -1, activeAlerts)
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
        local playerJob = exports.vorp_core:vorp_getJob(playerId) --check getjob
        if playerJob.name == jobName then
            table.insert(players, playerId)
        end
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
