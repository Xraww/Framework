RegisterCommand("pos", function(src, args)
    local myPlayer = GetPlayer(src)
    local c, h = myPlayer:getCoords()

    print(c, h)
end, false)

RegisterCommand("inv", function(src, args)
    local myPlayer = GetPlayer(src)
    local inventory = myPlayer:getInventory(false)

    print(json.encode(inventory))
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

RegisterCommand("createItem", function(src, args, commandName)
    local params = {
        name = "choco",
        label = "Chocolat",
        weight = 0.6,
        type = "standard",
    }
    Items.create(params)
end, false)