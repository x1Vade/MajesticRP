local currentCallSign = ""

RegisterNetEvent("dispatch:setcallsign:cl", function(callsign)
	currentCallSign = callsign
end)

local exlusionZones = {
    {1713.1795654297,2586.6862792969,59.880760192871,250}, -- prison
    {-106.63687896729,6467.7294921875,31.626684188843,45}, -- paleto bank
    {251.21984863281,217.45391845703,106.28686523438,20}, -- city bank
    {-622.25042724609,-230.93577575684,38.057060241699,10}, -- jewlery store
    {2341.91, 2558.8, 46.66,100}, -- Paintball Arena
    {699.91052246094,132.29960632324,80.743064880371,55}, -- power 1
    {2739.5505371094,1532.9992675781,57.56616973877,235}, -- power 2
    {12.53, -1097.99, 29.8, 10}, -- Adam's Apple / Pillbox Weapon shop
    {465.93615722656, -983.60437011719, 30.532375335693} -- MRPD
}

Citizen.CreateThread( function()
    Citizen.Wait(math.random(1000, 10000))
    local origin = false
    local w = `WEAPON_PetrolCan`
    local w1 = `WEAPON_FIREEXTINGUISHER`
    local w2 = `WEAPON_FLARE`
	local w3 = `weapon_snspistol_mk2`
    local curw = GetSelectedPedWeapon(PlayerPedId())
    local armed = false
    local timercheck = 0
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped)
        if not armed then
            if IsPedArmed(ped, 7) and not IsPedArmed(ped, 1) then
                curw = GetSelectedPedWeapon(ped)
                armed = true
                timercheck = 5
            end
        end
  
        if armed then
            if IsPedShooting(ped) and curw ~= w and curw ~= w2 and curw ~= w1 and curw ~= w3 and not origin then
                local inArea = false
                for i,v in ipairs(exlusionZones) do
                    local playerPos = GetEntityCoords(ped)
                    if #(vector3(v[1],v[2],v[3]) - vector3(playerPos.x,playerPos.y,playerPos.z)) < 50 then
                      inArea = true
                    end
                end
                if not inArea then
                    origin = true
                    if IsPedCurrentWeaponSilenced(ped) then
						if math.random(1, 100) >= 95 then
							TriggerEvent('desirerp:alert:gunshot', GetVehiclePedIsIn(PlayerPedId(),false))
						end
                    elseif isInVehicle then
                        TriggerEvent('desirerp:alert:gunshot', GetVehiclePedIsIn(PlayerPedId(),false))
                    else
                        TriggerEvent('desirerp:alert:gunshot', GetVehiclePedIsIn(PlayerPedId(),false))

                    end
  
                    Wait(2200)
                    origin = false
                end
            end
  
            if timercheck == 0 then
                armed = false
            else
                timercheck = timercheck - 1
            end
        else
             Citizen.Wait(2000)
  
        end
    end
end)  

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

-- Downed player alert handler

RegisterNetEvent('civilian:alertPolice')
AddEventHandler("civilian:alertPolice",function(basedistance,alertType)
    if alertType == "death" then
      TriggerEvent('desirerp-dispatch:downplayer')
    end
end)

RegisterNetEvent('desirerp-dispatch:missingOfficer', function()
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-68",
		firstStreet = GetStreetAndZone(pos),
		isImportant = true,
		priority = 3,
		dispatchMessage = '10-68'.. " | Missing Individual",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 84,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- 911

RegisterNetEvent('inf:911:call', function(message)
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "911",
		firstStreet = GetStreetAndZone(),
		isImportant = false,
		priority = 1,
		dispatchMessage = '911'.. " | " .. message,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 792,
			color = 1,
			sound = 'dispatch',
			job = {'police', 'ems'}
		}
	})
end)

-- 311

RegisterNetEvent('inf:311:call', function(message)
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "311",
		firstStreet = GetStreetAndZone(),
		isImportant = false,
		priority = 1,
		dispatchMessage = '311'.. " | " .. message,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 456,
			color = 5,
			sound = 'dispatch',
			job = {'police', 'ems'}
		}
	})
end)

-- 10-13A

RegisterNetEvent('police:tenThirteenA', function()
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-13A",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		isImportant = true,
		priority = 3,
		dispatchMessage = currentCallSign.. " | Officer Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 84,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- 10-13B

RegisterNetEvent('police:tenThirteenB', function()
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-13B",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		isImportant = false,
		priority = 3,
		dispatchMessage = currentCallSign.. " | Officer Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 84,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- PD Panic Button

RegisterNetEvent('police:panic', function()
	TriggerEvent("animation:phonecall")
	local dispatchmessage = currentCallSign .. " | Police Panic"
	if exports['IsPed']:IsPed('myjob') == 'ems' then
		dispatchmessage = currentCallSign .. " | EMS Panic"
	end
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-78",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		isImportant = true,
		priority = 3,
		dispatchMessage = dispatchmessage,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 459,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- EMS 10-14A

RegisterNetEvent('police:tenForteenA', function()
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-14A",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		isImportant = true,
		priority = 3,
		dispatchMessage = currentCallSign.. " | Medic Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 84,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- EMS 10-14B

RegisterNetEvent('police:tenForteenB', function()
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("desirerp-dispatch:sendNotifi", {
		dispatchCode = "10-14B",
		firstStreet = GetStreetAndZone(),
		callSign = currentCallSign,
		isImportant = false,
		priority = 3,
		dispatchMessage = currentCallSign.. " | Medic Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 84,
			color = 1,
			sound = 'polalert',
			job = {'police', 'ems'}
		}
	})
end)

-- Vehicle Theft

RegisterNetEvent('desirerp:alert:vehtheft', function(veh)
	local pos = GetEntityCoords(PlayerPedId(), true)
	local plate = 'Not Found'
    if math.random(1, 3) then
        plate = GetVehicleNumberPlateText(veh, false)
    end
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-60',
		firstStreet = GetStreetAndZone(),
		plate = plate,
		isImportant = false,
		priority = 1,
		dispatchMessage = "Vehicle Theft | " .. plate,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 488,
			color = 1,
			sound = 'dispatch',
			job = {'police'}
		}
	})
end)

-- Gun shots
RegisterNetEvent('desirerp:alert:gunshot', function(veh)
	local pos = GetEntityCoords(PlayerPedId(), true)
	local plate = 'Not Found'
    if math.random(1, 3) then
        plate = GetVehicleNumberPlateText(veh, false)
    end
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-71',
		firstStreet = GetStreetAndZone(),
		plate = plate,
		isImportant = false,
		priority = 1,
		dispatchMessage = "Shots Fired",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 110,
			color = 1,
			-- sound = 'dispatch',
			job = {'police'}
		}
	})
end)

-- Investigage Suspicious Activity
RegisterNetEvent('desirerp-dispatch:investigate', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-37',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Investigate Suspicious Activity",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 102,
			color = 1,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- ATM Robbery
RegisterNetEvent('desirerp-dispatch:atmrobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "ATM Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 488,
			color = 1,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Downed Person
RegisterNetEvent('desirerp-dispatch:downplayer', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-47',
		firstStreet = GetStreetAndZone(),
		isImportant = false,
		priority = 1,
		dispatchMessage = "Injured Person",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 126,
			color = 18,
			sound = 'dispatch',
			job = {'police', 'ems'}
		}
	})
end)

-- Store Robbery
RegisterNetEvent('desirerp-dispatch:storerobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-31B',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Store Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 52,
			color = 1,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- House Robbery
RegisterNetEvent('desirerp-dispatch:houserobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-31A',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "House Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 411,
			color = 1,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Bank Truck
RegisterNetEvent('desirerp-dispatch:banktruckrobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Bank Truck",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 477,
			color = 76,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Jewelry Robbery
RegisterNetEvent('desirerp-dispatch:jewelrobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Jewelry Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 487,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- desirerp-dispatch:TrainHeist

RegisterNetEvent('desirerp-dispatch:TrainHeist', function(coords)
	local pos = coords
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Train Heist",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 795,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Jewelry Power
RegisterNetEvent('infinite:power:hit-jewelry', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Jewelry Robbery Blackout",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 487,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Pacific Bank
RegisterNetEvent('desirerp-dispatch:pacific-robbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Pacific Bank Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 487,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Bay City Bank
RegisterNetEvent('desirerp-dispatch:bay-city-bank', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Bay City Bank Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 500,
			color = 4,
			sound = 'bankalarm',
			job = {'police'}
		}
	})
end)

-- Businesss Panic Alarm
RegisterNetEvent('desirerp-dispatch:businessPanicAlarm', function(pAlertData)
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-31A',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = pAlertData,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 59,
			color = 4,
			sound = 'bankalarm',
			job = {'police'}
		}
	})
end)

-- Drug Sale
RegisterNetEvent('desirerp-dispatch:drug-sale', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-35',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Drug Sale Reported",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 486,
			color = 1,
			sound = 'bankalarm',
			job = {'police'}
		}
	})
end)

-- Fleeca Robbery
RegisterNetEvent('desirerp-dispatch:bankrobbery', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Fleeca Bank Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 80,
			color = 2,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Jail Break
RegisterNetEvent('desirerp-dispatch:jailbreak', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-98',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Jail Break",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 134,
			color = 1,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Clock On
RegisterNetEvent('desirerp-dispatch:clockon', function()
	TriggerServerEvent('desirerp-callsign:sv')
	Citizen.Wait(500)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-41',
		firstStreet = GetStreetAndZone(),
		isImportant = false,
		priority = 1,
		dispatchMessage = currentCallSign .. " is going 10-41",
		origin = {
			x = 0,
			y = 0,
			z = 0,
			sprite = 134,
			color = 1,
			sound = 'dispatch',
			job = {'police', 'ems'}
		}
	})
end)

-- Boosting Call
RegisterNetEvent('desirerp-dispatch:boosting', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local plate = "Not Found"
	if math.random(1, 3) == 3 then
		plate = GetVehicleNumberPlateText(veh)
	end
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-99',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Vehicle Boosting In Progress | " .. plate,
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 134,
			color = 1,
			sound = 'dispatch',
			job = {'police'}
		}
	})
end)

-- Paleto Bank
RegisterNetEvent('desirerp-dispatch:paletobank', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Paleto Bank Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 80,
			color = 2,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Power (Big Bank + Paleto)
RegisterNetEvent('desirerp-dispatch:alert-power', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Power Blackout",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 487,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

-- Bobcat Robbery
RegisterNetEvent('desirerp-dispatch:bobcat', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Bob Cat Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 487,
			color = 4,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

RegisterNetEvent('desirerp-dispatch:bigbank', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('desirerp-dispatch:sendNotifi', {
		dispatchCode = '10-90',
		firstStreet = GetStreetAndZone(),
		isImportant = true,
		priority = 1,
		dispatchMessage = "Big Bank Robbery",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z,
			sprite = 80,
			color = 2,
			sound = 'bankalarm',
			job = {'police', 'news'}
		}
	})
end)

function GetStreetAndZone(pos)
	local plyPos = GetEntityCoords(PlayerPedId(), true)
	if pos ~= nil then plyPos = pos end
	local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street1 = GetStreetNameFromHashKey(s1)
	local street2 = GetStreetNameFromHashKey(s2)
	local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
	local street = street1 .. ", " .. zone
	return street
end