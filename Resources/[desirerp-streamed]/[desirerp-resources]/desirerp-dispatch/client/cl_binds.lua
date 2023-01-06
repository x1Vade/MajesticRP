RegisterCommand('+dispatch', function()
    if exports['isPed']:isPed('myjob') == "police" or exports['isPed']:isPed('myjob') == "ems" then
        TriggerEvent('event:control:dispatch')
    end
end)

Citizen.CreateThread(function()
    RegisterKeyMapping("+dispatch", "Open Dispatch Log.", "keyboard", "Z")
end)

RegisterNetEvent('desirerp-dispatch:openDispatch')
AddEventHandler('desirerp-dispatch:openDispatch', function()
    if exports['isPed']:isPed('myjob') == "police" or exports['isPed']:isPed('myjob') == "ems" then
        TriggerEvent('event:control:dispatch')
    end
end)