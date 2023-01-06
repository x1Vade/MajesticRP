RegisterNetEvent("desirerp-weapons:attackedByCash")
AddEventHandler("desirerp-weapons:attackedByCash", function(pAttacker)
    local victim = source
    TriggerClientEvent("desirerp-weapons:hitPlayerWithCash", pAttacker, victim)
end)

RegisterNetEvent("desirerp-weapons:processGiveCashAmount")
AddEventHandler("desirerp-weapons:processGiveCashAmount", function(pTarget, pAmount, pId)
    local attacker = source
    local victim = pTarget
    local victimUser = exports["desirerp-base"]:getModule("Player"):GetUser(victim)

    victimUser:addMoney(pAmount)
            
    exports["desirerp-log"]:AddLog("Weapons", 
        source, "Get thrown money", { victim = tostring(victim), victimName = GetPlayerName(victim) })
end)


RPC.register("weapons:getAmmo", function(source)
    return weaponsGetAmmo(source)
end)

RegisterNetEvent("cash:roll")
AddEventHandler("cash:roll", function(src, pAmount)
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local amount = tonumber(pAmount)
    if amount ~= nil then
        if user:getCash() >= amount then
            user:removeMoney(amount)
            TriggerClientEvent("player:receiveItem", src,"571920712",1, false,{amount = amount})

            exports["desirerp-log"]:AddLog("Weapons", 
                src, "Create Throwable Cash", {amount = amount})
            return
        end
    end

    return
end)



RegisterNetEvent('desirerp-weapons:getAmmo')
AddEventHandler('desirerp-weapons:getAmmo', function()
    local ammoTable = {}
    local src = source
	local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute("SELECT type, ammo FROM characters_weapons WHERE id = @id", {['id'] = char.id}, function(result)
        for i = 1, #result do
            if ammoTable["" .. result[i].type .. ""] == nil then
                ammoTable["" .. result[i].type .. ""] = {}
                ammoTable["" .. result[i].type .. ""]["ammo"] = result[i].ammo
                ammoTable["" .. result[i].type .. ""]["type"] = ""..result[i].type..""
            end
        end
        TriggerClientEvent('desirerp-items:SetAmmo', src, ammoTable)
    end)
end)

RegisterNetEvent('desirerp-weapons:updateAmmo')
AddEventHandler('desirerp-weapons:updateAmmo', function(newammo,ammoType,ammoTable)
    local src = source
	local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT ammo FROM characters_weapons WHERE type = @type AND id = @identifier',{['@type'] = ammoType, ['@identifier'] = char.id}, function(result)
        if result[1] == nil then
            exports.ghmattimysql:execute('INSERT INTO characters_weapons (id, type, ammo) VALUES (@identifier, @type, @ammo)', {
                ['@identifier'] = char.id,
                ['@type'] = ammoType,
                ['@ammo'] = newammo
            }, function()
            end)
        else
            exports.ghmattimysql:execute('UPDATE characters_weapons SET ammo = @newammo WHERE type = @type AND ammo = @ammo AND id = @identifier', {
                ['@identifier'] = char.id,
                ['@type'] = ammoType,
                ['@ammo'] = result[1].ammo,
                ['@newammo'] = newammo
            }, function()
            end)
        end
    end)
end)


RegisterCommand("rollcash", function(src, args)
    TriggerEvent('cash:roll', src, args[1])
end)
