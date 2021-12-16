Player = {}
Player.__index = Player

function Player.new(data)
    local self = {}

    self.ped = PlayerPedId()
    self.weight = data.weight
    self.maxWeight = shConfig.maxWeight

	self.accounts = nil
	if data.accounts then
		self.accounts = data.accounts
	end

    self.inventory = nil
	if data.inventory then
		self.inventory = data.inventory
	end

	self.identity = nil
	if data.identity then
		self.identity = data.identity
	end

    return setmetatable(self, Player)
end

function Player:getCoords()
    local coords = GetEntityCoords(self.ped)
    local head = GetEntityHeading(self.ped)
    return coords, head
end

function Player:getWeight()
    return self.weight
end

function Player:getMaxWeight()
    return self.maxWeight
end

function Player:setCoords(coords, head)
    SetEntityCoords(self.ped, coords.x, coords.y, coords.z)
    if head then
        SetEntityHeading(self.ped, head)
    end
end

function Player:freeze(bool)
    FreezeEntityPosition(self.ped, bool)
end

function Player:visible(bool)
    SetEntityVisible(self.ped, bool, 0)
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

function Player:missionNotif(msg, time) 
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

function Player:helpNotify(msg)
    if not IsHelpMessageOnScreen() then
		SetTextComponentFormat('STRING')
		AddTextComponentString(msg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end