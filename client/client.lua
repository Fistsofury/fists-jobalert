
local activeAlerts = {}



RegisterCommand("callpolice", function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('jobAlerts:sendAlert', 'Police', playerCoords)
    TriggerEvent('vorp:TipRight', "You have alerted the police!", 4000)
end, false)

RegisterCommand("calldoctor", function(source, args, rawCommand)
    print("Calling doctor...")  -- Debug print
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('jobAlerts:sendAlert', 'Doctor', playerCoords)
    TriggerEvent('vorp:TipRight', "You have alerted the Doctors", 4000)
end, false)

RegisterCommand("respond", function(source, args, rawCommand)
    IsJob('Doctor', function(isDoctor)
        if isDoctor then
            SetNuiFocus(true, true)
            SendNUIMessage({type = 'openAlerts', alerts = FilterAlerts('Doctor'), jobType = 'Doctor'})
        else
            IsJob('Police', function(isPolice)
                if isPolice then
                    SetNuiFocus(true, true)
                    SendNUIMessage({type = 'openAlerts', alerts = FilterAlerts('Police'), jobType = 'Police'})
                else
                    print("You don't have the required job to respond to alerts.")
                end
            end)
        end
    end)
end, false)



RegisterNetEvent('fists-joblert:updateAlerts')
AddEventHandler('fists-joblert:updateAlerts', function(alerts)
    print("Received updated alerts:", alerts)  -- Debug print
    activeAlerts = alerts
end)

function IsJob(jobName, callback)
    TriggerServerEvent('fists-jobalert:checkJob', jobName)
    RegisterNetEvent('fists-jobalert:returnJobCheck')
    AddEventHandler('fists-jobalert:returnJobCheck', function(result, playerJob)
        print("Player's job:", playerJob, "Required job:", jobName, "Is job:", result)
        callback(result)
    end)
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
    print('Assigned to alert:', data.alertId)
    SetNewWaypoint(data.coords.x, data.coords.y)
    cb('ok')
  end)
  
  RegisterNUICallback('cancelAlert', function(data, cb)
    TriggerServerEvent('fists-joblert:cancelAlert', data.alertId)
    print('Assigned to alert:', data.alertId)
    cb('ok')
end)

RegisterNetEvent('fists-joblert:setGps')
AddEventHandler('fists-joblert:setGps', function(coords)
    -- Set GPS here using VORPutils.Gps:SetGps(x, y, z)
    VORPutils.Gps:SetGps(coords.x, coords.y, coords.z)
end)