Chest = {}
Chest.__index = Chest
Chests = {}

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM chests', {
    }, function(result)
        for _,v in pairs(result) do
            if not Chest[v.name] then
                Chest.add(v)
            end
        end
    end)
end)

function Chest.create(data)
    local posEnc = json.encode(data.pos)
    MySQL.Async.execute('INSERT INTO chests (name, label, owner, code, pos) VALUES (@name, @label, @owner, @code, @pos)', {
        ['@name'] = data.name,
        ['@label'] = data.label,
        ['@owner'] = data.owner,
        ['@code'] = data.code,
        ['@pos'] = posEnc,
    }, function()
        Chest.add(data)
        Trace("Le coffre "..data.label.."^0 a bien été sauvegardé.")
    end)
end

function Chest.add(data)
    local self = {}
	setmetatable(self, Chest)

    self.name = data.name
    self.label = data.label
    self.owner = data.owner or nil
    self.pos = json.decode(data.pos)
    self.weight = 0
    self.maxWeight = shConfig.chests_maxWeight

    self.code = nil
    if data.code ~= 0 then
        self.code = data.code
    end

    self.inventory = {}
	if data.inventory then
        local foundItems = {}
        local inventory = json.decode(data.inventory)

        for name,count in pairs(inventory) do
            local item = Items[name]

            if item then
                foundItems[name] = count
            else
                Trace(("Item ^1invalide^0 (^4%s^0) détecté dans le coffre: %s - %s"):format(name, self.name, self.owner))
            end
        end

        for name, item in pairs(foundItems) do
            local count = foundItems[name].count

            self.inventory[name] = {name = name, label = Items[name].label, count = count}
            self.weight = self.weight + (Items[name].weight * count)
        end
	end

    Chests[self.name] = self
    Trace("Le coffre "..self.label.."^0 a bien été initialisé.")
end

function Chest:canStockItem()

end

function Chest:addItem()

end

function Chest:removeItem()

end