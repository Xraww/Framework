local function GetKeyForValue(t, value)
    for k,v in pairs(t) do
        if v == value then return k end
    end
    return nil
end

local clothesParts = {[4] = "Pantalon", [6] = "Chaussures", [8] = "Tshirt", [11] = "Torse"}
local clothesLoaded = false

RegisterNetEvent("Items:registerClothes")
AddEventHandler("Items:registerClothes", function(clothes)
    for k,v in pairs(clothes) do
        for i=1, #clothes[k], 1 do
            for index=1, clothes[k][i].colorMax do
                local itemName = ("%s_%s_%s"):format(string.lower(k), i, index)
                local itemLabel = ("%s #%s-%s"):format(k, i, index)
                
                Items.add({
                    name = itemName, 
                    label = itemLabel,
                    type = "clothe",
                    weight = 0.2,
                })

                Items.registerUsage(itemName, function(src)
                    SetPedComponentVariation(GetPlayerPed(src), GetKeyForValue(clothesParts, k), i, index-1, 2)
                end)
            end
        end
    end
    clothesLoaded = true
    Trace("Clothes loaded")
end)

local accessoriesParts = {[1] = "Masque", [3] = "Gant", [5] = "Sac", [7] = "Chaines", [9] = "Gilet par balle"}
local accessoriesLoaded = false

RegisterNetEvent("Items:registerAccessories")
AddEventHandler("Items:registerAccessories", function(accessories)
    while not clothesLoaded do
        Wait(300)
    end

    for k,v in pairs(accessories) do
        for i=1, #accessories[k], 1 do
            for index=1, accessories[k][i].colorMax do
                local itemName = ("%s_%s_%s"):format(string.lower(k), i, index)
                local itemLabel = ("%s #%s-%s"):format(k, i, index)
                
                Items.add({
                    name = itemName, 
                    label = itemLabel,
                    type = "accessory",
                    weight = 0.2,
                })

                Items.registerUsage(itemName, function(src)
                    SetPedComponentVariation(GetPlayerPed(src), GetKeyForValue(accessoriesParts, k), i, index-1, 2)
                end)
            end
        end
    end
    accessoriesLoaded = true
    Trace("Accessories loaded")
end)