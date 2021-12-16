Items = {
    canRegisterUsage = false,
}
ItemList = {}

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM items', {
    }, function(result)
        for _,v in pairs(result) do
            if not ItemList[v.itemName] then
                Items.register(v)
            end
        end
        Items.canRegisterUsage = true
    end)
end)

function Items.register(params)
    if ItemList[params.name] then
        Trace("L'item ^1"..params.name.."^0 existe déjà.")
    else
        ItemList[params.name] = {
            name = params.name, 
            label = params.label,
            type = params.type,
            weight = params.weight,
            handler = nil,
        }
        Trace("L'item ^4"..ItemList[params.name].label.."^0 a bien été initialisé.")
    end
end

function Items.registerUsage(item, handler)
    CreateThread(function()
        while Items.canRegisterUsage == false do
            Wait(50)
        end
        if ItemList[item] and handler then
            ItemList[item].handler = handler
        else
            Trace("L'item ^1"..item.."^0 n'existe pas ou ne possède pas d'usage.")
        end
    end)
end

function Items.use(source, item)
    local src = source
    if ItemList[item] and ItemList[item].handler then
        ItemList[item].handler(src)
    else
        Trace("L'item ^1"..item.."^0 n'existe pas ou ne possède pas d'usage.")
    end
end

for k,v in pairs(sConfig.Items) do 
    Items.registerUsage(k, function(source)
        v(source)
    end)
end