local blips = {
    {title="Fishing", colour=47, id=68, scale=0.7, x = -329.39, y = 6099.56, z = 31.45},
    {title="Fishing Sales", colour=47, id=68, scale=0.7, x = -1845.7978515625, y = -1186.4307861328, z = 13.0029296875},
    {title="Mine", colour=3, id=617, scale=0.7, x = -595.25274658203, y = 2086.6682128906, z = 131.37292480469},
    {title="Sanitation", colour=71, id=318, scale=0.7, x = -353.72308349609, y = -1542.1977539062, z = 27.712768554688},
    {title="Fishing Rentals", colour=2, id=427, scale=0.7, x = -806.87, y = -1497.12, z = 1.59},
    {title="White Widow", colour=2, id=140, scale=0.7, x = 195.82434, y = -241.1122, z = 54.070503},
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, info.scale)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
  end)