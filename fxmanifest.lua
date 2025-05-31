version "1.0.0"
author "Henri"
description "commands system"

fx_version "cerulean"
game "gta5"
lua54 "yes"

shared_scripts {
	"config.lua",
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
}

server_scripts {
	"server-side/*"
}

client_scripts {
	"client-side/*"
}

escrow_ignore {
	"server-side/functions.lua",
	"client-side/functions.lua",
	"config.lua",
}