RegisterNetEvent("np:peds:rogue")
AddEventHandler("np:peds:rogue", function(toDelete)
    local src = source

    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = exports["desirerp-infinity"]:GetNerbyPlayers(coords, 250)

    for i, v in ipairs(players) do
        TriggerClientEvent("np:peds:rogue:delete", v, toDelete)
    end
end)

RegisterNetEvent('np:peds:decor')
AddEventHandler('np:peds:decor', function(pServerId, pNetId)
    if pServerId ~= -1 or pServerId ~= 0 then
        TriggerClientEvent('np:peds:decor:set', pServerId, pNetId, 2, 'ScriptedPed', true)       
    end
end)