sConfig = {
    savingCoords = 5,
    saving = 10,
    chestSaving = 15,
}

sConfig.Base = {
    Coords = { 
        vector3(0.0, 0.0, 0.0),
        0.0,
    },
    Accounts = { 
        money = 1500, 
        bank = 3500, 
        black = 0, 
    }, 
    Job = { 
        name = "none", 
        grade = 1,
    }, 
    Faction = { 
        name = "none", 
        grade = 1,
    },
}

sConfig.Items = {
    ["bread"] = function(source) 
        local myPlayer = GetPlayer(source)
        myPlayer:notify("item", "Utilisation de l'item: ~o~Pain")
        myPlayer:removeInventory("bread", 1)
    end,
    ["water"] = function(source) 
        local myPlayer = GetPlayer(source)
        myPlayer:notify("item", "Utilisation de l'item: ~b~Eau")
        myPlayer:removeInventory("water", 1)
    end,
}