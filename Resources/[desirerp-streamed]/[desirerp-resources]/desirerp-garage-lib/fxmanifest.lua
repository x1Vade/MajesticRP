








fx_version "cerulean"

games {"gta5"}

description "iconic Lib"

server_scripts {
	"**/sv_*.lua",
	"**/sv_*.js"
}

client_scripts {
	'@desirerp-lib/client/cl_interface.lua',
	"**/cl_*.lua",
	"**/cl_*.js"
}

shared_script '**/sh_*.*'