local activeRegisters = {
    {
        polytarget = {
            vector3(-1196.33, -890.75, 13.98), 0.8, 1.0, {
                heading=35,
                minZ=13.78,
                maxZ=14.78,
            }
        },
        business="burger_shot",
    },
    {
        polytarget = {
            vector3(-1195.26, -892.33, 13.98), 0.6, 1.0, {
                heading=35,
                minZ=13.78,
                maxZ=14.78,
            }
        },
        business="burger_shot",
    },
    {
        polytarget = {
            vector3(-1194.28, -893.9, 13.98), 0.6, 1.0, {
                heading=35,
                minZ=13.78,
                maxZ=14.78,
            }
        },
        business="burger_shot",
    },
    {
        polytarget = {
            vector3(811.16, -750.75, 26.78), 0.7, 1.1, {
                heading=0,
                minZ=23.18,
                maxZ=27.18
            }
        },
        business="maldinis",
    },
    {
        polytarget = {
            vector3(811.15, -752.06, 26.78), 0.7, 1.1, {
                heading=0,
                minZ=23.18,
                maxZ=27.18
            }
        },
        business="maldinis",
    },
    {
        polytarget = {
            vector3(188.18, -243.59, 54.07), 0.5, 0.5, {
                heading=340,
                minZ=50.47,
                maxZ=54.47
            }
        },
        business="white_widow",
    },
    {
        polytarget = {
            vector3(188.96, -241.13, 54.07), 0.5, 0.5, {
                heading=340,
                minZ=50.47,
                maxZ=54.47
            }
        },
        business="white_widow",
    },
    {
        polytarget = {
            vector3(-171.18, 295.02, 93.76), 0.5, 0.9, {
                heading=0,
                minZ=90.16,
                maxZ=94.16
            }
        },
        business="warriors_table",
    },
    {
        polytarget = {
            vector3(295.88, -923.48, 52.82), 0.8, 0.8, {
                heading=340,
                minZ=49.42,
                maxZ=53.42
            }
        },
        business="skybar",
    },
    {
        polytarget = {
            vector3(296.46, -936.08, 52.81), 0.6, 0.8, {
                heading=5,
                minZ=49.41,
                maxZ=53.41
            }
        },
        business="skybar",
    },
    {
        polytarget = {
            vector3(-584.03, -1061.47, 22.34), 1, 0.4, {
                heading=270,
                minZ=18.54,
                maxZ=22.54
            }
        },
        business="uwu_cafe",
    },
    {
        polytarget = {
            vector3(-584.04, -1058.72, 22.34), 1, 0.4, {
                heading=270,
                minZ=18.54,
                maxZ=22.54
            }
        },
        business="uwu_cafe",
    },
    {
        polytarget = {
            vector3(813.46, -780.95, 26.17), 0.5, 0.7, {
                heading=5,
                minZ=22.77,
                maxZ=26.77
            }
        },
        business="gofuel",
    },
    {
        polytarget = {
            vector3(813.49, -783.09, 26.17), 0.5, 0.7, {
                heading=0,
                minZ=22.77,
                maxZ=26.77
            }
        },
        business="gofuel",
    },
}

local activePurchases = {}

Citizen.CreateThread(function()
for id,register in ipairs(activeRegisters) do
        local ptId = "voidrp_business_register_" .. id
        exports["desirerp-polytarget"]:AddBoxZone(ptId, register.polytarget[1], register.polytarget[2], register.polytarget[3], register.polytarget[4])
        exports['desirerp-interact']:AddPeekEntryByPolyTarget(ptId, {{
            event = "desirerp-business:registerPurchasePrompt",
            id = ptId .. "_purchase",
            icon = "cash-register",
            label = "make payment",
            parameters = {registerId = id, business = register.business}
        }}, { distance = { radius = 2.0 } })
        exports['desirerp-interact']:AddPeekEntryByPolyTarget(ptId, {{
            event = "desirerp-business:registerChargePrompt",
            id = ptId .. "_charge",
            icon = "credit-card",
            label = "Charge Customer",
            parameters = {registerId = id, business = register.business}
        }}, { distance = { radius = 2.0 }, isEnabled = function(pEntity, pContext) return IsEmployedAt(register.business) end})
    end 
end)

AddEventHandler('desirerp-business:registerPurchasePrompt', function(pParameters, pEntity, pContext)
    local activeRegisterId = pParameters.registerId
    local activeRegister = activePurchases[activeRegisterId]
    if not activeRegister or activeRegister == nil then
        TriggerEvent("DoLongHudText", "No purchase active.")
        return
    end
    local priceWithTax = RPC.execute("PriceWithTaxString", activeRegister.cost, "Goods")
    local acceptContext = {
        {
            title = "Restaurant Purchase",
            description = "$" .. priceWithTax.text .. " | " .. activeRegister.comment,
        },
        {
            title = "Purchase with Bank",
            action = "desirerp-business:finishPurchasePrompt",
            icon = 'credit-card',
            key = {cost = priceWithTax.cost, comment = activeRegister.comment, registerId = pParameters.registerId, charger = activeRegister.charger, business = pParameters.business, tax = priceWithTax.tax, cash = false},
        },
        {
            title = "Purchase with Cash",
            action = "desirerp-business:finishPurchasePrompt",
            icon = 'money-bill',
            key = {cost = priceWithTax.cost, comment = activeRegister.comment, registerId = pParameters.registerId, charger = activeRegister.charger, business = pParameters.business, tax = priceWithTax.tax, cash = true},
        }
    }
    exports['desirerp-interface']:showContextMenu(acceptContext)
end)

AddEventHandler('desirerp-business:registerChargePrompt', function(pParameters, pEntity, pContext)
    exports['desirerp-interface']:openApplication('textbox', {
        callbackUrl = 'desirerp-interface:business:charge',
        key = {registerId = pParameters.registerId, business = pParameters.business},
        items = {
          {
            icon = "dollar-sign",
            label = "Cost",
            name = "cost",
          },
          {
            icon = "pencil-alt",
            label = "Comment",
            name = "comment",
          },
        },
        show = true,
    })
end)

--Add to purchases at registerId pos
RegisterNetEvent('desirerp-business:activePurchase')
AddEventHandler("desirerp-business:activePurchase", function(data)
    activePurchases[data.registerId] = data
end)

--Remove at registerId pos
RegisterNetEvent('desirerp-business:closePurchase')
AddEventHandler("desirerp-business:closePurchase", function(data)
    activePurchases[data.registerId] = nil
end)

RegisterInterfaceCallback('desirerp-business:finishPurchasePrompt', function (data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local success, message = RPC.execute("desirerp-business:completePurchaseRegister", data.key)
    if not success then
        TriggerEvent("DoLongHudText", message, 2)
    end
end)

RegisterInterfaceCallback("desirerp-interface:business:charge", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['desirerp-interface']:closeApplication('textbox')
    local cost = tonumber(data.values.cost)
    local comment = data.values.comment
    if cost == nil or not cost then return end
    if comment == nil then comment = "" end

    if cost < 1 then cost = 1 end --Minimum $1

    --Send event to everyone indicating a purchase is ready at specified register
    RPC.execute("desirerp-business:startPurchase", {cost = cost, comment = comment, registerId = data.key.registerId, business = data.key.business})
end)