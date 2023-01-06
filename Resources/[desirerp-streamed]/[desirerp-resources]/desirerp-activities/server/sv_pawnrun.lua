RegisterServerEvent('rolexdelivery:server')
AddEventHandler('rolexdelivery:server', function(money)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(source)

	if user:getCash() >= 500 then
        user:removeMoney(500)

		TriggerClientEvent("rolexdelivery:startDealing", src)
    else
        TriggerClientEvent('DoLongHudText', source, 'You dont have enough for this', 2)
	end
end)

RegisterServerEvent('desirerp-activities:pawnPayout')
AddEventHandler('desirerp-activities:pawnPayout', function(amount, text)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local charInfo = user:getCurrentCharacter()

    user:addMoney(amount)

    local connect = {
        {
          ["color"] = color,
          ["title"] = "** DesireRP [Activities] | Payout Log **",
          ["description"] = "Pawn Run Payout Log | Amount: $"..amount.." | (Buff / No Buff): "..text.." | Character Name: "..charInfo.first_name.." "..charInfo.last_name.." | State ID: "..charInfo.id,
        }
      }
      PerformHttpRequest("https://discord.com/api/webhooks/1032832855174291519/34duZPYx6WlaBRrJpzEteYzdUd8UWIWa9vHfA0ph_CQtzXC6hXG4xiTFrh-qL2_HBevb", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Job Payout Log", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)