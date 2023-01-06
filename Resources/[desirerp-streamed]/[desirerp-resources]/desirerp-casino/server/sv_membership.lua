RegisterServerEvent('aspect-casino:takeMoneyCasinoCard')
AddEventHandler('aspect-casino:takeMoneyCasinoCard', function(pMoneyAmount)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    local steamName = GetPlayerName(src)

    local identifiers = GetPlayerIdentifiers(src)

    local pDiscord = 'None'
    local pSteam = 'None'

    for k, v in pairs(identifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end
    
    user:removeMoney(tonumber(pMoneyAmount))
    TriggerClientEvent('desirerp-casino:addBalance', src, pMoneyAmount)

    local connect = {
        {
          ["color"] = color,
          ["title"] = "** DesireRP [Casino] | Purchase Membership **",
          ["description"] = "Character Name: "..character.first_name.." "..character.last_name.." \n State ID: "..character.id.." \n Steam Name: "..steamName.. "\n Discord ID: "..pDiscord.. " \n Steam Identifier: "..identifiers[1].." \n Purchased Casino Membership Card for $"..pMoneyAmount,
        }
      }
    PerformHttpRequest("https://discord.com/api/webhooks/1033202036159823892/YrmwnIN3RsRB6fxvt4s_nhq2IoPdaNnh_tY6NF7LIeiRlyXSx-IW-VjWryaBN-T0h5cW", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Casino", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)