math.randomseed(os.clock()*100000000000)
math.randomseed(os.clock()*math.random())
math.randomseed(os.clock()*math.random())

local machinePos = vector3(0, 0, 0)
local machineModel = nil
local bet = {}
local currentReels = {}
local activeSlots = {}
local reel = 0
local rot = 0


RegisterNetEvent("desirerp-slotmachines-sv:sitDownAtSlotMachine",function(slot)
    activeSlots = slot
    print(slot)
    local coinValue = 1
    TriggerClientEvent("desirerp-slotmachines-cl:sitDownAtSlotMachine",source, slot)
end)

RegisterNetEvent("desirerp-slotmachines-sv:spinMachine",function(currentSlotMachinePos,currentSlotMachineModel,currentBet,cid)
    machinePos = currentSlotMachinePos
    machineModel = currentSlotMachineModel
    bet = currentBet
    cid = cid
    local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}
			
    local rnd1 = math.random(1,100)
    local rnd2 = math.random(1,100)
    local rnd3 = math.random(1,100)
    if rnd1 > 70 then w.a = w.a + 0.5 end
    if rnd2 > 70 then w.b = w.b + 0.5 end
    if rnd3 > 70 then w.c = w.c + 0.5 end

    TriggerClientEvent('desirerp-slotmachines-cl:startSpin', source, w)
end)

RegisterNetEvent('desirerp-slotmachines-sv:slotsCheckWin')
AddEventHandler('desirerp-slotmachines-sv:slotsCheckWin',function(win, dt)
	CheckForWin(win, dt)
end)

function CheckForWin(w, data)
    print(bet)
	print(w.a, w.b, w.c)
	local a = tonumber(w.a)
	local b = tonumber(w.b)
	local c = tonumber(w.c)
	local pTotalamt = math.random(0, 500)
	local total = pTotalamt
	if a == b and b == c and a == c then
		total = bet*a
	elseif a == 6 and b == 6 then
		total = bet*5
	elseif a == 6 and c == 6 then
		total = bet*5
	elseif b == 5 and c == 5 then
		total = bet*5
		
	elseif a == 5 then
		total = bet*2
	elseif b == 5 then
		total = bet*2
	elseif c == 5 then
		total = bet*2
	end
	if total > 0 then
        print("PREMIO: ", total)
	end
    TriggerClientEvent("desirerp-slotmachines-cl:spinFinished", source, total)
end


RegisterServerEvent('desirerp-casino:slotsLogWin')
AddEventHandler('desirerp-casino:slotsLogWin', function(pWinAmount)
  local user = exports["desirerp-base"]:getModule("Player"):GetUser(source)
  local character = user:getCurrentCharacter()
  local steamName = GetPlayerName(source)

  local identifiers = GetPlayerIdentifiers(source)

  local pDiscord = 'None'
  local pSteam = 'None'

  for k, v in pairs(identifiers) do
      if string.find(v, 'steam') then pSteam = v end
      if string.find(v, 'discord') then pDiscord = v end
  end

  local connect = {
      {
        ["color"] = color,
        ["title"] = "** DesireRP [Casino] | Slots **",
        ["description"] = "Character Name: "..character.first_name.." "..character.last_name.." \n State ID: "..character.id.." \n Steam Name: "..steamName.. "\n Discord ID: "..pDiscord.. " \n Steam Identifier: "..identifiers[1].." \n Won "..pWinAmount.."x Red Chips Playing Slots.",
      }
    }
  PerformHttpRequest("https://discord.com/api/webhooks/1033202036159823892/YrmwnIN3RsRB6fxvt4s_nhq2IoPdaNnh_tY6NF7LIeiRlyXSx-IW-VjWryaBN-T0h5cW", function(err, text, headers) end, 'POST', json.encode({username = "DesireRP | Casino", embeds = connect, avatar_url = "https://i.imgur.com/hMqEEQp.png"}), { ['Content-Type'] = 'application/json' })
end)