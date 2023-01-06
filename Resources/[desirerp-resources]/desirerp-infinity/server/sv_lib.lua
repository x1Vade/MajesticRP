

RegisterServerEvent('np:infinity:player:ready')
AddEventHandler('np:infinity:player:ready', function()
    local ting = GetEntityCoords(GetPlayerPed(source))
    
    TriggerClientEvent('np:infinity:player:coords', -1, ting)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local ting = GetEntityCoords(source)

        TriggerClientEvent('np:infinity:player:coords', -1, ting)
        TriggerEvent("desirerp-fw:updatecoords", ting.x, ting.y, ting.z)
        --print("[^2desirerp-infinity^0]^3 Sync Successful.^0")
    end
end)