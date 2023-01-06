local HotZones = {}

RegisterNetEvent("desirerp-infinity:hotzones:requestList")
AddEventHandler("desirerp-infinity:hotzones:requestList", function()
    local src = source

    TriggerClientEvent("desirerp-infinity:hotzones:updateList", src, HotZones)
end)

RegisterNetEvent("desirerp-infinity:hotzones:enteredZone")
AddEventHandler("desirerp-infinity:hotzones:enteredZone", function(zoneId)
    local src = source

end)

RegisterNetEvent("desirerp-infinity:hotzones:exitZone")
AddEventHandler("desirerp-infinity:hotzones:exitZone", function(zoneId)
    local src = source

end)