------------>Project Alpha<--------------
----->https://discord.gg/EKyPk4QbgD<-----

ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('my_farm:giveItem', function(item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.addInventoryItem(item, amount)
end)
