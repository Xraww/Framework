Player = {}
Player.__index = Player
PlayerData = {}

function GetPlayer(id)
    return PlayerData[id]
end

function Player.create(id, identifier, data)
    local self = {}
	setmetatable(self, Player)

    self.id = id
    self.identifier = identifier
    self.perm = data.perm or "user"
    self.weight = data.weight or 0
    self.maxWeight = shConfig.maxWeight

    self.accounts = nil
	if data.accounts then
		self.accounts = json.decode(data.accounts)
	end

    self.inventory = {}
	if data.inventory then
        local foundItems = {}
        local inventory = json.decode(data.inventory)

        for name,count in pairs(inventory) do
            local item = ItemList[name]

            if item then
                foundItems[name] = count
            else
                Trace(("Item ^1invalide^0 (^4%s^0) détecté dans l'inventaire du joueur: %s"):format(name, self.identifier))
            end
        end

        for name,item in pairs(ItemList) do
            local count = foundItems[name] or 0
            if count > 0 then self.weight = self.weight + (item.weight * count) end

            self.inventory[name] = {name = name, label = item.label, count = count}
        end
	end

    self.identity = nil
	if data.identity then
		self.identity = json.decode(data.identity)
	end

    if self.identity == nil then
        Trace("The player with the id: "..id.." don't have identity.")
        -- createPlayerIdentity
    end

	PlayerData[self.id] = self
	self:triggerClient("PlayerInitialized", PlayerData[self.id])
end

function Player:triggerClient(eventName, ...)
    TriggerClientEvent(eventName, self.id, ...)
end

function Player:notify(type, txt)
    self:triggerClient("notify", type, txt)
end

function Player:isAdmin()
    if self.perm ~= "user" and self.perm == "dev" or "admin" or "mod" then 
        return true 
    else 
        return false
    end
end

function Player:getCoords()
    local pos, h = GetEntityCoords(GetPlayerPed(self.id)), GetEntityHeading(GetPlayerPed(self.id))
    return pos, h
end

function Player:isNearZone()
    if Zones[self.id] then
        local actualZone = Zones[self.id]
        local coords, head = self:getCoords()
        local myPos = vector3(coords.x, coords.y, coords.z)
        local Pos = vector3(actualZone.pos.x, actualZone.pos.y, actualZone.pos.z)
        if #(myPos - Pos) <= actualZone.radius then
            return true
        else
            if self:isAdmin() then
                return
            end
            DropPlayer(self.id, "[Anticheat] - Téléportation")
        end
    else
        if self:isAdmin() then
            return
        end
        DropPlayer(self.id, "[Anticheat] - Téléportation")
    end
end

function Player:save()
    local myCoords, myHead = self:getCoords()
    MySQL.Async.execute('UPDATE players SET perm = @perm, accounts = @accounts, job = @job, faction = @faction, coords = @coords, inventory = @inventory WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@perm'] = self.perm,
        ['@job'] = json.encode(self.job),
        ['@faction'] = json.encode(self.faction),
        ['@accounts'] = json.encode(self.accounts),
        ['@inventory'] = json.encode(self:getInventory(true)),
        ['@coords'] = json.encode({x = myCoords.x, y = myCoords.y, z = myCoords.z, h = myHead})
    })
    Trace("[^4"..self.id.."^0] - "..self.identity.lastname.." "..self.identity.firstname.." s'est déconnecté, sauvegarde éffectué.")
end

-------------------------------------------------------------- Inventory --------------------------------------------------------------

function Player:getInventory(minimal)
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

function Player:canUseItem(item)
    if ItemList[item].handler then
        return true
    end
end

function Player:useItem(item)
    if self:canUseItem(item) then
        Items.use(self.id, item)
    else
        self:notify("error", "Vous ne pouvez pas utiliser cet item.")
    end
end

function Player:canCarryItem(item, count)
    if ItemList[item] then
        if self.weight <= self.maxWeight then
            local calc = (self.weight + (ItemList[item].weight * count))
            if calc <= self.maxWeight then
                return true, calc
            else
                return false, calc
            end
        else
            return false
        end
    else
        return false 
    end
end

function Player:addInventory(item, count)
    if ItemList[item] then
        if self.inventory[item] then
            if (self.weight + (ItemList[item].weight * count)) <= self.maxWeight then
                self.inventory[item].count = self.inventory[item].count + count
                self.weight = self.weight + (ItemList[item].weight * count)

                local str = string.format("~g~x%s %s", count, ItemList[item].label)
                self:notify("item", "Vous avez reçu "..str)
                self:triggerClient("refreshData:inventory", self.inventory)
                return true
            else
                self:notify("item", "Vous avez trop de ~r~"..ItemList[item].label.."~s~ sur vous, ou vous êtes trop lourd.")
                return false
            end
        else
            if (self.weight + (ItemList[item].weight * count)) <= self.maxWeight then
                self.inventory[item] = {}
                self.inventory[item].label = ItemList[item].label
                self.inventory[item].name = item
                self.inventory[item].count = count
                self.weight = self.weight + (ItemList[item].weight * count)

                local str = string.format("~g~x%s %s", count, ItemList[item].label)
                self:notify("item", "Vous avez reçu "..str)
                self:triggerClient("refreshData:inventory", self.inventory)
                return true
            else
                self:notify("item", "Vous avez trop de ~r~"..ItemList[item].label.."~s~ sur vous, ou vous êtes trop lourd.")
                return false
            end
        end
    end
end

function Player:removeInventory(item, count)
    if ItemList[item] then
        if self.inventory[item] then
            if (self.inventory[item].count - count) >= 0 then
                self.inventory[item].count = self.inventory[item].count - count
                self.weight = self.weight - (ItemList[item].weight * count)

                if (self.inventory[item].count) == 0 then
                    self.inventory[item] = nil      
                end

                local str = string.format("~r~x%s %s", count, ItemList[item].label)
                self:notify("item", "Vous avez perdu "..str)
                self:triggerClient("refreshData:inventory", self.inventory)
            end
        end
    end
end

function Player:saveInventory()
    local inventory = json.encode(self:getInventory(true))
    MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@inventory'] = inventory
    }, function()
        self:triggerClient("refreshData:inventory", self.inventory)
    end)
end