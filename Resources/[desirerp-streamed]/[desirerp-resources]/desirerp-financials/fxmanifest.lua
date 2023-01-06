fx_version "cerulean"

description "VoidRP - Banking"
author "cool"
version '0.0.1'

lua54 'yes'

game "gta5"

ui_page 'web/build/index.html'

client_scripts {
  "@desirerp-lib/client/cl_rpc.lua",
  "client/cl_*.lua",
  "@desirerp-errorlog/client/cl_errorlog.lua"
}

server_scripts {
  "config.lua",
  "@desirerp-lib/server/sv_rpc.lua",
  "@desirerp-lib/server/sv_sql.lua",
  "server/*",
}

files {
  'web/build/index.html',
  'web/build/**/*'
}

