PlayerLoaded = false

CreateThread( function()
    while not NetworkIsSessionStarted() do
        Wait(10)
    end
    TriggerServerEvent("initPlayer")
end)

RegisterNetEvent("PlayerInitialized")
AddEventHandler("PlayerInitialized", function(data, items)
    cPlayer = Player.new(data)
    PlayerLoaded = true
end)

RegisterNetEvent("notify")
AddEventHandler("notify", function(type, txt)
    cPlayer:notify(type, txt)
end)