RegisterServerEvent('CarryPeople:sync')
AddEventHandler('CarryPeople:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)

    -- exports["desirerp-log"]:AddLog("Civ Jobs", 
    --     source, 
    --     "Carry Player", 
    --     { targetPlayer = GetPlayerName(target) })
end)

RegisterServerEvent('CarryPeople:stop')
AddEventHandler('CarryPeople:stop', function(targetSrc)
	TriggerClientEvent('CarryPeople:cl_stop', targetSrc)

    -- exports["desirerp-log"]:AddLog("Civ Jobs", 
    --     source, 
    --     "Stop Carry Player", 
    --     { targetPlayer = GetPlayerName(targetSrc) })
    -- Why would you log the carry?
    -- Wanna kill the SQL? its slow enough.
end)

RegisterServerEvent('desirerp-jobs:galleryPayout')
AddEventHandler('desirerp-jobs:galleryPayout', function(amount)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local charInfo = user:getCurrentCharacter()

    user:addMoney(amount)

    local connect = {
        {
          ["color"] = color,
          ["title"] = "** DesireRP [Gallery] | Payout Log **",
          ["description"] = "Gallery Payout Log | Amount: $"..amount.." | Character Name: "..charInfo.first_name.." "..charInfo.last_name.." | State ID: "..charInfo.id,
        }
      }
      PerformHttpRequest("https://discord.com/api/webhooks/1032833578356183040/ShhNE_-APOBXdRhVCsNH_QagmuCRLmsoqEmZXwqcWVWv0S0hWCBJ28dOlrcCwiAon1Ms", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Job Payout Log", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)