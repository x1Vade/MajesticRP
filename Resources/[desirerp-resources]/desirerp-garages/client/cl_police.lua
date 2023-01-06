local nearBuy = false

Citizen.CreateThread(function()
    exports["desirerp-polyzone"]:AddBoxZone("police_buy", vector3(442.92, -973.83, 25.7), 3, 3, {
        name="police_buy",
        heading=310,
        --debugPoly=true,
        minZ=22.5,
        maxZ=26.5
    }) 
end)

RegisterNetEvent('desirerp-polyzone:enter')
AddEventHandler('desirerp-polyzone:enter', function(name)
    if name == "police_buy" then
		local job = exports["isPed"]:isPed("myJob")
		if job == 'police' then
            nearBuy = true
            AtPoliceBuy()
            exports["desirerp-interface"]:showInteraction("[E] Buy Vehicle")
        end
    end
end)

RegisterNetEvent('desirerp-polyzone:exit')
AddEventHandler('desirerp-polyzone:exit', function(name)
    if name == "police_buy" then
        nearBuy = false
    end
    exports["desirerp-interface"]:hideInteraction()
end)

function AtPoliceBuy()
	Citizen.CreateThread(function()
        while nearBuy do
            Citizen.Wait(5)
            local plate = GetVehicleNumberPlateText(vehicle)
            local job = exports["isPed"]:isPed("myJob")
            if job == 'police' then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('desirerp-garages:openBuyMenu')
                end
            end
        end
    end)
end

RegisterNetEvent('desirerp-garages:openBuyMenu')
AddEventHandler('desirerp-garages:openBuyMenu', function()
    local HeistEquipment = {
		{
            title = "Crown Vic",
            description = "Purchase Crown Vic $5000",
            children ={
                {
                    title = "Are you sure ?",
                },
                {
                    title = "Yes",
                    action = "desirerp-garages:PurchaseVic",
                },
                {
                    title = "No",
                    action = "desirerp-garages:PD_Nope",
                },
            }
        },
        {
            title = "Ranger Blazer",
            description = "Purchase Ranger Blazer $10,000",
            children ={
                {
                    title = "Are you sure ?",
                },
                {
                    title = "Yes",
                    action = "desirerp-garages:PurchaseBlazer",
                },
                {
                    title = "No",
                    action = "desirerp-garages:PD_Nope",
                },
            }
        },
        {
            title = "Explorer",
            description = "Purchase Explorer $15,000",
            children ={
                {
                    title = "Are you sure ?",
                },
                {
                    title = "Yes",
                    action = "desirerp-garages:PurchaseExplorer",
                },
                {
                    title = "No",
                    action = "desirerp-garages:PD_Nope",
                },
            }
        },
        {
            title = "Charger",
            description = "Purchase Charger $30,000",
            children ={
                {
                    title = "Are you sure ?",
                },
                {
                    title = "Yes",
                    action = "desirerp-garages:PurchaseCharger",
                },
                {
                    title = "No",
                    action = "desirerp-garages:PD_Nope",
                },
            }
        },
        {
            title = "Bike",
            description = "Purchase Bike $15,000",
            children ={
                {
                    title = "Are you sure ?",
                },
                {
                    title = "Yes",
                    action = "desirerp-garages:PurchaseBike",
                },
                {
                    title = "No",
                    action = "desirerp-garages:PD_Nope",
                },
            }
        },
    }
    exports["desirerp-interface"]:showContextMenu(HeistEquipment)
end)

RegisterInterfaceCallback('desirerp-garages:PD_Nope', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
end)

RegisterInterfaceCallback('desirerp-garages:PurchaseVic', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    if exports["isPed"]:isPed("mycash") >= 5000 then
        --TriggerServerEvent('banking:removeMoney', 5000)
        TriggerServerEvent('yorktax:vic')
        TriggerEvent('desirerp-garages:PurchasedVeh', 'Crown Vic', 'npolvic', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterInterfaceCallback('desirerp-garages:PurchaseBlazer', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    if exports["isPed"]:isPed("mycash") >= 10000 then
        --TriggerServerEvent('banking:removeMoney', 10000)
        TriggerServerEvent('yorktax:blazer')
        TriggerEvent('desirerp-garages:PurchasedVeh', 'Ranger QuadBike', 'npolblazer', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterInterfaceCallback('desirerp-garages:PurchaseExplorer', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    if exports["isPed"]:isPed("mycash") >= 15000 then
        --TriggerServerEvent('banking:removeMoney', 15000)
        TriggerServerEvent('yorktax:exp')
        TriggerEvent('desirerp-garages:PurchasedVeh', 'Ford Explorer', 'npolexp', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterInterfaceCallback('desirerp-garages:PurchaseBike', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    if exports["isPed"]:isPed("mycash") >= 15000 then
        --TriggerServerEvent('banking:removeMoney', 15000)
        TriggerServerEvent('yorktax:mm')
        TriggerEvent('desirerp-garages:PurchasedVeh', 'Police Bike', 'npolmm', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterInterfaceCallback('desirerp-garages:PurchaseCharger', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    if exports["isPed"]:isPed("mycash") >= 30000 then
        --TriggerServerEvent('banking:removeMoney', 30000)
        TriggerServerEvent('yorktax:char')
        TriggerEvent('desirerp-garages:PurchasedVeh', 'Police Charger', 'npolchar', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedGDbzcom')
AddEventHandler('desirerp-garages:PurchasedGDbzcom', function()
    if exports["isPed"]:isPed("mycash") >= 40000 then
        TriggerServerEvent('banking:removeMoney', 40000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'GD Holden BZ Commodore', 'NSWZBS', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWPe63')
AddEventHandler('desirerp-garages:PurchasedHWPe63', function()
    if exports["isPed"]:isPed("mycash") >= 40000 then
        TriggerServerEvent('banking:removeMoney', 40000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Mercedes-benz E63', 'fatale63', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWPgts')
AddEventHandler('desirerp-garages:PurchasedHWPgts', function()
    if exports["isPed"]:isPed("mycash") >= 45000 then
        TriggerServerEvent('banking:removeMoney', 45000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Holden GTS', 'HWPGTS', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWP530d')
AddEventHandler('desirerp-garages:PurchasedHWP530d', function()
    if exports["isPed"]:isPed("mycash") >= 45000 then
        TriggerServerEvent('banking:removeMoney', 45000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP BMW 530D', 'hwy21', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWPbike')
AddEventHandler('desirerp-garages:PurchasedHWPbike', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Yamaha 1300', 'hwpbike', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWvfss')
AddEventHandler('desirerp-garages:PurchasedHWvfss', function()
    if exports["isPed"]:isPed("mycash") >= 55000 then
        TriggerServerEvent('banking:removeMoney', 55000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Holden VF SS', 'hwpvf2', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWP300c')
AddEventHandler('desirerp-garages:PurchasedHWP300c', function()
    if exports["isPed"]:isPed("mycash") >= 60000 then
        TriggerServerEvent('banking:removeMoney', 60000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Chrysler 300c', 'hwpsrtcore', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedHWPhellcat')
AddEventHandler('desirerp-garages:PurchasedHWPhellcat', function()
    if exports["isPed"]:isPed("mycash") >= 65000 then
        TriggerServerEvent('banking:removeMoney', 65000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Dodge Charger', 'hellcatRB', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedPORSlandcruiser')
AddEventHandler('desirerp-garages:PurchasedPORSlandcruiser', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'PORS Toyota Landcruiser', 'PORSLandy', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedPORSriot')
AddEventHandler('desirerp-garages:PurchasedPORSriot', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'PORS Armored Truck', 'riot', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedUCstinger')
AddEventHandler('desirerp-garages:PurchasedUCstinger', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP Kia Stinger', 'h1stinger', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedUC530d')
AddEventHandler('desirerp-garages:PurchasedUC530d', function()
    if exports["isPed"]:isPed("mycash") >= 60000 then
        TriggerServerEvent('banking:removeMoney', 60000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'HWP BMW 530D', 'UM21', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedUCzb')
AddEventHandler('desirerp-garages:PurchasedUCzb', function()
    if exports["isPed"]:isPed("mycash") >= 60000 then
        TriggerServerEvent('banking:removeMoney', 60000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'UC Holden ZB Commodore', 'NSWZBSUM', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedUClandcruiser')
AddEventHandler('desirerp-garages:PurchasedUClandcruiser', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'UC Toyota Landcruiser', 'UCLandcruiser', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

RegisterNetEvent('desirerp-garages:PurchasedUCprado')
AddEventHandler('desirerp-garages:PurchasedUCprado', function()
    if exports["isPed"]:isPed("mycash") >= 50000 then
        TriggerServerEvent('banking:removeMoney', 50000)
        TriggerEvent('desirerp-garages:PurchasedVeh', 'UC Toyota Prado', 'NSWPrado', '0')
    else
        TriggerEvent('DoLongHudText', "You do not have enough money!", 2)
    end
end)

    

RegisterNetEvent('desirerp-garages:PurchasedVeh')
AddEventHandler('desirerp-garages:PurchasedVeh', function(name, veh, price)
    local ped = PlayerPedId()
    local name = name    
    local vehicle = veh
    local price = price        
    local model = veh
    local colors = table.pack(GetVehicleColours(veh))
    local extra_colors = table.pack(GetVehicleExtraColours(veh))

    local mods = {}

    for i = 0,24 do
        mods[i] = GetVehicleMod(veh,i)
    end

    FreezeEntityPosition(ped,false)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    personalvehicle = CreateVehicle(model,435.80545043945, -975.96203613281, 25.699991226196,88.239898681641,true,false)
    SetEntityHeading(personalvehicle, 88.239898681641)
    SetModelAsNoLongerNeeded(model)

    for i,mod in pairs(mods) do
        SetVehicleModKit(personalvehicle,0)
        SetVehicleMod(personalvehicle,i,mod)
    end

    SetVehicleOnGroundProperly(personalvehicle)

    local plate = GetVehicleNumberPlateText(personalvehicle)
    SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
    SetNetworkIdCanMigrate(id, true)
    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
    SetVehicleColours(personalvehicle,colors[1],colors[2])
    SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
    SetEntityVisible(ped,true)            
    local primarycolor = colors[1]
    local secondarycolor = colors[2]    
    local pearlescentcolor = extra_colors[1]
    local wheelcolor = extra_colors[2]
    --local VehicleProps = exports['desirerp-base']:FetchVehProps(personalvehicle)
    local model = GetEntityModel(personalvehicle)
    local vehname = GetDisplayNameFromVehicleModel(model)
    TriggerEvent("keys:addNew",personalvehicle, plate)
    TriggerServerEvent('desirerp-garages:FinalizedPur', plate, name, vehicle, price)
    Citizen.Wait(100)
    exports['desirerp-textui']:hideInteraction()
end)

RegisterNetEvent('PDSpawnVeh33')
AddEventHandler('PDSpawnVeh33', function()
	TriggerEvent('desirerp-context:sendMenu', {
        {
            id = 1,
            header = "Police Garage",
            txt = ""
        },
        {
            id = 2,
            header = "PolAir",
			txt = "Eye in the sky",
			params = {
                event = "spawn:veh:pd33",
				args = {
					vehicle = "maverick2"
				}
            }
        },
	
    })
end)

RegisterNetEvent('spawn:veh:pd33')
AddEventHandler('spawn:veh:pd33', function(type)
	SpawnVehPD33(type.vehicle)	
end)

function SpawnVehPD33(name)
	Citizen.CreateThread(function()

        local hash = GetHashKey(name)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

		local spawnLocation = findClosestSpawnPointPD33(GetEntityCoords(PlayerPedId()))
		local getVehicleInArea = GetClosestVehicle(spawnLocation, 3.000, 0, 70)
		if DoesEntityExist(getVehicleInArea) then
		  TriggerEvent("DoLongHudText", "The area is crowded", 2)
		  return
		end

        local vehicle = CreateVehicle(hash, 449.27819824219, -981.24462890625, 43.691368103027, 353.6337890625, true, false)

        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("keys:addNew",vehicle,plate)
        SetModelAsNoLongerNeeded(hash)
        applyMaxUpgrades(vehicle)
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
        LastVehicle = vehicle
    end)
end

function applyMaxUpgrades(veh)
	SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, 11, 3, false)
    SetVehicleMod(veh, 12, 2, false)
    SetVehicleMod(veh, 13, 2, false)
    SetVehicleMod(veh, 15, 3, false)
    SetVehicleMod(veh, 16, 4, false)
end

function findClosestSpawnPointPD33(pCurrentPosition)
	local coords = vector3(449.27819824219, -981.24462890625, 43.691368103027)
	local closestDistance = -1
	local closestCoord = pCurrentPosition
	local distance = #(coords - pCurrentPosition)
	if closestDistance == -1 or closestDistance > distance then
	  closestDistance = distance
	  closestCoord = coords
	end
	return closestCoord
end