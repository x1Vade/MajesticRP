RegisterNetEvent('desirerp-casino:giveChipsCL')
AddEventHandler('desirerp-casino:giveChipsCL', function(pAmt)
    TriggerServerEvent('desirerp-casino:giveChips', pAmt)
end)

RegisterNetEvent('desirerp-casino:removeChipsCL')
AddEventHandler('desirerp-casino:removeChipsCL', function(removeAmt)
    TriggerServerEvent('desirerp-casino:removeChips', removeAmt)
end)