RegisterCommand("chestCreator", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    
    if myPlayer:isAdmin() then
        myPlayer:triggerClient("Chest:openChestCreator")
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterNetEvent("Chest:createChest")
AddEventHandler("Chest:createChest", function(data)
    local player = GetPlayer(source)

    if not Chests[data.name] then
        local params = {name = data.name, label = data.label, owner = nil, pos = data.pos}

        if data.owner == "moi" then
            params.owner = player.identifier
        else
            params.owner = data.owner
        end

        if data.code then params.code = data.code end

        Chest.create(params)
        player:notify("success", "Votre coffre a bien été crée")
    else
        player:notify("error", "Un coffre avec ce nom existe déjà")
    end
end)

RegisterNetEvent("Chest:addItem")
AddEventHandler("Chest:addItem", function(data, item, count)
    local myPlayer = GetPlayer(source)
    local zChest = GetChest(data.name)

    if zChest:canStockItem(item, count) then
        if zChest:addItem(item, count) then
            myPlayer:notify("success", ("Vous avez déposé x%s %s dans le ~b~coffre"):format(count, Item[item].label))
        else
            myPlayer:notify("error", "Cet item n'existe pas et ne peut donc pas être ajouté dans le ~b~coffre")
        end
    else
        myPlayer:notify("error", "Il n'y a pas assez de place")
    end
end)

RegisterNetEvent("Chest:removeItem")
AddEventHandler("Chest:removeItem", function(data, item, count)
    local myPlayer = GetPlayer(source)
    local zChest = GetChest(data.name)

    if zChest:removeItem(item, count) then
        myPlayer:notify("success", ("Vous avez retiré x%s %s du ~b~coffre"):format(count, Item[item].label))
    else
        myPlayer:notify("error", "Cet item n'existe pas et ne peut donc pas être stocké dans le ~b~coffre")
    end
end)

RegisterNetEvent("Chest:getInventory")
AddEventHandler("Chest:getInventory", function(data)
    local myPlayer = GetPlayer(source)
    local zChest = GetChest(data.name)

    myPlayer:triggerClient("Chest:cbChestInventory")
end)

-- Loop save chest (minimal)