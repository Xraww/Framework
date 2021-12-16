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