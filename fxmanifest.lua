fx_version 'cerulean'
game 'gta5'

description 'QB-Scoreboard - Enhanced Scoreboard for QBCore'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_script 'client/main.lua'
server_script 'server/main.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/notification.css',
    'html/script.js'
}

lua54 'yes'

