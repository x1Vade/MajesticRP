local readyPlayers = {}

RegisterServerEvent("np:sync:player:ready")
AddEventHandler("np:sync:player:ready", function()
    local src = source

    readyPlayers[src] = true
end)

RegisterServerEvent("sync:request")
AddEventHandler("sync:request", function(native, playerid, entityid, args)
    if readyPlayers[playerid] then
    TriggerClientEvent("sync:execute", playerid, native, entityid, args)
	end
end)

RegisterServerEvent("sync:execute:aborted")
AddEventHandler("sync:execute:aborted", function(native, netID)
end)

RegisterServerEvent("desirerp-sync:executeSyncNative")
AddEventHandler("desirerp-sync:executeSyncNative", function(native, netEntity, options, args)
    TriggerClientEvent("desirerp-sync:clientExecuteSyncNative", -1, native, netEntity, options, args)
end)