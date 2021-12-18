RegisterCommand("giveitem", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local id = tonumber(args[1])
        local targetPlayer = GetPlayer(id)
        local item = args[2]
        local count = tonumber(args[3])

        if #args ~= 3 then 
            myPlayer:notify("error", "Il manque des arguments à votre commande:\n/giveitem id item count") 
        else
            if ItemList[item] then
                if targetPlayer ~= nil and count > 0 then
                    local canCarry, amount = targetPlayer:canCarryItem(item, count)
                    if canCarry then
                        targetPlayer:addInventory(item, count)
                        myPlayer:notify("success", "Vous avez donné ~b~x1 "..ItemList[item].label.."~s~ à l'id ~r~"..args[1])
                    else
                        myPlayer:notify("error", "Le joueur n'a pas assez de place, ~b~"..amount.."kg~s~ en trop.")
                    end
                else
                    myPlayer:notify("error", "Aucun joueur ne possède cet id.")
                end
            else
                myPlayer:notify("error", "Cet item n'existe pas.")
            end
        end
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterCommand("clearinv", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local id = tonumber(args[1])
        local targetPlayer = GetPlayer(id)

        targetPlayer.inventory = {}
        targetPlayer:saveInventory()
        myPlayer:notify("success", "Vous avez clear l'inventaire du joueur: ~r~"..args[1])
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterCommand("saveInventory", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local id = tonumber(args[1])
        local targetPlayer = GetPlayer(id)

        targetPlayer:saveInventory()
        myPlayer:notify("success", "Vous avez sauvegardé l'inventaire du joueur: ~r~"..args[1])
        targetPlayer:notify("info", "Votre inventaire a été sauvegardé.")
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterCommand("useItem", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local item = args[1] 

        Items.use(src, item)
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterCommand("inv", function(src, args)
    local myPlayer = GetPlayer(src)
    local inventory = myPlayer:getInventory(false)

    print(json.encode(inventory))
end, false)

RegisterCommand("weight", function(src, args)
    local myPlayer = GetPlayer(src)
    myPlayer:notify("info", "Vous portez: ~b~"..myPlayer.weight.."kg") 
end, false)

RegisterCommand("id", function(src, args)
    local myPlayer = GetPlayer(src)
    myPlayer:notify("info", "Vous êtes id: ~b~"..src) 
end, false)

RegisterCommand("pos", function(src, args)
    local myPlayer = GetPlayer(src)
    local c, h = myPlayer:getCoords()

    print(c, h)
end, false)

RegisterCommand("rank", function(src, args)
    local myPlayer = GetPlayer(src)
    myPlayer:notify("info", "Vous êtes rank: ~b~"..shConfig.rankList[myPlayer.rank].label) 
end, false)

RegisterCommand("saveCoords", function(src, args)
    local myPlayer = GetPlayer(src)
    local coords, heading = myPlayer:getCoords()
    myPlayer:saveCoords({x = coords.x, y = coords.y, z = coords.z, h = heading})
    myPlayer:notify("succeess", "Vous avez sauvegardé votre position.") 
    -- do an anti spam
end, false)

RegisterCommand("setRank", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local id = tonumber(args[1])
        local targetPlayer = GetPlayer(id)
        local rankName = args[2]
        
        if targetPlayer ~= nil then
            if rankExist(rankName) then
                if shConfig.rankList[myPlayer.rank].lvl > shConfig.rankList[rankName].lvl then
                    targetPlayer.rank = rankName
                    myPlayer:notify("success", ("Vous avez attribué le rank %s à l'id %s"):format(shConfig.rankList[rankName].label, args[1]))
                    myPlayer:notify("success", ("Vous avez été rank %s"):format(shConfig.rankList[rankName].label))
                else
                    myPlayer:notify("error", ("Vous ne pouvez pas attribuer un rank au dessus du votre (%s - %s)"):format(shConfig.rankList[myPlayer.rank].lvl, shConfig.rankList[myPlayer.rank].label))
                end
            else
                myPlayer:notify("error", "Ce groupe n'existe pas.")
            end
        else
            myPlayer:notify("error", "Aucun joueur ne possède cet id.")
        end
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)

RegisterCommand("unRank", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    if myPlayer:isAdmin() then
        local id = tonumber(args[1])
        local targetPlayer = GetPlayer(id)
        local rankName = args[2]
        
        if targetPlayer ~= nil then
            if rankExist(rankName) then
                if shConfig.rankList[myPlayer.rank].lvl > shConfig.rankList[rankName].lvl and shConfig.rankList[myPlayer.rank].lvl > shConfig.rankList[targetPlayer.rank].lvl then
                    targetPlayer.rank = rankName
                    myPlayer:notify("success", ("Vous avez attribué le rank %s à l'id %s"):format(shConfig.rankList[rankName].label, args[1]))
                    myPlayer:notify("success", ("Vous avez été rank %s"):format(shConfig.rankList[rankName].label))
                else
                    myPlayer:notify("error", "Vous ne pouvez pas attribuer un rank au dessus du votre ou unRank cet utilisateur.")
                end
            else
                myPlayer:notify("error", "Ce groupe n'existe pas.")
            end
        else
            myPlayer:notify("error", "Aucun joueur ne possède cet id.")
        end
    else
        Trace(("%s %s a essayé: %s"):format(myPlayer.identity.lastname, myPlayer.identity.firtstname, commandName))
    end
end, false)