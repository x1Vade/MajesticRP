pFirstNLastName = 

RegisterNetEvent('desirerp-phone:fireEmp')
AddEventHandler('desirerp-phone:fireEmp', function(id, job, name)
  local src = source
  local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = char.id
  local mynumber = getNumberPhone(cid)
  exports.oxmysql:execute('DELETE FROM character_passes WHERE cid = @cid AND pass_type = @pass_type', {
      ['@cid'] = id,
      ['@pass_type'] = job
  }, function (result)
      TriggerClientEvent('DoLongHudText', src, 'You Fired '..name,2)
  end)
end)

local acceptedCustomers = {}

--RegisterNetEvent("acceptOrDenyCustomer")
RPC.register("desirerp-phone:sendChargeCustomerNotif", function(pSource, BusinessName, GroupID, stateID, amount, reason)
    local tSrc = getPlayerFromCidForCharge(tonumber(stateID))
    local businessName = MySQL.query.await([[
        SELECT * FROM businesses WHERE business_id = ?
    ]],
    { GroupID })

    TriggerClientEvent("desirerp-phone:chargeCustomerNotif", tSrc, {
        businessName = businessName[1].business_name, 
        amount = amount, 
        stateID = stateID, 
        businessID = GroupID,
        senderID = pSource
    })
end)

RPC.register("desirerp-phone:chargeCustomerBus", function(pSource, amount, GroupID, stateID, sID)
    local amtTax = exports['desirerp-business']:taxTotal(amount)
    local tSrc = getPlayerFromCidForCharge(tonumber(stateID))
    local user = exports['desirerp-base']:getModule("Player"):GetUser(tSrc)
    local char = user:getCurrentCharacter()
    local bank = tonumber(char.bank)

    if bank >= tonumber(amtTax) then
        user:removeBank(tonumber(amtTax))
        local businessBank = MySQL.query.await([[
            SELECT * FROM businesses WHERE business_id = ?
        ]],
        { GroupID })

        local businessBankUpd = MySQL.query.await([[
            UPDATE businesses SET bank = ? WHERE business_id = ?
        ]],
        { businessBank[1].bank + amount, GroupID })
    else
        TriggerClientEvent("desirerp-phone:businessRegisterNoti", sID, "SERVICE CHARGE", "They couldn't accept the payment")
        TriggerClientEvent("desirerp-phone:businessRegisterNoti", tSrc, "SERVICE CHARGE", "Not enough money to complete the payment.")
        return
    end
    TriggerClientEvent("desirerp-phone:businessRegisterNoti", tSrc, "SERVICE CHARGE", "Payment Successful.")
    TriggerClientEvent("desirerp-phone:businessRegisterNoti", tSrc, "SERVICE CHARGE", "You have been deducted " .. amtTax .. " from you're bank account")
    TriggerClientEvent("desirerp-phone:businessRegisterNoti", sID, "SERVICE CHARGE", "They accepted the payment")
    return
end)

function getPlayerFromCidForCharge(pCid)
    for k,v in pairs(GetPlayers()) do
        local user = exports['desirerp-base']:getModule("Player"):GetUser(tonumber(v))
        local char = user:getCurrentCharacter()
        local cid = char.id
        if cid == pCid then 
            return tonumber(v) 
        end
    end
end

RegisterServerEvent('desirerp-phone:business_hired', function(StateID, Rank, pBusiness)
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(source)
    local ply = user:getCurrentCharacter()
    local pHiringName = ply.first_name .. " " ..ply.last_name

    exports.oxmysql:execute("INSERT INTO character_passes (cid, rank, name, giver, pass_type, business_name) VALUES (@cid, @rank, @name, @giver, @pass_type, @business_name)",
    {
        ['@cid'] = StateID,
        ['@rank'] = Rank,
        ['@name'] = getNameFromCid(StateID),
        ['@giver'] = pHiringName,
        ['@pass_type'] = pBusiness,
        ['@business_name'] = pBusiness,
    })
end)

RegisterServerEvent('desirerp-phone:business_edit', function(pRank, pStateID, pPassType)
    exports.oxmysql:execute('UPDATE character_passes SET rank = @rank WHERE cid = @cid and pass_type = @pass_type',
    {
        ['@rank'] = pRank,
        ['@cid'] = pStateID,
        ['@pass_type'] = pPassType,
    })
end)

RPC.register("desirerp:getBusinessLogs", function(pSource, pBusiness)
    local shitfuckshitfuck = {}
    local businessLogs = MySQL.query.await([[
        SELECT * FROM _business_logs
        WHERE business_id = ? 
        ORDER BY id DESC
    ]],
    { pBusiness })

    if businessLogs[1] ~= nil then
        for k,v in pairs(businessLogs) do
            shitfuckshitfuck[#shitfuckshitfuck+1] = {
                information = v.user_name,
                infoAction = v.data_type,
                information2 = v.data_info,
                daysAgo = v.data_date
            }
        end
    end
    return shitfuckshitfuck
end)

RPC.register('desirerp-phone:business_paycheck', function(source,bus,p,a)
    local src = source
    local bId = bus
    local cid = p
    local amount = a

   local isPaycheck = MySQL.query.await([[
        SELECT * FROM characters
        WHERE id = ?
    ]],
    { cid })
    local isBusinessBank = MySQL.query.await([[
        SELECT * FROM businesses
        WHERE business_id = ?
    ]],
    { bId })
    
    local payCheck = (isPaycheck[1].paycheck+amount)
    local updateBank = (isBusinessBank[1].bank-amount)
    if updateBank <= 0 then return false, 0 end
    if tonumber(amount) < 0 then return end
    -- print(isPaycheck[1].paycheck,payCheck,isBusinessBank[1].bank)
    local affectedRows = MySQL.update.await([[
        UPDATE characters
        SET paycheck = ?
        WHERE id = ?
    ]],
    { tonumber(payCheck), cid })
    local updateBusBank = MySQL.update.await([[
        UPDATE businesses
        SET bank = ?
        WHERE business_id = ?
    ]],
    { tonumber(updateBank), bId })
    if affectedRows and affectedRows ~= 0 and updateBusBank and updateBusBank ~= 0 then
        return true,amount
    end
end)

function getPlayerFromCid(zcid, amountAdded)
    for _, player in ipairs(GetPlayers()) do
        local user = exports["desirerp-base"]:getModule("Player"):GetUser(tonumber(player))
        local char = user:getVar("character")
        if char.id == tonumber(zcid) then
            TriggerClientEvent('banking:updateBalance', tonumber(player), amountAdded)
        end
    end
end

RPC.register("desirerp-business:payExternal", function(pSource, pCid, pAmount, pBusinessID)
    local bank = MySQL.query.await([[
        SELECT * FROM businesses
        WHERE business_id = ?
    ]],{pBusinessID})

    local bank2 = MySQL.query.await([[
        SELECT * FROM characters
        WHERE id = ?
    ]],{pCid})

    if tonumber(bank[1].bank) >= tonumber(pAmount) then
        local amountAdded = tonumber(bank2[1].bank)+tonumber(pAmount)
        local amountRemoved = tonumber(bank[1].bank)-tonumber(pAmount)
        local affectedRows = MySQL.update.await([[
            UPDATE characters
            SET bank = ?
            WHERE id = ?
        ]],
        { amountAdded, pCid})
        local affectedRows2 = MySQL.update.await([[
            UPDATE businesses
            SET bank = ?
            WHERE business_id = ?
        ]],
        {amountRemoved, pBusinessID})
        getPlayerFromCid(pCid, amountAdded)
        return true, 'Successfully paid externally.'
    else
        return false, 'Not enough money in business bank.'
    end
end)

RPC.register('desirerp-phone:bus_addBank', function(source,id,a)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local ply = user:getCurrentCharacter()
    local bId = id
    local amount = a
    local bank = MySQL.query.await([[
        SELECT * FROM group_banking
        WHERE group_type = ?
    ]],{bId})
    if tonumber(user:getCash()) >= tonumber(amount) then
        local affectedRows = MySQL.update.await([[
            UPDATE group_banking
            SET bank = ?
            WHERE group_type = ?
        ]],{bank[1].bank+amount, bId})
        user:removeMoney(tonumber(amount))
        return true
    end
end)

RegisterServerEvent('desirerp-phone:business_fire', function(pBusinessName, pStateID)
    local src = source
    local user = exports["desirerp-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id

    exports.oxmysql:execute("DELETE FROM character_passes WHERE cid = @cid AND pass_type = @pass_type", {['@cid'] = pStateID, ['@pass_type'] = pBusinessName}, function()end)
end)

function getBusinessName(bId)
    local businessName = ""
    if bId == "hayes_autos" then
        businessName = "Hayes Auto"
    elseif bId == "burger_shot" then
        businessName = "Burger Shot"
    elseif bId == "casino" then
        businessName = "Casino Diamond"
    elseif bId == "vanilla_unicorn" then
        businessName = "Vanilla Unicorn"
    elseif bId == "car_shop" then
        businessName = "PDM"
    elseif bId == "pizzaria" then
        businessName = "Maldini's Pizza"
    elseif bId == "ems" then
        businessName = "Pillbox Hospital"
    elseif bId == "police" then
        businessName = "Police"
    elseif bId == "gallery" then
        businessName = "Gallery"
    elseif bId == "ug_racing" then
        businessName = "Underground"
    elseif bId == "lostmc" then
        businessName = "Lost MC"
    elseif bId == "sacredflowers" then
        businessName = "Sacred Flowers"
    elseif bId == "bcso" then
        businessName = "BCSO"
    elseif bId == "DOJ" then
        businessName = "DOJ"
    elseif bId == "taco_shop" then
        businessName = "Taco Shop"
    elseif bId == "serpents" then
        businessName = "Serpents"
    end
    return businessName
end


RegisterServerEvent('group:pullinformation')
AddEventHandler('group:pullinformation', function(groupid,rank)
  local src = source
  exports.oxmysql:execute("SELECT * FROM character_passes WHERE pass_type = @groupid and rank > 0 ORDER BY rank DESC", {['groupid'] = groupid}, function(results)
      if results ~= nil then
          exports.oxmysql:execute("SELECT bank FROM group_banking WHERE group_type = @groupid", {['groupid'] = groupid}, function(result)
              local bank = 0
              if result[1] ~= nil then
                  bank = result[1].bank
              end
              TriggerClientEvent("group:fullList", src, results, bank, groupid)
          end)
      else
          TriggerClientEvent("phone:error", src)
      end
  end)
end)