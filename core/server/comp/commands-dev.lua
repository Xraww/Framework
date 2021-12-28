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
    local item = args[1] 

    Items.use(src, item)
end, false)

RegisterCommand("useClothe", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    local item = args[1] 

    Clothes.use(src, item)
end, false)

RegisterCommand("useAccessory", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    local item = args[1] 

    Accessories.use(src, item)
end, false)

RegisterCommand("useAccessory", function(src, args, commandName)
    local myPlayer = GetPlayer(src)
    local item = args[1] 

    Accessories.use(src, item)
end, false)

RegisterCommand("createItem", function(src, args, commandName)
    local params = {
        name = args[1],
        label = args[2],
        weight = tonumber(args[3]),
        type = args[4],
    }
    Items.create(params)
end, false)

RegisterCommand("setInBucket", function(src, args)
    local myPlayer = GetPlayer(src)
    local state = args[1]
    local bucketId = tonumber(args[2])

    if state == "enter" then
        myPlayer:enterBucket(bucketId)
        myPlayer:triggerClient("GM:getDevInfos", GetPlayerRoutingBucket(myPlayer.id), os.date("%X"))
    else
        myPlayer:leaveBucket()
        myPlayer:triggerClient("GM:getDevInfos", GetPlayerRoutingBucket(myPlayer.id), os.date("%X"))
    end
end, false)

RegisterNetEvent("dev:printServerTbl")
AddEventHandler("dev:printServerTbl", function(tbl)
    local file = LoadResourceFile(GetCurrentResourceName(), "dev.log")
    SaveResourceFile(GetCurrentResourceName(), "dev.log", json.encode(tbl), -1)
end)

RegisterNetEvent("dev:insertClothesColour")
AddEventHandler("dev:insertClothesColour", function(tbl)
    MySQL.Async.execute('INSERT INTO clothes (clothes_colour) VALUES (@clothes_colour)', {
        ['@clothes_colour'] = json.encode(tbl),
    }, function()
        Trace("MySQL clothes saved !")
    end)
end)

RegisterCommand("saveMe", function(src, args, commandName)
    local myPlayer = GetPlayer(src)

    myPlayer:save(false)
end, false)