local QBCore = exports['qb-core']:GetCoreObject()

local uiOpen = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            -- Toggle engine with Left Shift (control 21)
            if IsControlJustReleased(0, 21) then
                if GetPedInVehicleSeat(veh, -1) == ped then
                    local engOn = GetIsVehicleEngineRunning(veh)
                    SetVehicleEngineOn(veh, not engOn, false, true)
                    if engOn then
                        TriggerEvent('QBCore:Notify', 'Motor apagado', 'error', 2500)
                    else
                        TriggerEvent('QBCore:Notify', 'Motor encendido', 'success', 2500)
                    end
                end
            end
            -- Toggle vehicle control UI with U (control 303)
            if IsControlJustReleased(0, 303) then
                uiOpen = not uiOpen
                SetNuiFocus(uiOpen, uiOpen)
                if uiOpen then
                    SendNUIMessage({ action = 'open' })
                else
                    SendNUIMessage({ action = 'close' })
                end
            end
        else
            -- If not in vehicle, close UI if open
            if uiOpen then
                uiOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ action = 'close' })
            end
        end
    end
end)

-- NUI callback to toggle lights on/off
RegisterNUICallback('toggleLights', function(_, cb)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local lightsOn, highbeamsOn = GetVehicleLightsState(veh)
        -- lightsOn: 1 if low beams, 0 if off; highbeamsOn: 1 if high beams
        if lightsOn == 1 or highbeamsOn == 1 then
            -- turn off
            SetVehicleLights(veh, 1)
        else
            -- turn on
            SetVehicleLights(veh, 2)
        end
    end
    cb('ok')
end)

-- NUI callback to toggle doors/hood/trunk
-- data.door should be number: 0=front left,1=front right,2=back left,3=back right,4=hood,5=trunk
RegisterNUICallback('toggleDoor', function(data, cb)
    local door = tonumber(data.door)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local ratio = GetVehicleDoorAngleRatio(veh, door)
        if ratio > 0.1 then
            SetVehicleDoorShut(veh, door, false)
        else
            SetVehicleDoorOpen(veh, door, false, false)
        end
    end
    cb('ok')
end)

-- NUI callback to close UI from interface
RegisterNUICallback('close', function(_, cb)
    uiOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)
