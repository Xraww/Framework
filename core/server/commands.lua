RegisterCommand("giveitem", function(source, args)
    local myPlayer = GetPlayer(source)
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
                    myPlayer:addInventory(item, count)
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
end, false)

RegisterCommand("clearinv", function(source, args)
    local id = tonumber(args[1])
    local myPlayer = GetPlayer(source)
    local targetPlayer = GetPlayer(id)

    targetPlayer.inventory = {}
    targetPlayer:saveInventory()
    myPlayer:notify("success", "Vous avez clear l'inventaire du joueur: ~r~"..args[1])
end, false)

RegisterCommand("inv", function(source, args)
    local myPlayer = GetPlayer(source)
    local inventory = myPlayer:getInventory(false)

    print(json.encode(inventory))
end, false)

RegisterCommand("useItem", function(source, args)
    local myPlayer = GetPlayer(source)
    local item = args[1] 

    Items.use(source, item)
end, false)

RegisterCommand("id", function(source, args)
    local myPlayer = GetPlayer(source)
    myPlayer:notify("info", "Vous êtes id: ~b~"..source) 
end, false)

RegisterCommand("pos", function(source, args)
    local myPlayer = GetPlayer(source)
    local c, h = myPlayer:getCoords()

    print(c, h)
end, false)

RegisterCommand("weight", function(source, args)
    local myPlayer = GetPlayer(source)
    myPlayer:notify("info", "Vous portez: ~b~"..myPlayer.weight.."kg") 
end, false)

RegisterCommand("saveCoords", function(source, args)
    local myPlayer = GetPlayer(source)
    local coords, heading = myPlayer:getCoords()
    myPlayer:saveCoords({x = coords.x, y = coords.y, z = coords.z, h = heading})
    myPlayer:notify("succeess", "Vous avez sauvegardé votre position.") 
end, false)