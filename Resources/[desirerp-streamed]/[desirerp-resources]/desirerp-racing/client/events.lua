previewEnabled = false
local usedItemId, usedItemSlot, usedItemMetadata

RegisterNetEvent("desirerp-racing:addedActiveRace")
AddEventHandler("desirerp-racing:addedActiveRace", function(race)
    print("ADDING ACTIVE RACE")
    activeRaces[race.id] = race

    if not config.nui.hudOnly then
        SendNUIMessage({
            activeRaces = activeRaces
        })
    end

    TriggerEvent("desirerp-racing:api:addedActiveRace", race, activeRaces)
    TriggerEvent("desirerp-racing:api:updatedState", { activeRaces = activeRaces })
end)

RegisterNetEvent("desirerp-racing:removedActiveRace")
AddEventHandler("desirerp-racing:removedActiveRace", function(id)
    print("REMOVE ACTIVE RACE")
    activeRaces[id] = nil

    if not config.nui.hudOnly then
        SendNUIMessage({
            activeRaces = activeRaces
        })
    end

    TriggerEvent("desirerp-racing:api:removedActiveRace", activeRaces)
    TriggerEvent("desirerp-racing:api:updatedState", { activeRaces = activeRaces })
end)

RegisterNetEvent("desirerp-racing:updatedActiveRace")
AddEventHandler("desirerp-racing:updatedActiveRace", function(race)
    if activeRaces[race.id] then
        activeRaces[race.id] = race
    end

    if not config.nui.hudOnly then
        SendNUIMessage({
            activeRaces = activeRaces
        })
    end

    TriggerEvent("desirerp-racing:api:updatedActiveRace", activeRaces)
    TriggerEvent("desirerp-racing:api:updatedState", { activeRaces = activeRaces })
end)

RegisterNetEvent("desirerp-racing:endRace")
AddEventHandler("desirerp-racing:endRace", function(race)
    print("RACE FUCKING END")
    SendNUIMessage({
        showHUD = false
    })

    TriggerEvent("desirerp-racing:api:raceEnded", race)
    TriggerEvent('desirerp-racing:desirerp-racing:api:updatedStat')
    cleanupRace()
end)

RegisterNetEvent("desirerp-racing:raceHistory")
AddEventHandler("desirerp-racing:raceHistory", function(race)
    finishedRaces[#finishedRaces + 1] = race

    if race then
        if not config.nui.hudOnly then
            SendNUIMessage({
                leaderboardData = race
            })
        end
    end

    TriggerEvent("desirerp-racing:api:raceHistory", race)
    TriggerEvent("desirerp-racing:api:updatedState", { finishedRaces = finishedRaces })
end)

RegisterNetEvent("desirerp-racing:startRace")
AddEventHandler("desirerp-racing:startRace", function(race, startTime)
    TriggerEvent("desirerp-racing:api:startingRace", startTime)
    -- Wait for race countdown
    Citizen.Wait(startTime - 3000)

    SendNUIMessage({
        type = "countdown",
        start = 3,
    })

    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "Oneshot_Final", "MP_MISSION_COUNTDOWN_SOUNDSET")

    if not curRace then
        initRace(race)
        TriggerEvent("desirerp-racing:api:raceStarted", race)
    end
end)

RegisterNetEvent("desirerp-racing:updatePosition")
AddEventHandler("desirerp-racing:updatePosition", function(position)
    -- print("Position is now: " .. position)
    SendNUIMessage({
        HUD = { position = position }
    })
end)

RegisterNetEvent("desirerp-racing:dnfRace")
AddEventHandler("desirerp-racing:dnfRace", function()
    SendNUIMessage({
        HUD = { dnf = true }
    })

    TriggerEvent("desirerp-racing:api:dnfRace", race)
end)

RegisterNetEvent("desirerp-racing:startDNFCountdown")
AddEventHandler("desirerp-racing:startDNFCountdown", function(dnfTime)
    SendNUIMessage({
        HUD = { dnfTime = dnfTime }
    })
end)

function round(x, n) 
    return tonumber(string.format("%." .. n .. "f", x))
end

RegisterNetEvent("desirerp-racing:finishedRace")
AddEventHandler("desirerp-racing:finishedRace", function(position, time, pEnterAmt)
    if position == 1 then
        RPC.execute('desirerp-racing:awardPlayer', math.random(40, 50) + round(pEnterAmt / 6, 0))
    elseif position == 2 then
        RPC.execute('desirerp-racing:awardPlayer', math.random(20, 30))
    elseif position == 3 then
        RPC.execute('desirerp-racing:awardPlayer', math.random(10))
    end
    SendNUIMessage({
        HUD = {
            position = position,
            finished = time,
        }
    })
end)

RegisterNetEvent("desirerp-racing:joinedRace")
AddEventHandler("desirerp-racing:joinedRace", function(race)
    race.start.pos = tableToVector3(race.start.pos)
    spawnCheckpointObjects(race.start, config.startObjectHash)
end)

RegisterNetEvent("desirerp-racing:leftRace")
AddEventHandler("desirerp-racing:leftRace", function()
    cleanupProps()
    TriggerEvent('desirerp-racing:api:updatedState')
end)

RegisterNetEvent("desirerp-racing:playerJoinedYourRace")
AddEventHandler("desirerp-racing:playerJoinedYourRace", function(characterId, name)
    if characterId == getCharacterId() then return end

    TriggerEvent("desirerp-racing:api:playerJoinedYourRace", characterId, name)
end)

RegisterNetEvent("desirerp-racing:playerLeftYourRace")
AddEventHandler("desirerp-racing:playerLeftYourRace", function(characterId, name)
    if characterId == getCharacterId() then return end

    TriggerEvent("desirerp-racing:api:playerLeftYourRace", characterId, name)
end)

RegisterNetEvent("desirerp-racing:addedPendingRace")
AddEventHandler("desirerp-racing:addedPendingRace", function(race)
    pendingRaces[race.id] = race
    if not config.nui.hudOnly then
        SendNUIMessage({
            pendingRaces = pendingRaces
        })
    end

    TriggerEvent("desirerp-racing:api:addedPendingRace", race, pendingRaces)
    TriggerEvent("desirerp-racing:api:updatedState", { pendingRaces = pendingRaces })
end)

RegisterNetEvent("desirerp-racing:removedPendingRace")
AddEventHandler("desirerp-racing:removedPendingRace", function(id)
    pendingRaces[id] = nil

    SendNUIMessage({ pendingRaces = pendingRaces })

    TriggerEvent("desirerp-racing:api:removedPendingRace", pendingRaces)
    TriggerEvent("desirerp-racing:api:updatedState", {pendingRaces=pendingRaces})
end)

RegisterNetEvent("desirerp-racing:startCreation")
AddEventHandler("desirerp-racing:startCreation", function()
    startRaceCreation()
end)

RegisterNetEvent("desirerp-racing:addedRace")
AddEventHandler("desirerp-racing:addedRace", function(newRace, newRaces)
    if not races then return end
    races = newRaces

    SendNUIMessage({
        races = newRaces
    })

    TriggerEvent("desirerp-racing:api:addedRace")
    TriggerEvent("desirerp-racing:api:updatedState", {races=races})
end)

local function openAliasTextbox()
  exports['desirerp-interface']:openApplication('textbox', {
    callbackUrl = 'desirerp-interface:racing:input:alias',
    key = 1,
    items = {{icon = "pencil-alt", label = "Alias", name = "alias"}},
    show = true
  })
end

AddEventHandler("desirerp-inventory:itemUsed", function(item, metadata, inventoryName, slot)
  if item ~= "racingusb2" then return end
  usedItemId = item
  usedItemSlot = slot
  usedItemMetadata = json.decode(metadata)

  local characterId = exports["isPed"]:isPed("cid")
  if characterId ~= usedItemMetadata.characterId then
    TriggerEvent("DoLongHudText", "You don't own this usb!", 2)
    return
  end

  if usedItemMetadata.Alias then
    TriggerEvent("DoLongHudText", "Alias can't be changed for this usb!", 2)
    return
  end

  openAliasTextbox()
end)

RegisterInterfaceCallback("desirerp-interface:racing:input:alias", function(data, cb)
  cb({data = {}, meta = {ok = true, message = ''}})
  exports['desirerp-interface']:closeApplication('textbox')
  local alias = data.values.alias

  if usedItemMetadata.Alias then return end

  if not alias then
    TriggerEvent("DoLongHudText", "No alias entered!", 2)
    return
  end

  local success, msg = RPC.execute("desirerp-racing:setAlias", usedItemId, usedItemSlot, usedItemMetadata, alias)
  if success then
    exports["desirerp-phone"]:phoneNotification("racen", "Welcome to the underground, " .. alias .. ".", "From the PM", 5000)
  else
    TriggerEvent("DoLongHudText", msg or "Alias could not be set.", 2)
    if msg == "Alias already taken!" then
      openAliasTextbox()
    end
  end
end)

-- RegisterCommand("desirerp-racing:giveRacingUSB", function()
--     RPC.execute("desirerp-racing:giveRacingUSB")
-- end)

AddEventHandler("onResourceStop", function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    cleanupProps()
    clearBlips()
    ClearGpsMultiRoute()
end)

RegisterNetEvent('desirerp-racing:api:currentRace')
AddEventHandler("desirerp-racing:api:currentRace", function(currentRace)
    print(json.encode(currentRace))
    -- print("FUCK THIS SHIT HERE******************************************************")
    isRacing = currentRace ~= nil
    if isRacing then
        -- startBubblePopper(currentRace)
    end
end)