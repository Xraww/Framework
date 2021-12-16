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