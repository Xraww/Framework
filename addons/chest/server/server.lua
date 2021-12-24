RegisterCommand("chestCreator", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    
    if myPlayer:isAdmin() then
        myPlayer:triggerClient("openChestCreator")
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
AddEventHandler("Chest:addItem", function()

end)