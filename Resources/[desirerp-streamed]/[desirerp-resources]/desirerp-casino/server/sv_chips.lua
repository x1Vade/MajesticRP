RegisterServerEvent('aspect-casino:takeMoneyChips')
AddEventHandler('aspect-casino:takeMoneyChips', function(pMoneyAmount)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    
    user:removeMoney(tonumber(pMoneyAmount))
end)

RegisterServerEvent('aspect-casino:giveCashoutCashChips')
AddEventHandler('aspect-casino:giveCashoutCashChips', function(pMoneyAmount)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    
    user:addMoney(tonumber(pMoneyAmount))

    local character = user:getCurrentCharacter()
    local steamName = GetPlayerName(src)

    local identifiers = GetPlayerIdentifiers(src)

    local pDiscord = 'None'
    local pSteam = 'None'

    for k, v in pairs(identifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end

    local connect = {
        {
          ["color"] = color,
          ["title"] = "** DesireRP [Casino] | Cashout Chips Cash **",
          ["description"] = "Character Name: "..character.first_name.." "..character.last_name.." \n State ID: "..character.id.." \n Steam Name: "..steamName.. "\n Discord ID: "..pDiscord.. " \n Steam Identifier: "..identifiers[1].." \n Traded Out "..pMoneyAmount.. "x Casino Chips for $"..pMoneyAmount.." In there cash balance.",
        }
      }
    PerformHttpRequest("https://discord.com/api/webhooks/1033202036159823892/YrmwnIN3RsRB6fxvt4s_nhq2IoPdaNnh_tY6NF7LIeiRlyXSx-IW-VjWryaBN-T0h5cW", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Casino", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('aspect-casino:giveCashoutBankChips')
AddEventHandler('aspect-casino:giveCashoutBankChips', function(pMoneyAmount)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    
    user:addBank(tonumber(pMoneyAmount))

    local character = user:getCurrentCharacter()
    local steamName = GetPlayerName(src)

    local identifiers = GetPlayerIdentifiers(src)

    local pDiscord = 'None'
    local pSteam = 'None'

    for k, v in pairs(identifiers) do
        if string.find(v, 'steam') then pSteam = v end
        if string.find(v, 'discord') then pDiscord = v end
    end

    local connect = {
        {
          ["color"] = color,
          ["title"] = "** DesireRP [Casino] | Cashout Chips Bank **",
          ["description"] = "Character Name: "..character.first_name.." "..character.last_name.." \n State ID: "..character.id.." \n Steam Name: "..steamName.. "\n Discord ID: "..pDiscord.. " \n Steam Identifier: "..identifiers[1].." \n Traded Out "..pMoneyAmount.. "x Casino Chips for $"..pMoneyAmount.." In there bank balance.",
        }
      }
    PerformHttpRequest("https://discord.com/api/webhooks/1033202036159823892/YrmwnIN3RsRB6fxvt4s_nhq2IoPdaNnh_tY6NF7LIeiRlyXSx-IW-VjWryaBN-T0h5cW", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Casino", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('desirerp-casino:newGiveChips')
AddEventHandler('desirerp-casino:newGiveChips', function()
  local src = source
  local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)

  print('given 500 chips')
  user:addChips(500)
end)