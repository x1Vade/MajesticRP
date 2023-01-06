DPX.Core.hasLoaded = false


function DPX.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent("desirerp-base:playerSessionStarted")
                TriggerServerEvent("desirerp-base:playerSessionStarted")
                break
            end
        end
    end)
end
DPX.Core:Initialize()

AddEventHandler("desirerp-base:playerSessionStarted", function()
    while not DPX.Core.hasLoaded do
        --print("waiting in loop")
        Wait(100)
    end
    ShutdownLoadingScreen()
    DPX.SpawnManager:Initialize()
end)

RegisterNetEvent("desirerp-base:waitForExports")
AddEventHandler("desirerp-base:waitForExports", function()
    if not DPX.Core.ExportsReady then return end

    while true do
        Citizen.Wait(0)
        if exports and exports["desirerp-base"] then
            TriggerEvent("desirerp-base:exportsReady")
            return
        end
    end
end)

RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)

	TriggerEvent("chatMessage","SYSTEM",4,msg)
end)

RegisterNetEvent("base:disableLoading")
AddEventHandler("base:disableLoading", function()
    print("player has spawned ")
    if not DPX.Core.hasLoaded then
         DPX.Core.hasLoaded = true
    end
end)

Citizen.CreateThread( function()
    TriggerEvent("base:disableLoading")
end)

-- Discord Rich Presence --

-- SetDiscordAppId(993156535402381412)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		SetDiscordRichPresenceAsset("desire-circle") 
-- 		SetDiscordRichPresenceAssetText("DesireRP") 
-- 		SetRichPresence("DesireRP | discord.gg/desireroleplay") 
-- 		Wait(5000)
-- 	end
-- end)