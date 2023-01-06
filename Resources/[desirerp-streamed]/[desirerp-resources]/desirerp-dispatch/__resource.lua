resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
files {
    'client/dist/index.html',
    'client/dist/js/app.js',
    'client/dist/css/app.css',
}

client_scripts {
    "@desirerp-lib/client/cl_rpc.lua",
	'config.lua',
	'client/*.lua'
}

server_script {
    "@desirerp-lib/server/sv_rpc.lua",
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
}

ui_page 'client/dist/index.html'