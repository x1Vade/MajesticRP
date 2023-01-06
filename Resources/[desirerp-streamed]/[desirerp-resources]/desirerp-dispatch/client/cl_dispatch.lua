local disableNotifications = false
local disableNotificationSounds = false
local showDispatchLog = false

RegisterNetEvent('dispatch:toggleNotifications')
AddEventHandler('dispatch:toggleNotifications', function(state)
    state = tostring(state)
    if state == "on" then
        disableNotifications = false
        disableNotificationSounds = false
        TriggerEvent('DoLongHudText', "Dispatch is now enabled.")
    elseif state == "off" then
        disableNotifications = true
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now disabled.")
    elseif state == "mute" then
        disableNotifications = false
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now muted.")
    else
        TriggerEvent('DoLongHudText', "You need to type in 'on', 'off' or 'mute'.")
    end
end)

local function randomizeBlipLocation(pOrigin)
  local x = pOrigin.x
  local y = pOrigin.y
  local z = pOrigin.z
  local luck = math.random(2)
  y = math.random(25) + y
  if luck == 1 then
      x = math.random(25) + x
  end
  return {x = x, y = y, z = z}
end

local enabledDisaptch = false

RegisterNetEvent('desirerp-dispatch:toggleDispatch', function()
  if exports['isPed']:isPed('myjob') == 'police' then
    exports['desirerp-dispatch']:ToggleDispatch()
  end
end)

exports('ToggleDispatch', function()
  enabledDisaptch = not enabledDisaptch
  if enabledDisaptch then TriggerEvent('DoLongHudText', "Dispatch Enabled") else TriggerEvent('DoLongHudText', "Dispatch Disabled") end
end)

RegisterNetEvent('dispatch:clNotify')
AddEventHandler('dispatch:clNotify', function(pNotificationData)
  if pNotificationData ~= nil then
    local found = false
    local joblol = pNotificationData.origin.job
    for i = 1, #joblol do
      if joblol[i] == exports['isPed']:isPed('myJob') then
        found = true
        break
      end 
    end
    if exports['isPed']:isPed('myJob') == 'iaa' then found = true end
    if found then
          if pNotificationData.origin ~= nil then
            SendNUIMessage({
              mId = "notification",
              eData = pNotificationData
            })
            TriggerEvent('desirerp-dispatch:blip:notifi', pNotificationData)
            if exports['isPed']:isPed('myJob') == 'police' then
              TriggerEvent('desirerp-richPresence:setState', 'Patrolling')
            else
              TriggerEvent('desirerp-richPresence:setState', 'Helping')
            end
          end
      end
    end
end)

RegisterNetEvent('desirerp-dispatch:blip:notifi', function(data)
  if data.dispatchCode == '10-71' then
    -- TriggerServerEvent('InteractSound_SV:PlayOnSource', data.origin.sound, 0.02)
  else
    TriggerServerEvent('InteractSound_SV:PlayOnSource', data.origin.sound, 0.1)
  end
  if data.origin.x ~= 0 then
    if data.dispatchCode == '10-99' then
      local neek = randomizeBlipLocation(data.origin)
      data.origin.x = neek.x
      data.origin.y = neek.y
      data.origin.z = neek.z

    end
    local alpha = 250
    local blip = AddBlipForCoord(data.origin.x, data.origin.y, data.origin.z)

    SetBlipSprite(blip, data.origin.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.5)
    SetBlipColour(blip, data.origin.color)
    SetBlipAsShortRange(blip,  1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.dispatchCode .. ' | ' .. data.dispatchMessage)
    EndTextCommandSetBlipName(blip)
    while alpha ~= 0 do
      Citizen.Wait(120 * 4)
      alpha = alpha - 1
      SetBlipAlpha(blip, alpha)

      if alpha == 0 then
        RemoveBlip(blip)
        return
      end
    end
  end
end)

RegisterNetEvent('event:control:dispatch', function(id)
  showDispatchLogBind()
end)

function showDispatchLogBind()
  if exports['isPed']:isPed('myJob') == 'ems' or exports['isPed']:isPed('myJob') == 'police' then
    showDispatchLog = not showDispatchLog
    SetNuiFocus(showDispatchLog, showDispatchLog)
    SendNUIMessage({
        mId = "showDispatchLog",
        eData = showDispatchLog
    })
  end
end

RegisterNUICallback('setGPSMarker', function(data, cb)
  SetNewWaypoint(data.gpsMarkerLocation.x, data.gpsMarkerLocation.y)
  TriggerEvent('cl:phone:notification', {icon = 'map-marker-alt', color = "#0fa982", header = "Waypoint Set", text = "GPS Marker set to the selected dispatch call." })           
end)
RegisterNUICallback('disableGui', function(data, cb)
  showDispatchLog = not showDispatchLog
  SetNuiFocus(showDispatchLog, showDispatchLog)
  SetNuiFocusKeepInput(showDispatchLog)
end)

RegisterCommand('getunits', function()
  RPC.execute('desirerp-police:getActiveUnits')
end)