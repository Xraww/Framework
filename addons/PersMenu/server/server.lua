RegisterNetEvent("useItem")
AddEventHandler("useItem", function(item)
    local myPlayer = GetPlayer(source)
    myPlayer:useItem(item)
end)

RegisterNetEvent("renameItem")
AddEventHandler("renameItem", function(item, newLabel)
    local player = GetPlayer(source)

    player:renameItem(item, newLabel)
end)

RegisterNetEvent("giveItem")
AddEventHandler("giveItem", function(targetId, item, count)
    local myPlayer = GetPlayer(source)
    local targetPlayer = GetPlayer(targetId)

    if ItemList[item] then
        local canCarry, amount = targetPlayer:canCarryItem(item, count)
        if canCarry then
            targetPlayer:addInventory(item, count)
            myPlayer:removeInventory(item, count)
            myPlayer:notify("success", "Vous avez donné ~b~x1 "..ItemList[item].label)
        else
            myPlayer:notify("error", "Le joueur n'a pas assez de place.")
        end
    else
        myPlayer:notify("error", "Cet item n'existe pas.")
    end
end)

RegisterNetEvent("dropItem")
AddEventHandler("dropItem", function(item, count, coords)
    local player = GetPlayer(source)

    player:removeInventory(item, count)
    pickups[#pickups+1] = {item = item, label = ItemList[item].label, count = count, coords = coords, added = false}
    TriggerClientEvent("SendAllPickups", -1, pickups)
end)