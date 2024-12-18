fx_version 'bodacious'
game 'gta5'

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@desirerp-errorlog/client/cl_errorlog.lua"

files {
	'html/css/balloon.min.css',
	'html/css/mui.css',
	'html/css/all.min.css',
	'html/ui.html',
	'html/css/materialize.min.css',
	'html/css/*.css',
	'html/js/phone/*.js',
	'html/js/vendor/tinymce/*.js',
	'html/js/vendor/tinymce/icons/default/*.js',
	'html/js/vendor/tinymce/models/dom/*.js',
	'html/js/vendor/tinymce/plugins/**/*.js',
	'html/js/vendor/tinymce/content/**/*.css',
	'html/js/vendor/tinymce/ui/**/*.css',
	'html/js/vendor/tinymce/themes/silver/*.js',

	'html/images/*.png',
	'html/images/*.jpg',
	'html/images/*.svg',
	'html/js/tinymce/*.js',
	'html/js/tinymce/*.css',
	'html/js/tinymce/plugins/**/*.js',
	'html/js/tinymce/themes/**/*.js',
	'html/js/tinymce/models/**/*.js',
	'html/js/tinymce/icons/**/*.js',
	'html/wallpapers/*.png',
	'html/wallpapers/*.jpg',
	'html/wallpapers/*.svg',
	'html/images/cursor.png',
	'html/images/background.png',	
	'html/images/phone-shell.png',
	'html/images/phone-background.jpg',
	'html/images/gurgle.png',
	'html/images/pager2.png',
	'html/webfonts/fa-brands-400.eot',
	'html/webfonts/fa-brands-400.svg',
	'html/webfonts/fa-brands-400.ttf',
	'html/webfonts/fa-brands-400.woff',
	'html/webfonts/fa-brands-400.woff2',
	'html/webfonts/fa-regular-400.eot',
	'html/webfonts/fa-regular-400.svg',
	'html/webfonts/fa-regular-400.ttf',
	'html/webfonts/fa-regular-400.woff',
	'html/webfonts/fa-regular-400.woff2',
	'html/webfonts/fa-solid-900.eot',
	'html/webfonts/fa-solid-900.svg',
	'html/webfonts/fa-solid-900.ttf',
	'html/webfonts/fa-solid-900.woff',
	'html/webfonts/fa-solid-900.woff2',
}

ui_page 'html/ui.html'

shared_scripts {
	"@desirerp-lib/shared/sh_util.lua",
}

client_scripts {
	"@desirerp-lib/client/cl_ui.lua",
	"@desirerp-lib/client/cl_interface.lua",
	'@desirerp-lib/client/cl_rpc.lua',
	'client/cl_assistance.lua',
	'client/cl_account.lua',

	'client/cl_stocks.lua',
	'client/cl_main.lua',
	'client/cl_license.lua',
	'client/cl_license.lua',
	'client/cl_notification.lua',
	'client/cl_business.lua',
	'client/cl_calculadora.lua',
	'client/cl_call.lua',
	'client/cl_contacts.lua',
	'client/cl_debt.lua',
	'client/cl_epinger.lua',
	'client/cl_init.lua',
	'client/cl_jobcenter.lua',
	'client/cl_messages.lua',
	'client/cl_racing.lua',
	'client/cl_twat.lua',
	'client/cl_wenmo.lua',
	'client/cl_yellowpages.lua',
	'client/cl_diamondsports.lua',
	'client/cl_documents.lua',
	'module/*.lua',
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'@desirerp-lib/server/sv_rpc.lua',
	'@desirerp-lib/server/sv_sqlother.lua',
	"server/main.lua",
	"server/sv_*.lua",
	--"server/license.lua",
}

export "pOpen"
export "phasPhone"
export "pNotify"