Chest = {}
Chest.__index = Chest
Chests = {}

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM chests', {
    }, function(result)
        for _,v in pairs(result) do
            if not Chests[v.name] then
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
        Trace("Le coffre "..data.label.."^0 a bien été sauvegardé")
    end)
end

function Chest.add(data)
    local self = {}
    setmetatable(self, Chest)

    self.name = data.name
    self.label = data.label
    self.owner = data.owner
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
            local count = foundItems[name]

            self.inventory[name] = {name = name, label = Items[name].label, count = count}
            self.weight = self.weight + (Items[name].weight * count)
        end
	end

    Chests[self.name] = self
    Trace("Le coffre ^1"..self.label.."^0 a bien été initialisé")
end

function GetChest(name)
    return Chests[name]
end

function Chest:canStockItem(item, count)
    if Items[item] then
        if (self.weight + (Items[item].weight * count)) <= self.maxWeight then
            return true
        end
        return false
    end
    return false
end

function Chest:addItem(item, count)
    if Items[item] then
        if self.inventory[item] then
            self.inventory[item].count = self.inventory[item].count + count
            self.weight = self.weight + (Items[item].weight * count)
            return true
        else
            self.inventory[item] = {}
            self.inventory[item].label = Items[item].label
            self.inventory[item].name = item
            self.inventory[item].count = count
            self.weight = self.weight + (Items[item].weight * count)
            return true
        end
        return false
    end
end

function Chest:removeItem(item, count)
    if Items[item] then
        if self.inventory[item] then
            if (self.inventory[item].count - count) >= 0 then
                self.inventory[item].count = self.inventory[item].count - count
                self.weight = self.weight - (Items[item].weight * count)

                if (self.inventory[item].count) == 0 then
                    self.inventory[item] = nil      
                end
                return true
            end
        end
        return false
    end
end

function Chest:getInventory(minimal)
    if minimal then
        local minimalInventory = {}

        for k,v in pairs(self.inventory) do
            if v.count > 0 then
                minimalInventory[v.name] = v.count
            end
        end
        
        return minimalInventory
    else
        return self.inventory
    end
end

function Chest:save()
    local owner = self.owner
    if type(self.owner) == "table" then
        owner = json.encode(self.owner)
    end
    MySQL.Async.execute('UPDATE chests SET label = @label, owner = @owner, code = @code, inventory = @inventory, pos = @pos WHERE name = @name', {
        ['@name'] = self.name,
        ['@label'] = self.label,
        ['@owner'] = self.owner,
        ['@code'] = self.code,
        ['@inventory'] = json.encode(self:getInventory(true)),
        ['@pos'] = json.encode(self.pos),
    })
    Trace("Sauvegarde en cours du coffre: ^4"..self.label)
end

CreateThread(function()
    while true do
        for k,v in pairs(Chests) do
            v:save()
        end
        Wait(sConfig.chestSaving * 1000 * 60)
    end
end)