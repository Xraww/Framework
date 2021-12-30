CreateThread(function()
    CreateThread(function()
        for k,v in pairs(ClotheShops.points) do
            ClotheShops.List[v.name] = Zones.create({
                name = v.name,
                pos = v.pos,
                canSee = {"all"},
                marker = Markers.create({type = 23, pos = v.pos, width = 1.0, height = 1.0, colour = {r = 218, g = 75, b = 43, a = 185}, blowUp = false, faceCam = true, inversed = false}),
                methode = function()
                    Key.onPress("e", function()
                        TriggerEvent("ClotheShops:openMenu")
                    end)
                end,
                showDistZone = 1.5,
                showDistMarker = 20.0,
                inputText = "Appuyer sur ~INPUT_CONTEXT~ pour ~b~vous changer",
            })
        end
    end)
end)