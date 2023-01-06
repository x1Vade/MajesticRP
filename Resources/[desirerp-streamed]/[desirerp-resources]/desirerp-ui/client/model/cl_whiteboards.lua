local currentClassRoomBoardUrl = "https://cdn.discordapp.com/attachments/979775387896774661/982377179751018577/unknown.png"
local currentMeetingRoomBoardUrl = "https://cdn.discordapp.com/attachments/979775387896774661/982377179751018577/unknown.png"
local inClassRoom, inMeetingRoom = false, false
local dui = nil
pURL = nil
--[[

    Events

]]

Citizen.CreateThread(function()

    exports["desirerp-polyzone"]:AddPolyZone("mrpd_classroom",
        {vector2(448.41372680664, -990.47613525391), vector2(439.50704956055, -990.55731201172),
         vector2(439.43478393555, -981.08758544922), vector2(448.419921875, -981.26306152344),
         vector2(450.23190307617, -983.00885009766), vector2(450.25042724609, -988.77667236328)}, {
            gridDivisions = 25,
            minZ = 34.04,
            maxZ = 37.69
        })
    exports["desirerp-polyzone"]:AddBoxZone("mrpd_meetingroom", vector3(474.07, -995.08, 30.69), 10.2, 5.2, {
        heading = 0,
        minZ = 29.64,
        maxZ = 32.84
    })

    exports["desirerp-polytarget"]:AddBoxZone("mrdp_change_picture", vector3(439.44, -985.89, 34.97), 1.0, 0.4, {
        heading = 0,
        minZ = 35.37,
        maxZ = 36.17
    })

    exports["desirerp-polytarget"]:AddBoxZone("mrpd_meetingroom_screen", vector3(474.02, -1001.79, 30.69), 3.6, 2.8, {
        heading = 1,
        minZ = 30.54,
        maxZ = 32.54
    })

    exports["desirerp-interact"]:AddPeekEntryByPolyTarget("mrdp_change_picture", {{
        event = "desirerp-polce:changewhiteboardurl",
        id = 'polcechangewhiteboardurlc',
        icon = "circle",
        label = "Change URL",
        parameters = {
            room = "classroom"
        }
    }}, {
        distance = {
            radius = 2.5
        }
    })

    exports["desirerp-interact"]:AddPeekEntryByPolyTarget("mrpd_meetingroom_screen", {{
        event = "desirerp-polce:changewhiteboardurl",
        id = 'polcechangewhiteboardurlm',
        icon = "circle",
        label = "Change URL",
        parameters = {
            room = "meetingroom"
        }
    }}, {
        distance = {
            radius = 2.5
        }
    })

end)


AddEventHandler("desirerp-polyzone:enter", function(pZoneName, pZoneData)
    if pZoneName == "desirerp-police:zone" then
        if exports["desirerp-base"]:getChar("job") == pZoneData.job then
            currentPrompt = pZoneData.zone
            exports["desirerp-interaction"]:showInteraction(zoneData[pZoneData.zone].promptText)
            listenForKeypress(pZoneData.zone, pZoneData.action)
        end
    elseif pZoneName == "mrpd_classroom" then
        if not dui then
            dui = exports["desirerp-lib"]:getDui(currentClassRoomBoardUrl)
            AddReplaceTexture("prop_planning_b1", "prop_base_white_01b", dui.dictionary, dui.texture)
        else
            exports["desirerp-lib"]:changeDuiUrl(dui.id, currentClassRoomBoardUrl)
        end
        inClassRoom = true
    elseif zone == "mrpd_meetingroom" then
        if not dui then
          dui = exports["desirerp-lib"]:getDui(currentMeetingRoomBoardUrl)
          AddReplaceTexture("prop_planning_b1", "prop_base_white_01b", dui.dictionary, dui.texture)
        else
          exports["desirerp-lib"]:changeDuiUrl(dui.id, currentMeetingRoomBoardUrl)
        end
        inMeetingRoom = true
    end
end)

AddEventHandler("desirerp-polyzone:exit", function(pZoneName, pZoneData)
    if pZoneName == "desirerp-police:zone" then
        exports["desirerp-interaction"]:hideInteraction()
        listening = false
        currentPrompt = nil
    elseif pZoneName == "mrpd_classroom" then
        RemoveReplaceTexture("prop_planning_b1", "prop_base_white_01b")
        if dui ~= nil then
            exports["desirerp-lib"]:releaseDui(dui.id)
            dui = nil
        end
        inClassRoom = false
    elseif zone == "mrpd_meetingroom" then
        RemoveReplaceTexture("prop_planning_b1", "prop_base_white_01b")
        if dui ~= nil then
            exports["desirerp-lib"]:releaseDui(dui.id)
            dui = nil
        end
        inMeetingRoom = false
    end
end)



AddEventHandler("desirerp-polce:changewhiteboardurl", function(pParams)
     exports['desirerp-interface']:openApplication('textbox', {
        callbackUrl = 'desirerp-ui:WhiteboardURL',
        key = 1,
        items = {
          {
            icon = "link",
            label = "URL",
            name = "url",
          },
        },
        show = true,
      })
      pURL = pParams.room
end)

RegisterInterfaceCallback('desirerp-ui:WhiteboardURL', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    TriggerServerEvent("police:changewhiteboard", data.values.url, pURL)
end)

RegisterNetEvent("police:changewhiteboardcli")
AddEventHandler("police:changewhiteboardcli", function(pUrl, pRoom)
    if pRoom == "classroom" then
        currentClassRoomBoardUrl = pUrl

        if inClassRoom and dui then
            exports["desirerp-lib"]:changeDuiUrl(dui.id, currentClassRoomBoardUrl)
        end
    elseif pRoom == "meetingroom" and inMeetingRoom and dui then
        currentMeetingRoomBoardUrl = pUrl

        if inMeetingRoom and dui then
            exports["desirerp-lib"]:changeDuiUrl(dui.id, currentMeetingRoomBoardUrl)
        end
    end
end)
