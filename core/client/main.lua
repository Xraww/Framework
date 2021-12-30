PlayerLoaded = false
currentInMenu = false
cItems = {}
cClothes = {}
cAccessories = {}

function setPlayerInMenu()
    if currentInMenu then
        currentInMenu = false
    else
        currentInMenu = true
    end
end

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(10)
    end
    TriggerServerEvent("GM:initPlayer")
end)

RegisterNetEvent("GM:PlayerInitialized")
AddEventHandler("GM:PlayerInitialized", function(data, tbl)
    cItems = tbl.items
    cClothes = tbl.clothes
    cAccessories = tbl.accessories
    cPlayer = Player.create(data)

    local model = GetHashKey('mp_m_freemode_01')
    Stream:loadModel(model)

    CreateThread(function()
        ShowLoadingPromptWithTime("Waiting for player datas", 2000, "BUSY_SPINNER_RIGHT")
        Wait(2000)
        ShowLoadingPromptWithTime("Set player datas", 2000, "BUSY_SPINNER_SAVE")
    end)

    Wait(4000)

    if IsModelInCdimage(model) and IsModelValid(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(-1))
    end
    SetModelAsNoLongerNeeded(model)

    if data.coords then
        SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z)
    end

    LoadPickups()
    PlayerLoaded = true
    TriggerServerEvent("Zones:initZones")
end)

RegisterNetEvent("GM:refreshData:account")
AddEventHandler("GM:refreshData:account", function(newAccount)
    cPlayer.account = newAccount
end)

RegisterNetEvent("GM:refreshData:inventory")
AddEventHandler("GM:refreshData:inventory", function(newInventory, newWeight)
    cPlayer.inventory = newInventory
    cPlayer.weight = newWeight
end)

RegisterNetEvent("GM:refreshData:clothes")
AddEventHandler("GM:refreshData:clothes", function(newClothes, newWeight)
    cPlayer.clothes = newClothes
    cPlayer.weight = newWeight
end)

RegisterNetEvent("GM:refreshData:accessories")
AddEventHandler("GM:refreshData:accessories", function(newAccessories, newWeight)
    cPlayer.accessories = newAccessories
    cPlayer.weight = newWeight
end)

RegisterNetEvent("GM:refreshData:job")
AddEventHandler("GM:refreshData:job", function(newJob)
    cPlayer.job = newJob
end)