local clothesMaxColours = {}

CreateThread(function()
    MySQL.Async.fetchAll('SELECT clothes_colour FROM clothes', {}, function(alreadyExist)
        for k,v in pairs(alreadyExist[1]) do
            clothesMaxColours = json.decode(v)
        end
        Wait(500)
        TriggerEvent("Items:registerClothes")
    end)
end)

local function GetPartFromValue(type, part)
    if type == "clothe" then
        if part == "trousers" then
            return 4
        elseif part == "shoes" then
            return 6
        elseif part == "tshirt" then
            return 8
        elseif part == "torso" then
            return 11
        end
    else
        if part == "mask" then
            return 1
        elseif part == "gloves" then
            return 3
        elseif part == "bag" then
            return 5
        elseif part == "chains" then
            return 7
        elseif part == "bulletproof" then
            return 9
        end
    end
end

local clothesParts = {[4] = {name = "trousers", max = 114}, [6] = {name = "shoes", max = 90}, [8] = {name = "tshirt", max = 143}, [11] = {name = "torso", max = 289}}

RegisterNetEvent("Items:registerClothes")
AddEventHandler("Items:registerClothes", function()
    for k,v in pairs(clothesParts) do
        for i=0, clothesParts[k].max, 1 do
            for j=1, clothesMaxColours[v.name][v.name.." #"..i], 1 do
                local itemName = ("%s_%s_%s"):format(string.lower(v.name), i, j)
                local itemLabel = ("%s #%s-%s"):format(v.name, i, j)
                
                Items.add({
                    name = itemName, 
                    label = itemLabel,
                    type = "clothe",
                    weight = 0.2,
                })

                Items.registerUsage(itemName, function(id)
                    SetPedComponentVariation(GetPlayerPed(id), GetPartFromValue("clothe", v.name), i, j-1, 2)
                end)
            end
        end
    end
    Trace("Clothes loaded")
    TriggerEvent("Items:registerAccessories")
end)

local accessoriesParts = {[1] = {name = "mask", max = 147}, [3] = {name = "gloves", max = 167}, [5] = {name = "bag", max = 80}, [7] = {name = "chains", max = 131}, [9] = {name = "bulletproof", max = 37}}

RegisterNetEvent("Items:registerAccessories")
AddEventHandler("Items:registerAccessories", function(accessories)
    for k,v in pairs(accessoriesParts) do
        for i=0, accessoriesParts[k].max, 1 do
            for j=1, clothesMaxColours[v.name][v.name.." #"..i], 1 do
                local itemName = ("%s_%s_%s"):format(string.lower(v.name), i, j)
                local itemLabel = ("%s #%s-%s"):format(v.name, i, j)
                
                Items.add({
                    name = itemName, 
                    label = itemLabel,
                    type = "accessory",
                    weight = 0.2,
                })

                Items.registerUsage(itemName, function(id)
                    SetPedComponentVariation(GetPlayerPed(id), GetPartFromValue("accessory", v.name), i, j-1, 2)
                end)
            end
        end
    end
    Trace("Accessories loaded")
end)