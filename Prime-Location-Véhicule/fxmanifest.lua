fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Prime'
description 'Script de location de véhicules en ESX avec ox_target et ox_lib'
version '1.0.0'

shared_script {
    'config.lua',
}
client_script {
    'client.lua',
    '@ox_lib/init.lua'
}
server_script 'server.lua'

dependencies {
    'ox_target',
    'ox_lib',
    'ox_inventory'
}
