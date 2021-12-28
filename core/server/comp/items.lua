Items = {
    canRegisterUsage = false,
}

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {
    }, function(result)
        for _,v in pairs(result) do
            if not Items[v.itemName] then
                Items.add(v)
            end
        end
        Items.canRegisterUsage = true
    end)
end)

function Items.create(params)
    MySQL.Async.execute('INSERT INTO items (name, label, type, weight) VALUES (@name, @label, @type, @weight)', {
        ['@name'] = params.name,
        ['@label'] = params.label,
        ['@type'] = params.type,
        ['@weight'] = params.weight,
    }, function()
        Items.add(params)
        Trace("L'item ^4"..params.label.."^0 a bien été crée et sauvegardé")
    end)
end

function Items.add(params)
    if Items[params.name] then
        Trace("L'item ^1"..params.name.."^0 existe déjà")
    else
        Items[params.name] = {
            name = params.name, 
            label = params.label,
            type = params.type,
            weight = params.weight,
            handler = nil,
        }
        --Trace("L'item ^4"..Items[params.name].label.."^0 a bien été initialisé")
    end
end

RegisterNetEvent("Items:registerItem")
AddEventHandler("Items:registerItem", function(data)
    Items.add(data)
end)

function Items.registerUsage(item, handler)
    CreateThread(function()
        while Items.canRegisterUsage == false do
            Wait(50)
        end
        if Items[item] and handler then
            Items[item].handler = handler
        else
            Trace("L'item ^1"..item.."^0 n'existe pas ou ne possède pas d'usage")
        end
    end)
end

RegisterNetEvent("Items:registerItemUsage")
AddEventHandler("Items:registerItemUsage", function(item, handler)
    Items.registerUsage(item, handler)
end)

function Items.use(source, item)
    local src = source
    if Items[item] and Items[item].handler then
        Items[item].handler(src)
    else
        Trace("L'item ^1"..item.."^0 n'existe pas ou ne possède pas d'usage")
    end
end

function Items.haveUsage(item)
    if Items[item].handler ~= nil then
        return true
    else
        return false
    end
end

for k,v in pairs(sConfig.Items) do 
    Items.registerUsage(k, function(source)
        v(source)
    end)
end

pickups = {}

RegisterNetEvent("GM:takePickup")
AddEventHandler("GM:takePickup", function(id, item, amount, count)
    GetPickupIfCan(source, id, item, amount, count)
end)

function GetPickupIfCan(id, idPickup, item, amount, count)
    local player = GetPlayer(id)
    if pickups[idPickup] ~= nil then
        if pickups[idPickup].count == count then
            if player:addInventory(item, amount) then
                if pickups[idPickup].count - amount == 0 then
                    pickups[idPickup] = nil
                    TriggerClientEvent("GM:SendAllPickups", -1, pickups, idPickup, true, 0)
                elseif pickups[idPickup].count - amount > 0 then
                    pickups[idPickup].count = pickups[idPickup].count - amount
                    TriggerClientEvent("GM:SendAllPickups", -1, pickups, idPickup, false, pickups[idPickup].count)
                elseif pickups[idPickup].count - amount < 0 then
                    return
                end
            end
        end
    end
end