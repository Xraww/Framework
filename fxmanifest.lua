fx_version 'cerulean'
games { 'gta5' }

Author 'Xraww'

repository 'https://github.com/Xraww/Framework/'

shared_scripts {
    "config/shared.lua"
}

client_scripts {
    "components/RageUI/RMenu.lua",
    "components/RageUI/menu/RageUI.lua",
    "components/RageUI/menu/Menu.lua",
    "components/RageUI/menu/MenuController.lua",
    "components/RageUI/comp/*.lua",
    "components/RageUI/menu/elements/*.lua",
    "components/RageUI/menu/items/*.lua",
    "components/RageUI/menu/panels/*.lua",
    "components/RageUI/menu/windows/*.lua",

    "config/client.lua",
    "core/client/modules/*.lua",
    "core/client/*.lua",

    "addons/**/client/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",

    "config/server.lua",
    "core/server/comp/*.lua",
    "core/server/class/*.lua",
    "core/server/*.lua",

    "addons/**/server/*.lua",
}