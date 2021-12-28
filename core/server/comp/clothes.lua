Clothes = {}
local clothesParts = {[4] = {name = "trousers", max = 114}, [6] = {name = "shoes", max = 90}, [8] = {name = "tshirt", max = 143}, [11] = {name = "torso", max = 289}}

local function GetPartFromValue(part)
    if part == "trousers" then
        return 4
    elseif part == "shoes" then
        return 6
    elseif part == "tshirt" then
        return 8
    elseif part == "torso" then
        return 11
    end
end

function Clothes.add(params)
    if Clothes[params.name] then
        Trace("Le vêtement ^1"..params.name.."^0 existe déjà")
    else
        Clothes[params.name] = {
            name = params.name, 
            label = params.label,
            type = params.type,
            weight = params.weight,
            handler = nil,
        }
        --Trace("Le vêtement ^4"..Clothes[params.name].label.."^0 a bien été initialisé")
    end
end

function Clothes.registerUsage(clothe, handler)
    CreateThread(function()
        if Clothes[clothe] and handler then
            Clothes[clothe].handler = handler
        else
            Trace("Le vêtement ^1"..clothe.."^0 n'existe pas ou ne possède pas d'usage")
        end
    end)
end

function Clothes.use(source, clothe)
    local src = source
    if Clothes[clothe] and Clothes[clothe].handler then
        Clothes[clothe].handler(src)
    else
        Trace("Le vêtement ^1"..clothe.."^0 n'existe pas ou ne possède pas d'usage")
    end
end

RegisterNetEvent("Clothes:registerClothes")
AddEventHandler("Clothes:registerClothes", function()
    for k,v in pairs(clothesParts) do
        for i=0, clothesParts[k].max, 1 do
            for j=1, variationsMaxColours[v.name][v.name.." #"..i], 1 do
                local clotheName = ("%s_%s_%s"):format(string.lower(v.name), i, j)
                local clotheLabel = ("%s #%s-%s"):format(v.name, i, j)
                
                Clothes.add({
                    name = clotheName, 
                    label = clotheLabel,
                    type = "clothe",
                    weight = 0.2,
                })

                Clothes.registerUsage(clotheName, function(id)
                    SetPedComponentVariation(GetPlayerPed(id), GetPartFromValue(v.name), i, j-1, 2)
                end)
            end
        end
    end
    Trace("Clothes loaded")
    TriggerEvent("Clothes:registerAccessories")
end)