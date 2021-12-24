Player = {}
Player.__index = Player

function Player.create(data)
    local self = {}

    self.identifier = data.identifier
    self.id = data.id
    self.weight = data.weight
    self.maxWeight = shConfig.maxWeight
    self.rank = data.rank

	self.accounts = nil
	if data.accounts then
		self.accounts = data.accounts
	end

    self.inventory = nil
	if data.inventory then
		self.inventory = data.inventory
	end

    self.job = data.job
    self.faction = data.faction

	self.identity = nil
	if data.identity then
		self.identity = data.identity
	end

    return setmetatable(self, Player)
end

function Player:getCoords()
    local coords = GetEntityCoords(PlayerPedId())
    local head = GetEntityHeading(PlayerPedId())
    return coords, head
end

function Player:getWeight()
    return self.weight
end

function Player:getMaxWeight()
    return self.maxWeight
end

function Player:isNear(Pos, Radius)
    local coords, head = self:getCoords()
    if #(coords - Pos) <= Radius then
        return true
    end 
    return false
end

function Player:notify(type, str)
    SetNotificationTextEntry("String")
    if type == "error" then 
        AddTextComponentString("~r~Erreur~s~\n"..str)
        DrawNotification(true, true)
    elseif type == "success" then 
        AddTextComponentString("~g~Succès~s~\n"..str)
        DrawNotification(true, true)
    elseif type == "item" then
        AddTextComponentString("~b~Item~s~\n"..str)
        DrawNotification(true, true)
    elseif type == "info" then
        AddTextComponentString("~b~Info~s~\n"..str)
        DrawNotification(true, true)
    else
        AddTextComponentString(str)
        DrawNotification(true, true)
    end
end

function Player:missionNotify(msg, time) 
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

function Player:helpNotify(msg)
    if not IsHelpMessageOnScreen() then
		SetTextComponentFormat('STRING')
		AddTextComponentString(msg)
		DisplayHelpTextFromStringLabel(0, 0, 1, 5000)
	end
end