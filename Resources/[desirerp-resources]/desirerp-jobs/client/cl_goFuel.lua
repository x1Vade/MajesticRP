RegisterNetEvent('desirerp-jobs:goFuelTray1')
AddEventHandler('desirerp-jobs:goFuelTray1', function()
    TriggerEvent("server-inventory-open", "1", "trays-GoFuel Tray 1")
    Wait(1000)
end)

RegisterNetEvent('desirerp-jobs:goFuelTray2')
AddEventHandler('desirerp-jobs:goFuelTray2', function()
    TriggerEvent("server-inventory-open", "1", "trays-GoFuel Tray 2")
    Wait(1000)
end)

exports["desirerp-polytarget"]:AddBoxZone("gofuel_tray_1", vector3(813.53, -782.48, 26.17), 1, 0.8, {
    heading=275,
    minZ=22.57,
    maxZ=26.57
})

exports["desirerp-polytarget"]:AddBoxZone("gofuel_tray_2", vector3(813.42, -781.55, 26.17), 1, 0.8, {
    heading=265,
    minZ=22.57,
    maxZ=26.57
})

exports["desirerp-interact"]:AddPeekEntryByPolyTarget("gofuel_tray_1", {{
    event = "desirerp-jobs:goFuelTray1",
    id = "gofuel_tray_1",
    icon = "hand-holding",
    label = "Open",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
});

exports["desirerp-interact"]:AddPeekEntryByPolyTarget("gofuel_tray_2", {{
    event = "desirerp-jobs:goFuelTray2",
    id = "gofuel_tray_2",
    icon = "hand-holding",
    label = "Open",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
});

exports["desirerp-polytarget"]:AddBoxZone("go_fuel_craft_food", vector3(812.15, -778.35, 26.17), 1, 2.2, {
    heading=270,
    minZ=23.17,
    maxZ=27.17
})

RegisterNetEvent('desirerp-polyzone:enter', function(polyName)
    if polyName == "go_fuel_craft_food" then
        if exports['desirerp-business']:IsEmployedAt('gofuel') then
            canCraftGofuel = true
            exports['desirerp-interface']:showInteraction('[E] Craft')
        end
    end
end)

RegisterNetEvent('desirerp-polyzone:exit', function(polyName)
    if polyName == "go_fuel_craft_food" then
        if exports['desirerp-business']:IsEmployedAt('gofuel') then
            canCraftGofuel = false
            exports['desirerp-interface']:hideInteraction()
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        if canCraftGofuel then
            if IsControlJustReleased(0, 38) then
                if exports['desirerp-business']:IsEmployedAt('gofuel') then
                    TriggerEvent('server-inventory-open', '39', 'Craft')
                end
            end
        end
    end
end)

-- // Stash // --

exports["desirerp-polytarget"]:AddCircleZone("go_fuel_stash", vector3(819.76, -774.56, 26.57), 0.45, {
    useZ=true,
})

exports["desirerp-interact"]:AddPeekEntryByPolyTarget("go_fuel_stash", {{
    event = "desirerp-jobs:goFuelStash",
    id = "go_fuel_stash",
    icon = "box",
    label = "Stash",
    parameters = {},
}}, {
    distance = { radius = 2.5 },
});

RegisterNetEvent('desirerp-jobs:goFuelStash')
AddEventHandler('desirerp-jobs:goFuelStash', function()
    if exports['desirerp-business']:IsEmployedAt('gofuel') then
        TriggerEvent("server-inventory-open", "1", "gofuel-stash")
    end
end)