RegisterNetEvent("GM:initPlayer")
AddEventHandler("GM:initPlayer", function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(alreadyExist)
        if alreadyExist[1] then
            sPlayer = Player.create(src, identifier, alreadyExist[1])
            Trace("Initialisation d'un joueur avec l'id: [^4"..src.."^0]")
        else
            local baseAccounts = json.encode(sConfig.Base.Accounts)
            local baseJob = json.encode(sConfig.Base.Job)
            local baseFaction = json.encode(sConfig.Base.Faction)

            Trace("Création d'un joueur avec l'id: [^4"..src.."^0]")
            MySQL.Async.execute('INSERT INTO players (identifier, rank, accounts, job, faction) VALUES (@identifier, @rank, @accounts, @job, @faction)', {
                ['@identifier'] = identifier,
                ['@rank'] = "user",
                ['@accounts'] = baseAccounts,
                ['@job'] = baseJob,
                ['@faction'] = baseFaction,
            }, function()
                local data = {
                    accounts = baseAccounts,
                    job = baseJob,
                    faction = baseFaction,
                }
                sPlayer = Player.create(src, identifier, data)
            end)
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local myPlayer = GetPlayer(src)
    myPlayer:save()
end)

function rankExist(rankName)
    local bool = false
    for rank, v in pairs(shConfig.rankList) do
        if rank == rankName then
            return true
        else
            bool = false
        end
    end
    return false
end

function Trace(arg)
    print("^6[Xraww]^0 "..arg)
end

local Zones = {}

RegisterNetEvent("Zones:setInZone")
AddEventHandler("Zones:setInZone", function(zone)
    Zones[source] = zone
end)

RegisterNetEvent("Zones:setOutOfZone")
AddEventHandler("Zones:setOutOfZone", function()
    Zones[source] = nil
end)