PlayerLoaded = false

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(10)
    end
    TriggerServerEvent("initPlayer")
end)

RegisterNetEvent("PlayerInitialized")
AddEventHandler("PlayerInitialized", function(data, items)
    cPlayer = Player.create(data)

    local model = GetHashKey('mp_m_freemode_01')
    Stream:loadModel(model)

    if IsModelInCdimage(model) and IsModelValid(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(-1))
    end
    SetModelAsNoLongerNeeded(model)

    LoadPickups()
    PlayerLoaded = true
    TriggerServerEvent("initZones")
end)

RegisterNetEvent("refreshData:account", function(newAccount)
    cPlayer.account = newAccount
end)

RegisterNetEvent("refreshData:inventory",  function (newInventory)
    cPlayer.inventory = newInventory
end)

RegisterNetEvent("notify")
AddEventHandler("notify", function(type, txt)
    cPlayer:notify(type, txt)
end)

RegisterNetEvent("missionNotify")
AddEventHandler("missionNotify", function(txt, time)
    cPlayer:missionNotify(txt, time)
end)

RegisterNetEvent("helpNotify")
AddEventHandler("helpNotify", function(txt)
    cPlayer:helpNotify(txt)
end)

RegisterNetEvent("teleportToMarker")
AddEventHandler("teleportToMarker", function()
    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

        cPlayer:notify("success", "Vous avez été téléporté à votre marker.")
    else
        cPlayer:notify("error", "Vous n'avez pas placé de marker.")
    end
end)

RegisterCommand("createZone", function(src, args, commandName)
    local testPos = GetEntityCoords(PlayerPedId())
    local pos = {x = testPos.x, y = testPos.y, z = testPos.z}
    local Shop = Zones.create({
        name = args[1],
        pos = vector3(pos.x, pos.y, pos.z),
        blip = {label = "Magasin", sprite = 52, colour = 43, scale = 0.7, pos = vector3(pos.x, pos.y, pos.z)},
        ped = {hash = "mp_m_shopkeep_01", pos = vector3(pos.x, pos.y, pos.z), heading = 168.0, sync = false},
        forJob = "police", -- or jobname
        marker = Markers.create({type = 1, pos = vector3(pos.x-0.75, pos.y-0.75, pos.z-0.70), width = 1.0, height = 1.0, colour = {r = 0, g = 245, b = 245, a = 185}, blowUp = false, faceCam = true, inversed = true}),
        methode = function()
            Key.onPress("e", function()
                print("coucou")
            end)
        end,
        showDistZone = 1.5,
        showDistPed = 40.0,
        showDistMarker = 20.0,
        inputText = "Appuyer sur ~INPUT_CONTEXT~ pour intéragir.",
    })
end, false)