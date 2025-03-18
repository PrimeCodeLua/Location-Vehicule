ESX = exports["es_extended"]:getSharedObject()

print('PRIME SCRIPT | Script crée par Prime')

ESX.RegisterUsableItem('rental_papers', function(source)
    TriggerClientEvent('esx:showNotification', source, 'Vous possédez bien les papiers de location.')
end)

RegisterNetEvent('esx_rental:rentVehicle', function(model, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem('rental_papers', 1)
        TriggerClientEvent('esx_rental:spawnVehicle', source, model)
        TriggerClientEvent('esx:showNotification', source, 'Véhicule loué avec succès!')
    else
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez d\'argent!')
    end
end)

RegisterNetEvent('esx_rental:removePapers', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('rental_papers').count > 0 then
        xPlayer.removeInventoryItem('rental_papers', 1)
        TriggerClientEvent('esx:showNotification', source, 'Votre temps de location est écoulé, les papiers ont été retirés.')
    end
end)
