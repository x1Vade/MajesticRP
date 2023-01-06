exports["desirerp-polytarget"]:AddCircleZone("desirerp_casino_trade_chips", vector3(989.73, 31.57, 71.54), 0.35, {
    name="desirerp_casino_trade_chips",
    useZ=true,
})

 exports["desirerp-interact"]:AddPeekEntryByPolyTarget("desirerp_casino_trade_chips", {
    {
        event = "desirerp-casino:cashoutBank",
        id = "row_1",
        icon = "landmark",
        label = "Cashout Chips (Bank)",
        parameters = {},
    },
    {
        event = "desirerp-casino:cashoutCash",
        id = "row_3",
        icon = "wallet",
        label = "Cashout Chips (Cash)",
        parameters = {},
    },
    {
        event = "desirerp-casino:purchaseChips",
        id = "row_2",
        icon = "circle",
        label = "Purchase Chips",
        parameters = {},
    }
}, {
    distance = { radius = 2.5 },
});


RegisterNetEvent('desirerp-casino:purchaseChips')
AddEventHandler('desirerp-casino:purchaseChips', function()
    exports['desirerp-interface']:openApplication('textbox', {
        callbackUrl = 'desirerp-casino:pPurchaseMyChips',
        key = 1,
        items = {
        {
            icon = "money-bill",
            label = "How many chips.",
            name = "pChips",
        },
        },
        show = true,
    })
end)

RegisterInterfaceCallback('desirerp-casino:pPurchaseMyChips', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })

    if exports['desirerp-inventory']:hasEnoughOfItem('casinomember', 1) then
        if exports["isPed"]:isPed("mycash") >= tonumber(data.values.pChips) then
            TriggerServerEvent('aspect-casino:takeMoneyChips', data.values.pChips)
            TriggerEvent('desirerp-casino:giveChipsCL', data.values.pChips)
        end
    else
        TriggerEvent('DoLongHudText', 'You need a Casino Membership to purchase Chips.', 2)
    end
end)

RegisterNetEvent('desirerp-casino:cashoutCash')
AddEventHandler('desirerp-casino:cashoutCash', function()
    local pQuantityChipsCash = RPC.execute('desirerp-casino:getChips')
    TriggerEvent('desirerp-casino:removeChipsCL', pQuantityChipsCash)
    TriggerServerEvent('aspect-casino:giveCashoutCashChips', pQuantityChipsCash)
end)

RegisterNetEvent('desirerp-casino:cashoutBank')
AddEventHandler('desirerp-casino:cashoutBank', function()
    local pQuantityChipBank = RPC.execute('desirerp-casino:getChips')
    TriggerEvent('desirerp-casino:removeChipsCL', pQuantityChipBank)
    TriggerServerEvent('aspect-casino:giveCashoutBankChips', pQuantityChipBank)
end)

RegisterNetEvent('desirerp-casino:addBalance')
AddEventHandler('desirerp-casino:addBalance', function(pAmount)
    TriggerServerEvent('desirerp-financials:business_money', pAmount, 'casino', 'add')
end)

RegisterCommand('givechips', function()
    TriggerServerEvent('desirerp-casino:giveChips', 10)
end)