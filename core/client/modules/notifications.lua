function ShowLoadingPrompt(showText, showType)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(showText)
    EndTextCommandBusyspinnerOn(showType)
end

function RemoveLoadingPrompt()
    BusyspinnerOff()
end

function ShowLoadingPromptWithTime(showText, showTime, showType)
    CreateThread(function()
        ShowLoadingPrompt(showText, showType)
        Wait(showTime)
        RemoveLoadingPrompt()
    end)
end

RegisterNetEvent("GM:notify")
AddEventHandler("GM:notify", function(type, txt)
    cPlayer:notify(type, txt)
end)