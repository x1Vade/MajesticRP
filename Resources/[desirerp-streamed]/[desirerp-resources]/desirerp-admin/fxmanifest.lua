fx_version "cerulean"
description "AdminUI"
author "loleris"
version '0.0.1'
game "gta5"

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@desirerp-lib/server/sv_sqlother.lua',
    '@desirerp-lib/server/sv_rpc.lua',
    '@desirerp-lib/server/sv_rpc.js',
    '@desirerp-lib/server/sv_sql.lua',
    '@desirerp-lib/server/sv_sql.js',
    'dist/server/*.js',
    'server/sv_*.lua'
}

client_scripts {
    '@desirerp-lib/client/cl_rpc.js',
    '@desirerp-lib/client/cl_rpc.lua',
    '@desirerp-lib/client/cl_poly.js',
    'dist/client/*.js',
    'client/cl_*.lua',
}