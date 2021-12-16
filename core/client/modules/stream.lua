Stream = {}

function Stream:loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function Stream:loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end