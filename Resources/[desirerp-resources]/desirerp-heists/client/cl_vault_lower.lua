local firstlowerdoor = false
local firstpindoor = false
local secpindoor = false
local thirdpindoor = false
local fourthpindoor = false
local vaultdoor = false
local laptoppin = false


----- lower vault start lol

RegisterNetEvent('desirerp-vault:startlowervault')
AddEventHandler('desirerp-vault:startlowervault', function()
    local player = GetEntityCoords(PlayerPedId())
    local distance = #(vector3(272.08557, 231.21812, 97.683708) - player)
    local pd = RPC.execute("desirerp-police:getActiveUnits")
    if pd >= 4 then
        if distance < 1.5 then
            if exports["desirerp-inventory"]:hasEnoughOfItem("heistlaptop4", 1) then
                TriggerEvent('desirerp-dispatch:pacific-robbery')
                -- if exports['desirerp-blackout']:Blackout() then
                    StartLowerVaultKid()
                    TriggerEvent('desirerp-dispatch:bankrobbery')
                    exports['desirerp-hacking']:hacking(
                        function()
                            ClearPedTasksImmediately(PlayerPedId())
                            TriggerEvent('desirerp-heists:lower_vault_done')
                            DeleteObject(bag)
                            DeleteObject(laptop)
                            FreezeEntityPosition(ped, false)
                        end,
                        function()
                        ClearPedTasksImmediately(PlayerPedId())
                    end)
                    TriggerEvent("inventory:removeItem", "heistlaptop4", 1)
                    Citizen.Wait(1000)
                -- end 
            end
        end
    else
        TriggerEvent('DoLongHudText', 'Not enough cops on duty.')
    end
end)


RegisterNetEvent('desirerp-heists:lower_vault_done')
AddEventHandler('desirerp-heists:lower_vault_done', function()
    TriggerServerEvent('desirerp-doors:change-lock-state', 278, false) 
    TriggerServerEvent("desirerp-doors:change-lock-state", 279, false)
end)



RegisterNetEvent('zyloz:createCrates')
AddEventHandler('zyloz:createCrates', function(toggle)
    if toggle == true then
     weaponbox = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 296.67828369141, 211.29058837891, 96.688102722168, true,  true, true)
    CreateObject(weaponbox)
    SetEntityHeading(weaponbox, 186.12)
    FreezeEntityPosition(weaponbox, true)

     weaponbox3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 308.09204101563, 216.22746276855, 96.688110351563, true,  true, true)
    CreateObject(weaponbox3)
    SetEntityHeading(weaponbox3, 219.52)
    FreezeEntityPosition(weaponbox3, true) 

     weaponbox4 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 303.46594238281, 229.1854095459, 96.688110351563, true,  true, true)
    CreateObject(weaponbox4)
    SetEntityHeading(weaponbox4, 291.02)
    FreezeEntityPosition(weaponbox4, true)

    weaponbox5 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), 303.01165771484, 217.92240905762, 96.688087463379, true,  true, true)  
    CreateObject(weaponbox5)
    SetEntityHeading(weaponbox5, 291.02)
    FreezeEntityPosition(weaponbox5, true)

    goldcrate = CreateObject(GetHashKey("ch_prop_gold_trolly_01c"), 296.213134334, 217.598383434, 96.688194343, true,  true, true)  -- vector3(296.2131, 217.59838, 97.688194)
    CreateObject(goldcrate)
    SetEntityHeading(goldcrate, 291.02)
    FreezeEntityPosition(goldcrate, true)

    goldcrate2 = CreateObject(GetHashKey("ch_prop_gold_trolly_01c"), 296.4403418, 224.3234734, 96.688194343, true,  true, true)  -- vector3(296.2131, 217.59838, 97.688194)
    CreateObject(goldcrate2)
    SetEntityHeading(goldcrate2, 291.02)
    FreezeEntityPosition(goldcrate2, true)  


    elseif toggle == false then
        DeleteObject(weaponbox)
        DeleteObject(weaponbox4)
        DeleteObject(weaponbox3)
        DeleteObject(weaponbox5)
    end
end)

function CreatenzylozCrates()
    local ped = PlayerPedId()

    TriggerEvent('nicx:CleanClientVaultD')
    TriggerEvent("zyloz:createCrates" ,true)
  end


  RegisterNetEvent('desirerp-vault:startlowervault')
  AddEventHandler('desirerp-vault:startlowervault', function()
    local player = GetEntityCoords(PlayerPedId())
    local distance = #(vector3(279.85586, 231.04055, 97.182815) - player)
    if distance < 1.5 then
        exports['desirerp-vault']:OpenVaultGame(function(success)
    if success then
        TriggerServerEvent("desirerp-doors:change-lock-state", 325, false)
        print("280")  
    else
        TriggerEvent('phone:addJobNotify', "YOU FUCKED UP THE HACK")
    end
  end, 10, 10)
end 
end)
 

exports["desirerp-polyzone"]:AddBoxZone("vault_lower_entrance", vector3(266.01, 231.64, 97.68), 5.2, 13.4, {
    name="vault_lower_entrance",
    heading=340,
    --debugPoly=true,
    minZ=96.48,
    maxZ=99.88
})


RegisterNetEvent('desirerp-vault:closevaultlower')
AddEventHandler('desirerp-vault:closevaultlower', function()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vaultmilo")

    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)

    EnableInteriorProp(interiorid, "np_vault_clean")
    DisableInteriorProp(interiorid, "np_vault_broken")
    DisableInteriorProp(interiorid, "np_vault_blocked")

    RefreshInterior(interiorid)
end)

RegisterNetEvent('desirerp-vault:blockedvaultlower')
AddEventHandler('desirerp-vault:blockedvaultlower', function()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vaultmilo")

    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)

    EnableInteriorProp(interiorid, "np_vault_clean")
    DisableInteriorProp(interiorid, "np_vault_broken")
    EnableInteriorProp(interiorid, "np_vault_blocked")

    RefreshInterior(interiorid)
end)

RegisterNetEvent('desirerp-vault:openvaultlower')
AddEventHandler('desirerp-vault:openvaultlower', function()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vaultmilo")

    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)

    DisableInteriorProp(interiorid, "np_vault_clean")
    EnableInteriorProp(interiorid, "np_vault_broken")
    DisableInteriorProp(interiorid, "np_vault_blocked")

    RefreshInterior(interiorid)
end)



Citizen.CreateThread(function()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vaultmilo")

    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)

    EnableInteriorProp(interiorid, "np_vault_clean")
    DisableInteriorProp(interiorid, "np_vault_broken")
    DisableInteriorProp(interiorid, "np_vault_blocked")

    RefreshInterior(interiorid)
end)

function refreshVaultDoor()
    RequestIpl("np_int_placement_ch_interior_6_dlc_casino_vaultmilo")
    local interiorid = GetInteriorAtCoords(259.2812, 203.5071, 96.77954)
    for k, s in pairs(bicBoiVaultDoorStates) do
        DisableInteriorProp(interiorid, k)
    end
    for k, s in pairs(bicBoiVaultDoorStates) do
        if s then
            EnableInteriorProp(interiorid, k)
        end
    end
    RefreshInterior(interiorid)

    RequestIpl("hei_hw1_02_interior_2_heist_ornate_bankmilo")
    interiorid = GetInteriorAtCoords(247.913, 218.042, 105.283)
    for k, s in pairs(upperVaultEntityState) do
      DisableInteriorProp(interiorid, k)
    end
    for k, s in pairs(upperVaultEntityState) do
      if s then
        EnableInteriorProp(interiorid, k)
      end
    end
    RefreshInterior(interiorid)
end



RegisterNetEvent('desirerp-vault:openvaultdoor_ITSLOWER')
AddEventHandler('desirerp-vault:openvaultdoor_ITSLOWER', function()
    TriggerEvent('desirerp-vault:openvaultlower')
end)


RegisterNetEvent('desirerp-vaultrob:lower:vaultdoor')
AddEventHandler('desirerp-vaultrob:lower:vaultdoor', function(s, args)
    local ped = PlayerPedId()
    local PLAYER_COORDS = GetEntityCoords(ped)
    local vaultdoorlowerlocation = vector3(284.13, 223.26, 98.24)
    if #(PLAYER_COORDS - vaultdoorlowerlocation) < 20.0 and not vaultdoor then
        vaultdoor = true
        AddExplosion(284.13, 223.26, 98.24, 37, 150000.0, true, false, 4.0)
        TriggerEvent('desirerp-vault:openvaultdoor_ITSLOWER')
        CreatenzylozCrates()
        Wait(1800000)
        TriggerEvent("desirerp-vault:LOWERVAULT_REFRESH")
    end
end)

RegisterNetEvent("desirerp-vault:LOWERVAULT_REFRESH")
AddEventHandler("vault:LOWERVAULT_REFRESH", function()
    laptoppin = false
    firsttrolleylower = false
    sectrolleylower = false
    thirddlowertrolley = false
    fourthtrolleylower = false
    fifthtrolleylower = false
    sixthtrolleylower = false
    trolleyleryerinemi = false
    sextrolley = false

    if firstlowerdoor then
        TriggerServerEvent("shx-doors:alterlockstate", 120)
        TriggerServerEvent("shx-doors:alterlockstate", 121)
    end

    if vaultdoor then
        vaultdoor = false
        TriggerEvent('desirerp-vault:blockedvaultlower')
        Citizen.Wait(900000)
        TriggerEvent('desirerp-vault:closevaultlower')
    end

    if firstpindoor and secpindoor and thirdpindoor and fourthpindoor then
        TriggerServerEvent("desirerp-doors:change-lock-state", 325, false)
    end
    Wait(2000)
    vaultdoor = false
    firstlowerdoor = false
    firstpindoor = false
    secpindoor = false
    thirdpindoor = false
    fourthpindoor = false  
    DeleteObject(Trolley1)
	while DoesEntityExist(Trolley1) do
        Citizen.Wait(1)
        DeleteObject(Trolley1)
	end

	DeleteObject(Trolley2)
	while DoesEntityExist(Trolley2) do
        Citizen.Wait(1)
        DeleteObject(Trolley2)
	end

	DeleteObject(Trolley3)
	while DoesEntityExist(Trolley3) do
        Citizen.Wait(1)
        DeleteObject(Trolley3)
	end
	DeleteObject(Trolley4)
	while DoesEntityExist(Trolley4) do
        Citizen.Wait(1)
        DeleteObject(Trolley4)
	end

	DeleteObject(Trolley5)
	while DoesEntityExist(Trolley5) do
        Citizen.Wait(1)
        DeleteObject(Trolley5)
	end

	DeleteObject(Trolley6)
	while DoesEntityExist(Trolley6) do
        Citizen.Wait(1)
        DeleteObject(Trolley6)
	end
end)

RegisterNetEvent("desirerp-vaultrob:lower:fourpincontrol")
AddEventHandler("desirerp-vaultrob:lower:fourpincontrol", function()
    if firstpindoor then
        if secpindoor then
            if thirdpindoor then
                if fourthpindoor then
                    TriggerServerEvent("desirerp-doors:change-lock-state", 325, false)
                    print('all completed')
                else
                    print('not all completed')
                end
            else
                print('not all completed')
            end
        else
            print('not all completed')
        end
    else
        print('not all completed')
    end
end)


RegisterNetEvent('desirerp-vaultrob:lower:firstpindoor')
AddEventHandler('desirerp-vaultrob:lower:firstpindoor', function()
    if not firstpindoor  then
        exports['desirerp-vault']:OpenVaultGame(function(success)
            if success then
                firstpindoor = true
                TriggerEvent("desirerp-vaultrob:lower:fourpincontrol")
            else
                firstpindoor = false
            end
        end, 5, 5)
    else 
        print('Already hacked!')
    end
end)

RegisterNetEvent('desirerp-vaultrob:lower:secpindoor')
AddEventHandler('desirerp-vaultrob:lower:secpindoor', function()
    if not secpindoor then
        exports['desirerp-vault']:OpenVaultGame(function(success)
            if success then
                secpindoor = true
                TriggerEvent("desirerp-vaultrob:lower:fourpincontrol")
            else
                secpindoor = false
            end
        end, 5, 5)
    else 
        print('Already hacked!')
    end
end)

RegisterNetEvent('desirerp-vaultrob:lower:thirdpindoor')
AddEventHandler('desirerp-vaultrob:lower:thirdpindoor', function()
    if not thirdpindoor then
        exports['desirerp-vault']:OpenVaultGame(function(success)
            if success then
                thirdpindoor = true
                TriggerEvent("desirerp-vaultrob:lower:fourpincontrol")
            else
                thirdpindoor = false
            end
        end, 5, 5)
    else 
        print('Already hacked!')
    end
end)

RegisterNetEvent('desirerp-vaultrob:lower:fourthpindoor')
AddEventHandler('desirerp-vaultrob:lower:fourthpindoor', function()
    if not fourthpindoor then
        exports['desirerp-vault']:OpenVaultGame(function(success)
            if success then
                fourthpindoor = true
                TriggerEvent("desirerp-vaultrob:lower:fourpincontrol")
            else
                fourthpindoor = false
            end
        end, 5, 5)
    end
end)
