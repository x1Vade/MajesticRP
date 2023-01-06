





games {"gta5"}

fx_version "cerulean"

description "Weapons"

dependencies  {
  "damage-events"
}

client_scripts {
  "@desirerp-errorlog/client/cl_errorlog.lua",
  "@desirerp-lib/client/cl_rpc.lua",
 -- "client.lua",
  "modes.lua",
  "melee.lua",
  "pickups.lua"
}

shared_script {
  "@desirerp-lib/shared/sh_util.lua"
}
server_scripts {
  "@desirerp-lib/server/sv_rpc.lua",
  "@desirerp-lib/server/sv_sql.lua",
  "server.lua"
}

server_export "getWeaponMetaData"
server_export "updateWeaponMetaData"

exports {
  "toName",
  "findModel"
}
