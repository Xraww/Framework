RegisterNetEvent("PersMenu:useItem")
AddEventHandler("PersMenu:useItem", function(item)
    local myPlayer = GetPlayer(source)
    myPlayer:useItem(item)
end)

RegisterNetEvent("PersMenu:renameItem")
AddEventHandler("PersMenu:renameItem", function(item, newLabel)
    local player = GetPlayer(source)

    player:renameItem(item, newLabel)
end)

RegisterNetEvent("PersMenu:giveItem")
AddEventHandler("PersMenu:giveItem", function(targetId, item, count)
    local myPlayer = GetPlayer(source)
    local targetPlayer = GetPlayer(targetId)

    if Items[item] then
        local canCarry, amount = targetPlayer:canCarryItem(item, count)
        if canCarry then
            targetPlayer:addInventory(item, count)
            myPlayer:removeInventory(item, count)
            myPlayer:notify("success", "Vous avez donné ~b~x1 "..Items[item].label)
        else
            myPlayer:notify("error", "Le joueur n'a pas assez de place")
        end
    else
        myPlayer:notify("error", "Cet item n'existe pas")
    end
end)

RegisterNetEvent("PersMenu:dropItem")
AddEventHandler("PersMenu:dropItem", function(item, count, coords)
    local player = GetPlayer(source)

    player:removeInventory(item, count)
    pickups[#pickups+1] = {item = item, label = Items[item].label, count = count, coords = coords, added = false}
    TriggerClientEvent("GM:SendAllPickups", -1, pickups)
end)

RegisterNetEvent("PersMenu:itemInfos")
AddEventHandler("PersMenu:itemInfos", function(item)
    local player = GetPlayer(source)
    local haveUsage = "non"

    if Items.haveUsage(item) == true then
        haveUsage = "oui"
    end

    player:notify("info", ("Item: ~g~%s - %s\n~s~Poid: ~g~%skg\n~s~Utilisable: ~g~%s\n~s~Type: ~g~%s"):format(Items[item].name, Items[item].label, Items[item].weight, haveUsage, Items[item].type))
end)