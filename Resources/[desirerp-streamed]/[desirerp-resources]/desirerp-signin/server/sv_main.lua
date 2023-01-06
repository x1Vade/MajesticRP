local activepolice = 0


RegisterServerEvent("desirerp-signin:duty")
AddEventHandler("desirerp-signin:duty", function(pJobType, pSrc)
    local src = (pSrc == nil and source or pSrc)
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    local jobs = exports["desirerp-base"]:getModule("JobManager")
    if pJobType == nil then pJobType = "police" end
    jobs:SetJob(user, pJobType, false, function()
        if pJobType == "police" then
            exports['desirerp-dispatch']:callsign_command()
            exports.oxmysql:execute('SELECT * FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result)

                TriggerClientEvent("DoLongHudText", src, "10-41 and Restocked.", 1)
                TriggerClientEvent("startSpeedo", src)
                TriggerClientEvent("nowCopGarage", src, pJobType)
                TriggerClientEvent('badBlips:server:registerPlayerBlipGroup', src, 'police')
                if result[1].callsign == nil then
                    TriggerEvent("badBlips:server:registerSourceName", src, character.first_name .. " " ..character.last_name.. " | NO CALLSIGN")
                else
                    TriggerEvent("badBlips:server:registerSourceName", src, result[1].callsign.. " | "  ..character.first_name .. " " ..character.last_name)
                end
                activepolice = activepolice + 1
                TriggerClientEvent("job:counts", -1, activepolice)
            end)

        elseif pJobType == "doc" then
            TriggerClientEvent("DoLongHudText", src, "10-41, Signed in as DOC.", 1)
            TriggerClientEvent("nowCopGarage", src, pJobType)
        elseif pJobType == "ems" then
            
            -- TriggerClientEvent('badBlips:server:registerPlayerBlipGroup', src, 'ems')
            -- TriggerEvent("badBlips:server:registerSourceName", src, character.first_name .. " " ..character.last_name.. " | NO CALLSIGN")

            -- TriggerClientEvent("DoLongHudText", src, "10-41, Signed in as EMS.", 1)
            -- TriggerClientEvent("hasSignedOnEms", src)
            -- TriggerClientEvent('police:officerOnDuty', src)

            exports.oxmysql:execute('SELECT callsign FROM jobs_whitelist WHERE cid = ?', {character.id}, function(result)
                    jobs:SetJob(user, "ems", false, function()
                    TriggerClientEvent('desirerp-duty:EMSSuccess', src)
                    TriggerClientEvent("DoLongHudText", src,"Signed in as EMS.",17)
                    TriggerEvent('badBlips:server:registerPlayerBlipGroup', src, 'ems')

                    if result[1].callsign == nil then
                        TriggerEvent("badBlips:server:registerSourceName", src, character.first_name .. " " ..character.last_name.. " | NO CALLSIGN")
                    else
                        TriggerEvent("badBlips:server:registerSourceName", src, result[1].callsign.. " | "  ..character.first_name .. " " ..character.last_name)
                    end
                end)
            end)

        elseif pJobType == "judge" then
            TriggerClientEvent("isJudge", src)
            Wait(1000)
            TriggerEvent("isJudge", src)
        elseif pJobType == "doctor" then
            TriggerClientEvent("isDoctor", src)
            Wait(1000)
            TriggerEvent("isDoctor",src)
        elseif pJobType == "therapist" then
            TriggerClientEvent("isTherapist", src)
            Wait(1000)
            TriggerEvent("isTherapist", src)
        else
            TriggerClientEvent("DoLongHudText", src, ("You are now signed in as %s"):format(pJobType), 1)
        end
    end)
end)


RegisterServerEvent("desirerp-signoff:duty")
AddEventHandler("desirerp-signoff:duty", function(job)
	local src = source
    if job == 'police' then
        if activepolice > 1 then
            activepolice = activepolice - 1
        else
            activepolice = 0
        end
        TriggerClientEvent("job:counts", -1, activepolice)
        TriggerClientEvent('badBlips:server:removePlayerBlipGroup', src, 'police')
    elseif job == 'ems' then
        TriggerClientEvent('badBlips:server:removePlayerBlipGroup', src, 'ems')
    end
end)