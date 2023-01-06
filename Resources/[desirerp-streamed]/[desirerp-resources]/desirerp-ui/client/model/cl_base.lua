-- CLOSE APP
function SetUIFocus(hasKeyboard, hasMouse)
    --  HasNuiFocus = hasKeyboard or hasMouse
    
      SetNuiFocus(hasKeyboard, hasMouse)
    
      -- TriggerEvent("desirerp-voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
      -- TriggerEvent("desirerp-binds:should-execute", not HasNuiFocus)
    end
    
    exports('SetUIFocus', SetUIFocus)
    
    RegisterNUICallback("desirerp-ui:closeApp", function(data, cb)
        SetUIFocus(false, false)
        cb({data = {}, meta = {ok = true, message = 'done'}})
        Wait(800)
        TriggerEvent("attachedItems:block",false)
    end)
    
    RegisterNUICallback("desirerp-ui:applicationClosed", function(data, cb)
        TriggerEvent("desirerp-ui:application-closed", data.name, data)
        cb({data = {}, meta = {ok = true, message = 'done'}})
    end)
    
    -- FORCE CLOSE
    RegisterCommand("desirerp-ui:force-close", function()
        SendUIMessage({source = "desirerp-nui", app = "", show = false});
        SetUIFocus(false, false)
    end, false)
    
    -- SMALL MAP
    RegisterCommand("desirerp-ui:small-map", function()
      SetRadarBigmapEnabled(false, false)
    end, false)
    
    local function restartUI(withMsg)
      SendUIMessage({ source = "desirerp-nui", app = "main", action = "restart" });
      if withMsg then
        TriggerEvent("DoLongHudText", "You can also use 'ui-r' as a shorter version to restart!")
      end
      Wait(5000)
      TriggerEvent("desirerp-ui:restarted")
      SendUIMessage({ app = "hud", data = { display = true }, source = "desirerp-nui" })
      local cj = exports["police"]:getCurrentJob()
      if cj ~= "unemployed" then
        TriggerEvent("desirerp-jobmanager:playerBecameJob", cj)
        TriggerServerEvent("desirerp-jobmanager:fixPaychecks", cj)
      end
      loadPublicData()
    end
    RegisterCommand("desirerp-ui:restart", function() restartUI(true) end, false)
    RegisterCommand("ui-r", function() restartUI() end, false)
    RegisterNetEvent("desirerp-ui:server-restart")
    AddEventHandler("desirerp-ui:server-restart", restartUI)
    
    RegisterCommand("desirerp-ui:debug:show", function()
        SendUIMessage({ source = "desirerp-nui", app = "debuglogs", data = { display = true } });
    end, false)
    
    RegisterCommand("desirerp-ui:debug:hide", function()
        SendUIMessage({ source = "desirerp-nui", app = "debuglogs", data = { display = false } });
    end, false)
    
    RegisterNUICallback("desirerp-ui:resetApp", function(data, cb)
        SetUIFocus(false, false)
        cb({data = {}, meta = {ok = true, message = 'done'}})
        sendCharacterData()
    end)
    
    RegisterNetEvent("desirerp-ui:server-relay")
    AddEventHandler("desirerp-ui:server-relay", function(data)
        SendUIMessage(data)
    end)
    
    RegisterNetEvent("isJudge")
    AddEventHandler("isJudge", function()
      sendAppEvent("character", { job = "judge" })
    end)
    
    RegisterNetEvent("isJudgeOff")
    AddEventHandler("isJudgeOff", function()
      sendAppEvent("character", { job = "unemployed" })
    end)
    
    RegisterNetEvent("desirerp-jobmanager:playerBecameJob")
    AddEventHandler("desirerp-jobmanager:playerBecameJob", function(job)
      sendAppEvent("character", { job = job })
    end)
    