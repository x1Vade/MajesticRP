--// Cop Counter //--

local pPDNumbers = 0

RPC.register('desirerp-police:getActiveUnits', function()
    exports.oxmysql:execute("SELECT `cops` FROM `cop_counter`", function(copCounter)
        pPDNumbers = copCounter[1].cops
    end)
    print('Current Units On Duty: '..pPDNumbers)

    return pPDNumbers
end)

RPC.register('desirerp-police:addActiveUnit', function()
    exports.oxmysql:execute('UPDATE `cop_counter` SET `cops` = @PDCount',
        {
            ['@PDCount'] = pPDNumbers + 1,
        }, function()
    end)
    pPDNumbers = pPDNumbers + 1

    print('[DEBUG] | Adding Cop to Cop Counter | Current Amount of Units On Duty: ' .. pPDNumbers)
end)

RPC.register('desirerp-police:removeActiveUnit', function()    
    exports.oxmysql:execute('UPDATE `cop_counter` SET `cops` = @PDCount',
        {
            ['@PDCount'] = pPDNumbers - 1,
        }, function()
    end)
    pPDNumbers = pPDNumbers - 1

    if pPDNumbers < 0 then
        exports.oxmysql:execute('UPDATE `cop_counter` SET `cops` = @PDCount',
            {
                ['@PDCount'] = "0",
            }, function()
        end)
        print('[ERROR] | Dispatch got confused and tried to go into negative numbers ! | Dispatch cop count reset to 0.')
    end

    print('[DEBUG] | Removing Cop from Cop Counter | Current Amount of Units On Duty: ' .. pPDNumbers)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local user = exports['desirerp-base']:getModule('Player'):GetUser(src)
    local userjob = user:getVar("job")

    if userjob == "police" then
        exports.oxmysql:execute('UPDATE `cop_counter` SET `cops` = @PDCount',
            {
                ['@PDCount'] = pPDNumbers - 1,
            }, function()
            pPDNumbers = pPDNumbers - 1
        end)
        print('[DEBUG] | Removing Cop from Cop Counter | Current Amount of Units On Duty: ' .. pPDNumbers)
    end
end)

AddEventHandler('onResourceStart', function(resource)    
	if resource == GetCurrentResourceName() then
        exports.oxmysql:execute('UPDATE `cop_counter` SET `cops` = @PDCount',
            {
                ['@PDCount'] = "0",
            }, function()
            pPDNumbers = 0
        end)
        print('[DISPATCH] | Reset Cop Counter | Active Units: '..pPDNumbers)
	end
end)

RegisterServerEvent('desirerp-dispatch:FetchCallsign')
AddEventHandler('desirerp-dispatch:FetchCallsign', function()
    local src = source
    local user = exports['desirerp-base']:getModule("Player"):GetUser(src)
    local charInfo = user:getCurrentCharacter()

    exports.oxmysql:execute("SELECT * FROM jobs_whitelist WHERE cid = @cid", {
        ["cid"] = charInfo.id
    }, function(pResult)
        print('Setting Callsign: '..pResult[1].callsign)
        TriggerClientEvent('dispatch:setcallsign:cl', src, pResult[1].callsign)
    end)
end)

-- // Alerts // --

RegisterServerEvent('desirerp-dispatch:sendNotifi', function(data)
    TriggerClientEvent('dispatch:clNotify', -1, data)
end)