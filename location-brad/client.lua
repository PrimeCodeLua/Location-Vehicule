local rentedVehicles = {}
local rentalTimeLeft = 0

CreateThread(function()
    for _, location in pairs(Config.Locations) do
        local pedModel = location.model
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do Wait(10) end
        local ped = CreatePed(4, pedModel, location.coords.x, location.coords.y, location.coords.z - 1.0, location.heading, false, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'rental_pnj',
                label = 'Louer un véhicule',
                icon = 'fa-solid fa-car',
                onSelect = function()
                    TriggerEvent('esx_rental:openMenu')
                end
            }
        })
    end
end)

RegisterNetEvent('esx_rental:openMenu', function()
    local options = {}
    for _, v in ipairs(Config.Vehicles) do
        table.insert(options, {
            title = v.name .. ' - $' .. v.price,
            description = 'Cliquez pour louer',
            onSelect = function()
                TriggerServerEvent('esx_rental:rentVehicle', v.model, v.price)
            end
        })
    end
    lib.registerContext({
        id = 'rental_menu',
        title = 'Location de véhicules',
        options = options
    })
    lib.showContext('rental_menu')
end)

RegisterNetEvent('esx_rental:spawnVehicle', function(model)
    local playerPed = PlayerPedId()
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    local vehicle = CreateVehicle(model, Config.SpawnLocation.x, Config.SpawnLocation.y, Config.SpawnLocation.z, Config.SpawnLocation.w, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    table.insert(rentedVehicles, vehicle)
    rentalTimeLeft = Config.RentalTime * 60
    exports['qs-vehiclekeys']:GiveKeys(GetVehicleNumberPlateText(vehicle), model, true)
    StartRentalTimer(vehicle)
end)

function StartRentalTimer(vehicle)
    CreateThread(function()
        while rentalTimeLeft > 0 do
            Wait(60000)
            rentalTimeLeft = rentalTimeLeft - 60
            TriggerEvent('esx:showNotification', 'Il vous reste ' .. math.floor(rentalTimeLeft / 60) .. ' minutes de location.')
        end
        TriggerServerEvent('esx_rental:removePapers')
        exports['qs-vehiclekeys']:RemoveKeys(GetVehicleNumberPlateText(vehicle), GetEntityModel(vehicle))
        TriggerEvent('esx_rental:fadeOutVehicle', vehicle)
    end)
end

RegisterNetEvent('esx_rental:fadeOutVehicle', function(vehicle)
    if DoesEntityExist(vehicle) then
        for i = 255, 0, -5 do
            Wait(50)
            SetEntityAlpha(vehicle, i, false)
        end
        DeleteEntity(vehicle)
    end
end)