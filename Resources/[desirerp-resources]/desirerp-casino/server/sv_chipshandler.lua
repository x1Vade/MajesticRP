function getCasinoChips()
    local src = source
    local user = exports['desirerp-base']:getModule("Player"):GetUser(src)
    local StateID = user:getCurrentCharacter().id

    exports.oxmysql:execute("SELECT chips FROM characters WHERE (id = @StateID)", {
        ['@StateID'] = StateID,
        }, function(result)
    end)
end

RegisterServerEvent('desirerp-casino:giveChips')
AddEventHandler('desirerp-casino:giveChips', function(amount)
    local src = source
    local user = exports['desirerp-base']:getModule("Player"):GetUser(src)
    local StateID = user:getCurrentCharacter().id

    exports.oxmysql:execute('SELECT chips FROM characters WHERE id = ?', {StateID}, function(pCharData)
        if pCharData[1] then
            exports.oxmysql:execute("UPDATE characters SET chips = @newChips WHERE id = @stateID", {
                ['newChips'] = pCharData[1].chips + amount, 
                ['stateID'] = StateID, 
            })
        else
            pExist = false
        end
    end)
end)

RegisterServerEvent('desirerp-casino:removeChips')
AddEventHandler('desirerp-casino:removeChips', function(pRemoveAmt)
    local src = source
    local user = exports['desirerp-base']:getModule("Player"):GetUser(src)
    local StateID = user:getCurrentCharacter().id

    exports.oxmysql:execute('SELECT chips FROM characters WHERE id = ?', {StateID}, function(pCharData)
        if pCharData[1] then
            exports.oxmysql:execute("UPDATE characters SET chips = @newChips WHERE id = @stateID", {
                ['newChips'] = pCharData[1].chips - pRemoveAmt, 
                ['stateID'] = StateID, 
            })
        else
            pExist = false
        end
    end)
end)

RPC.register("desirerp-casino:getChips", function(pSource)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local char = user:getVar("character")
    local id = char.id

    exports.oxmysql:execute("SELECT `chips` FROM characters WHERE id = @id",{['id'] = id}, function(data)
        chips = data[1].chips
    end)
    Wait(100)
    return chips
end)