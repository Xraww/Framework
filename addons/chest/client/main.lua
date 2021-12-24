local ChestZones = {}

RegisterNetEvent("Chest:registerChestZoneForServer")
AddEventHandler("Chest:registerChestZoneForServer", function(newChest)
    CreateThread(function()
        for k,v in pairs(newChest) do
            ChestZones[newChest[k].name] = Zones.create({
                name = v.name,
                pos = v.pos,
                canSee = v.owner,
                marker = Markers.create({type = 1, pos = v.pos, width = 1.0, height = 1.0, colour = {r = 0, g = 245, b = 245, a = 185}, blowUp = false, faceCam = true, inversed = false}),
                methode = function()
                    Key.onPress("e", function()
                        TriggerEvent("Chest:openChest", v)
                    end)
                end,
                showDistZone = 1.5,
                showDistMarker = 20.0,
                inputText = "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le ~b~coffre",
            })
        end
    end)
end)