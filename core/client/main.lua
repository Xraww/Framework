PlayerLoaded = false
currentInMenu = false

function setPlayerInMenu()
    if currentInMenu then
        currentInMenu = false
    else
        currentInMenu = true
    end
    print("setPlayerInMenu: called")
end

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(10)
    end
    TriggerServerEvent("GM:initPlayer")
end)

RegisterNetEvent("GM:PlayerInitialized")
AddEventHandler("GM:PlayerInitialized", function(data, items)
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
    TriggerServerEvent("Zones:initZones")
end)

RegisterNetEvent("GM:refreshData:account")
AddEventHandler("GM:refreshData:account", function(newAccount)
    cPlayer.account = newAccount
end)

RegisterNetEvent("GM:refreshData:inventory")
AddEventHandler("GM:refreshData:inventory", function(newInventory)
    cPlayer.inventory = newInventory
end)

RegisterNetEvent("GM:refreshData:job")
AddEventHandler("GM:refreshData:job", function(newJob)
    cPlayer.job = newJob
end)

RegisterNetEvent("GM:notify")
AddEventHandler("GM:notify", function(type, txt)
    cPlayer:notify(type, txt)
end)

RegisterNetEvent("GM:teleportToMarker")
AddEventHandler("GM:teleportToMarker", function()
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

        cPlayer:notify("success", "Vous avez été téléporté à votre marker")
    else
        cPlayer:notify("error", "Vous n'avez pas placé de marker")
    end
end)