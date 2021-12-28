Accessories = {}
local accessoriesParts = {[1] = {name = "mask", max = 147}, [3] = {name = "gloves", max = 167}, [5] = {name = "bag", max = 80}, [7] = {name = "chains", max = 131}, [9] = {name = "bulletproof", max = 37}}

local function GetPartFromValue(part)
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

local function GetLabelFromValue(val)
    if val == "mask" then
        return "Masque"
    elseif val == "gloves" then
        return "Gants"
    elseif val == "bag" then
        return "Sac"
    elseif val == "chains" then
        return "Chaines"
    elseif val == "bulletproof" then
        return "Gilet pare-balles"
    end
end

function Accessories.add(params)
    if Accessories[params.name] then
        Trace("L'accéssoire ^1"..params.name.."^0 existe déjà")
    else
        Accessories[params.name] = {
            name = params.name, 
            label = params.label,
            type = params.type,
            weight = params.weight,
            handler = nil,
        }
        --Trace("L'accéssoire ^4"..Accessories[params.name].label.."^0 a bien été initialisé")
    end
end

function Accessories.registerUsage(accessory, handler)
    CreateThread(function()
        if Accessories[accessory] and handler then
            Accessories[accessory].handler = handler
        else
            Trace("L'accéssoire ^1"..accessory.."^0 n'existe pas ou ne possède pas d'usage")
        end
    end)
end

function Accessories.use(source, accessory)
    local src = source
    if Accessories[accessory] and Accessories[accessory].handler then
        Accessories[accessory].handler(src)
    else
        Trace("L'accéssoire ^1"..accessory.."^0 n'existe pas ou ne possède pas d'usage")
    end
end

RegisterNetEvent("Accessories:registerAccessories")
AddEventHandler("Accessories:registerAccessories", function()
    for k,v in pairs(accessoriesParts) do
        for i=0, accessoriesParts[k].max, 1 do
            for j=1, variationsMaxColours[v.name][v.name.." #"..i], 1 do
                local accessoryName = ("%s_%s_%s"):format(string.lower(v.name), i, j)
                local accessoryLabel = ("%s #%s-%s"):format(GetLabelFromValue(v.name), i, j)
                
                Accessories.add({
                    name = accessoryName, 
                    label = accessoryLabel,
                    type = "accessory",
                    weight = 0.2,
                })

                Accessories.registerUsage(accessoryName, function(id)
                    SetPedComponentVariation(GetPlayerPed(id), GetPartFromValue(v.name), i, j-1, 2)
                    local myPlayer = GetPlayer(id)
                    myPlayer:notify("accessory", "Vous avez mis: ~b~"..accessoryLabel)
                end)
            end
        end
    end
    Trace("Accessories loaded")
end)