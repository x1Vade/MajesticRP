








fx_version 'adamant'

game "gta5"

client_script "@desirerp-lib/client/cl_ui.lua"
client_script "@desirerp-lib/client/cl_interface.lua"
client_script "@desirerp-lib/client/cl_rpc.lua"

client_scripts {
  '@desirerp-lib/client/cl_rpc.lua',
  'client/cl_*.lua',
}

server_script "@desirerp-lib/server/sv_rpc.lua"
server_script "@desirerp-lib/server/sv_sql.lua"
server_scripts {
  'server/sv_*.lua',
  'server/sv_*.js',
}
