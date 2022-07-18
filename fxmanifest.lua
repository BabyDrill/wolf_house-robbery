fx_version 'adamant'

game 'gta5'

author 'BabyDrill'

name 'wolf_house-robbery'

client_scripts {
	'config/config.lua',
	'client/*.lua'
}

server_scripts {
	'config/config.lua',
	'config/configS.lua',
	'server/server.lua'
}

files {
    'html/index.html',
    'html/scripts.js',
    'html/style.css',
    'stream/*.ytyp'
}

ui_page {
	'html/index.html'
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

dependencies {
	'gridsystem'
}