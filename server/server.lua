ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


negm 12
local Config = Config or {}

-- check if player is a coke plug
function isCokePlug(player)
    return player.getGroup() == Config.CokePlugPermission
end

-- check if player is a VIP
function isVIP(player)
    return player.getGroup() == Config.VIPPermission
end

--  check if player has cocaine in inventory
function hasCocaine(player)
    return player.getInventoryItem(Config.CocaineItem).count > 0
end

--  handle crafting bricks
RegisterServerEvent('craftBrick')
AddEventHandler('craftBrick', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local brickCount = isVIP(xPlayer) and 2 or 1
    for i = 1, brickCount do
        xPlayer.addInventoryItem(Config.CocaineBrickItem, 1)
    end
end)

--  handle turning in bricks to NPC
RegisterServerEvent('turnInBrick')
AddEventHandler('turnInBrick', function(npc)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem(Config.CocaineBrickItem).count > 0 then
        xPlayer.removeInventoryItem(Config.CocaineBrickItem, 1)
        local payment = math.random(Config.MinPayment, Config.MaxPayment)
        xPlayer.addMoney(payment)
        TriggerClientEvent('esx:showNotification', _source, "You received $" .. payment .. " for turning in a cocaine brick.")
    else
        TriggerClientEvent('esx:showNotification', _source, "You don't have any cocaine bricks to turn in.")
    end
end)

--  handler for entering the coke lab
RegisterServerEvent('enterCokeLab')
AddEventHandler('enterCokeLab', function()
    local _source = source
    TriggerClientEvent('enterCokeLab', _source)
end)

--  handler for leaving the coke lab
RegisterServerEvent('leaveCokeLab')
AddEventHandler('leaveCokeLab', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not isCokePlug(xPlayer) then
        if hasCocaine(xPlayer) then
            xPlayer.setInventoryItem(Config.CocaineItem, 0)
            TriggerClientEvent('esx:showNotification', _source, "You are not authorized to leave with this drug.")
        end
    end

    TriggerClientEvent('leaveCokeLab', _source)
end)
