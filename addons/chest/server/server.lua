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
    local myPlayer = GetPlayer(source)

    if not Chests[data.name] then
        local params = {name = data.name, label = data.label, owner = {}, type = data.type, pos = data.pos}

        if type(data.owner) == "number" then
            local targetPlayer = GetPlayer(data.owner)
            if targetPlayer ~= nil then
                params.owner = {["100"] = targetPlayer.identifier}
            else
                myPlayer:notify("error", "Aucun joueur ne possède cet id")
                return
            end
        else
            params.owner = {data.owner}
        end

        Chest.create(params, true)
        myPlayer:notify("success", "Votre coffre a bien été crée")
    else
        myPlayer:notify("error", "Un coffre avec ce nom existe déjà")
    end
end)

RegisterNetEvent("Chest:addItem")
AddEventHandler("Chest:addItem", function(data, item, count)
    local myPlayer = GetPlayer(source)
    local zChest = GetChest(data.name)

    if zChest:canStockItem(item, count) then
        if zChest:addItem(item, count) then
            myPlayer:removeInventory(item, count)
            myPlayer:notify("success", ("Vous avez déposé x%s %s dans le ~b~coffre"):format(count, Items[item].label))
            myPlayer:triggerClient("Chest:refreshInventory", zChest.inventory, zChest.weight)
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

    if zChest:removeItem(item, count) and myPlayer:canCarryItem(item, count) then
        myPlayer:addInventory(item, count)
        myPlayer:notify("success", ("Vous avez retiré x%s %s du ~b~coffre"):format(count, Items[item].label))
        myPlayer:triggerClient("Chest:refreshInventory", zChest.inventory, zChest.weight)
    else
        myPlayer:notify("error", "Cet item n'existe pas et ne peut donc pas être stocké dans le ~b~coffre")
    end
end)

RegisterNetEvent("Chest:giveAccess")
AddEventHandler("Chest:giveAccess", function(id, chestName)
    local zChest = GetChest(chestName)
    local myPlayer = GetPlayer(source)
    local targetPlayer = GetPlayer(id)

    if zChest ~= nil then
        if targetPlayer ~= nil then
            
        else
            myPlayer:notify("error", "Aucun joueur ne possède cet id")
        end
    else
        myPlayer:notify("error", "Coffre: Une erreur est survenue (coffre inconnu)")
    end
end)