local activeAlerts = {}

RegisterCommand("calldoctor", function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('jobAlerts:sendAlert', 'Doctor', playerCoords)
end, false)

RegisterCommand("callpolice", function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('jobAlerts:sendAlert', 'Police', playerCoords)
end, false)

RegisterCommand("respond", function(source, args, rawCommand)
    if IsJob('Doctor') then
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'openAlerts', alerts = FilterAlerts('Doctor'), jobType = 'Doctor'})
    elseif IsJob('Police') then
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'openAlerts', alerts = FilterAlerts('Police'), jobType = 'Police'})
    else
        print("You don't have the required job to respond to alerts.")
    end
end, false)

RegisterNetEvent('fists-joblert:updateAlerts')
AddEventHandler('fists-joblert:updateAlerts', function(alerts)
    activeAlerts = alerts
end)

function IsJob(jobType)
    local playerJob = exports.vorp_core:vorp_getJob() -- check get job
    local jobNames = Config[jobType..'Jobs']
    if jobNames then
        for _, jobName in pairs(jobNames) do
            if playerJob.name == jobName then
                return true
            end
        end
    end
    return false
end

function FilterAlerts(jobType)
    local filteredAlerts = {}
    for _, alert in pairs(activeAlerts) do
        if alert.jobType == jobType then
            table.insert(filteredAlerts, alert)
        end
    end
    return filteredAlerts
end
RegisterNUICallback('assignAlert', function(data, cb)
    TriggerServerEvent('fists-joblert:respondToAlert', data.alertId)
    SetNewWaypoint(data.coords.x, data.coords.y)
    cb('ok')
  end)
  
  RegisterNUICallback('cancelAlert', function(data, cb)
    TriggerServerEvent('fists-joblert:cancelAlert', data.alertId)
    cb('ok')
end)

RegisterNetEvent('fists-joblert:setGps')
AddEventHandler('fists-joblert:setGps', function(coords)
    -- Set GPS here using VORPutils.Gps:SetGps(x, y, z)
    VORPutils.Gps:SetGps(coords.x, coords.y, coords.z)
end)