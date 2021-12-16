Zones = {}

RegisterNetEvent("initPlayer")
AddEventHandler("initPlayer", function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(alreadyExist)
        if alreadyExist[1] then
            sPlayer = Player.create(src, identifier, alreadyExist[1])
            Trace("Initialisation d'un joueur avec l'id: [^4"..src.."^0].")
        else
            local baseAccounts = json.encode(sConfig.Base.Accounts)

            Trace("Création d'un joueur avec l'id: [^4"..src.."^0].")
            MySQL.Async.execute('INSERT INTO players (identifier, perm, accounts) VALUES (@identifier, @perm, @accounts)', {
                ['@identifier'] = identifier,
                ['@perm'] = "user",
                ['@accounts'] = baseAccounts,
            }, function()
                local data = {
                    accounts = baseAccounts,
                }
                sPlayer = Player.create(src, identifier, data)
            end)
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local player = GetPlayer(src)
    --player:save()
end)

RegisterNetEvent("sendActualZone")
AddEventHandler("sendActualZone", function(source, pos)
    Zones[source] = pos
end)

RegisterNetEvent("resetActualZone")
AddEventHandler("resetActualZone", function(source)
    Zones[source] = nil
end)

function Trace(arg)
    print("^6[Xraww]^0 "..arg)
end