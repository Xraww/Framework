PlayerLoaded = false

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(10)
    end
    TriggerServerEvent("initPlayer")
end)

RegisterNetEvent("PlayerInitialized")
AddEventHandler("PlayerInitialized", function(data, items)
    cPlayer = Player.new(data)

    local model = GetHashKey('mp_m_freemode_01')
    Stream:loadModel(model)

    if IsModelInCdimage(model) and IsModelValid(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(-1))
    end
    SetModelAsNoLongerNeeded(model)

    LoadPickups()
    PlayerLoaded = true
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