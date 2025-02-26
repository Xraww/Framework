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
    self.weight = 0
    self.maxWeight = shConfig.maxWeight

    if rankExist(data.rank) then
        self.rank = data.rank
    else
        self.rank = "user"
    end

    self.accounts = nil
	if data.accounts then
		self.accounts = json.decode(data.accounts)
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
                foundItems[name] = count
                Trace(("Item ^1invalide^0 (^4%s^0) détecté dans l'inventaire du joueur: %s"):format(name, self.identifier))
            end
        end

        for name, item in pairs(foundItems) do
            local count = foundItems[name]

            self.inventory[name] = {name = name, label = Items[name].label, count = count}
            self.weight = self.weight + (Items[name].weight * count)
        end
	end

    Wait(5000) -- remove (it's for dev test)
    self.clothes = {}
    if data.clothes then
        local foundClothes = {}
        local clothes = json.decode(data.clothes)

        for name,count in pairs(clothes) do
            local clothe = Clothes[name]

            if clothe then
                foundClothes[name] = count
            else
                foundClothes[name] = count
                Trace(("Vêtement ^1invalide^0 (^4%s^0) détecté dans l'inventaire du joueur: %s"):format(name, self.identifier))
            end
        end

        for name, clothe in pairs(foundClothes) do
            local count = foundClothes[name]

            self.clothes[name] = {name = name, label = Clothes[name].label, count = count}
            self.weight = self.weight + (Clothes[name].weight * count)
        end
    end

    self.accessories = {}
    if data.accessories then
        local foundAccessories = {}
        local accessories = json.decode(data.accessories)

        for name,count in pairs(accessories) do
            local clothe = Accessories[name]

            if clothe then
                foundAccessories[name] = count
            else
                foundAccessories[name] = count
                Trace(("Accéssoires ^1invalide^0 (^4%s^0) détecté dans l'inventaire du joueur: %s"):format(name, self.identifier))
            end
        end

        for name, clothe in pairs(foundAccessories) do
            local count = foundAccessories[name]

            self.accessories[name] = {name = name, label = Accessories[name].label, count = count}
            self.weight = self.weight + (Accessories[name].weight * count)
        end
    end

    self.job = nil
	if data.job then
        local newJob = json.decode(data.job)
		self.job = {
            name = newJob.name,
            label = Jobs[newJob.name].label,
            grade = {
                id = newJob.grade,
                name = Jobs[newJob.name].grades[newJob.grade].name,
                label = Jobs[newJob.name].grades[newJob.grade].label
            }
        }
	end
    
	self.faction = nil
	if data.faction then
        local newFaction = json.decode(data.faction)
		self.faction = {
            name = newFaction.name,
            label = Factions[newFaction.name].label,
            grade = {
                id = newFaction.grade,
                name = Factions[newFaction.name].grades[newFaction.grade].name,
                label = Factions[newFaction.name].grades[newFaction.grade].label
            }
        }
	end

    self.coords = nil
    self.coords = json.decode(data.coords)

    self.identity = nil
	if data.identity then
		self.identity = json.decode(data.identity)
	end

    if self.identity == nil then
        Trace("Le joueur possédant l'id: "..id.." n'a pas d'identité")
    end

	PlayerData[self.id] = self
	self:triggerClient("GM:PlayerInitialized", PlayerData[self.id], {items = Items, clothes = Clothes, accessories = Accessories})
    self:triggerClient("GM:getDevInfos", GetPlayerRoutingBucket(self.id))
    Wait(3000)
    TriggerClientEvent("Chest:registerChestZoneForServer", self.id, Chests)
end

function Player:triggerClient(eventName, ...)
    TriggerClientEvent(eventName, self.id, ...)
end

function Player:notify(type, txt)
    self:triggerClient("GM:notify", type, txt)
end

function Player:isAdmin()
    if self.rank ~= "user" then 
        return true 
    else 
        return false
    end
end

function Player:getCoords()
    local pos, h = GetEntityCoords(GetPlayerPed(self.id)), GetEntityHeading(GetPlayerPed(self.id))
    return pos, h
end

function Player:isNear(Pos, Radius)
    local coords, head = self:getCoords()
    if #(coords - Pos) <= Radius then
        return true
    end 
    return false
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

function Player:enterBucket(id)
    if id then
        SetPlayerRoutingBucket(self.id, id)
        SetRoutingBucketPopulationEnabled(id, false)
        SetEntityRoutingBucket(GetPlayerPed(self.id), id)
    else
        SetPlayerRoutingBucket(self.id, (self.id + 1000))
        SetRoutingBucketPopulationEnabled((self.id + 1000), false)
        SetEntityRoutingBucket(GetPlayerPed(self.id), (self.id + 1000))
    end
end

function Player:leaveBucket()
    SetPlayerRoutingBucket(self.id, publicSession.id)
    SetRoutingBucketPopulationEnabled(publicSession.id, true)
    SetEntityRoutingBucket(GetPlayerPed(self.id), publicSession.id)
end

function Player:save(disconected)
    local myCoords, myHead = self:getCoords()
    MySQL.Async.execute('UPDATE players SET rank = @rank, accounts = @accounts, job = @job, faction = @faction, coords = @coords, inventory = @inventory, clothes = @clothes, accessories = @accessories WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@rank'] = self.rank,
        ['@job'] = json.encode(self:getJob(true)),
        ['@faction'] = json.encode(self:getFaction(true)),
        ['@accounts'] = json.encode(self.accounts),
        ['@inventory'] = json.encode(self:getInventory(true)),
        ['@clothes'] = json.encode(self:getClothes(true)),
        ['@accessories'] = json.encode(self:getAccessories(true)),
        ['@coords'] = json.encode({x = myCoords.x, y = myCoords.y, z = myCoords.z, h = myHead})
    })
    if disconected then
        Trace("[^4"..self.id.."^0] - "..self.identity.lastname.." "..self.identity.firstname.." s'est déconnecté, sauvegarde éffectué")
    end
end

function Player:saveCoords(coords)
    local xCoords = json.encode(coords)
    MySQL.Async.execute('UPDATE players SET coords = @coords WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@coords'] = xCoords
    })
end

CreateThread(function()
    while true do
        for k,v in pairs(PlayerData) do
            v:save(false)
        end
        Wait(sConfig.saving * 1000 * 60)
    end
end)

CreateThread(function()
    while true do
        for k,v in pairs(PlayerData) do
            local myCoords, myHead = v:getCoords()
            v:saveCoords({x = myCoords.x, y = myCoords.y, z = myCoords.z, h = myHead})
        end
        Wait(sConfig.savingCoords * 1000 * 60)
    end
end)