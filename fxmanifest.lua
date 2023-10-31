fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'Fistsofury : Job Alerting script'
game 'rdr3'
lua54 'yes'
version '1.0'
author 'Fistsofury'

client_scripts { 
    'client/client.lua'
}

shared_scripts {
    'config.lua'
}
files {
    'html/index.html',
    'html/app/css/styles.css',
    'html/app/app.js',
    'html/app/css/Partchment_bk.jpg'
}

ui_page 'html/index.html'

server_scripts {
    'server/server.lua'
}