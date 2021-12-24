local cat, title, desc, isMenuOpened = "cChest", "Créateur de coffre", "Actions:", false

local function sub(name)
    return cat..name
end

local check = false
local ChestData = {
    name = "",
    label = "",
    owner = "",
    code = "",
    pos = "",
}

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
    check = false
end

function openChestCreator()
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                RageUI.Button("Nom du coffre:", nil, {RightLabel = "~g~"..ChestData.name}, true, {
                    onSelected = function()
                        local name = string.lower(Key.input(25, "Nom du coffre:"))
                        if name ~= nil then
                            ChestData.name = name
                        else
                            cPlayer:notify("error", "Champ invalide")
                        end
                    end
                })
                RageUI.Button("Label du coffre:", nil, {RightLabel = "~g~"..ChestData.label}, true, {
                    onSelected = function()
                        local label = Key.input(25, "Label du coffre:")
                        if label ~= nil then
                            ChestData.label = label
                        else
                            cPlayer:notify("error", "Champ invalide")
                        end
                    end
                })
                RageUI.Button("Propriétaire du coffre", nil, {RightLabel = "~g~"..ChestData.owner}, true, {
                    onSelected = function()
                        local owner = string.lower(Key.input(25, "'Nom du job' ou 'Id de la personne'"))
                        if owner ~= nil then
                            ChestData.owner = owner
                        else
                            cPlayer:notify("error", "Champ invalide")
                        end
                    end
                })

                RageUI.Button("Code du coffre", "Il n'est possible de définir un code que si le propriétaire est un joueur et non un job", {RightLabel = "~g~"..ChestData.code}, ChestData.owner == "moi", {
                    onSelected = function()
                        local code = Key.input(5, "Code du coffre:")
                        if code ~= nil then
                            ChestData.code = code
                        else
                            cPlayer:notify("error", "Champ invalide")
                        end
                    end
                })

                RageUI.Button("Position du coffre", ChestData.pos, {}, true, {
                    onSelected = function()
                        local pos = GetEntityCoords(PlayerPedId())
                        
                        ChestData.pos = pos
                        cPlayer:notify("info", "Vous avez défini la position sur: ~b~"..pos)
                    end,
                })
                
                if ChestData.pos ~= "" then
                    RageUI.Checkbox('Voir la position', nil, check, {}, {
                        onChecked = function()
                            check = true
                            CreateThread(function()
                                while check do
                                    DrawMarker(1, ChestData.pos.x, ChestData.pos.y, ChestData.pos.z-0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                                    Wait(0)
                                end
                            end)
                        end,

                        onUnChecked = function()
                            check = false
                        end
                    })
                end
                RageUI.Button("Remettre à zéro", nil, {RightLabel = "→", Color = {HightLightColor = {255, 0, 0, 150}}}, true, {
                    onSelected = function()
                        ChestData = {name = "", label = "", owner = "", code = "", pos = ""}
                        check = false
                    end
                })

                RageUI.Button("Valider", nil, {RightLabel = "→", Color = {HightLightColor = {0, 255, 0, 150}}}, true, {
                    onSelected = function()
                        if ChestData.name ~= "" and ChestData.label ~= "" and ChestData.owner ~= "" and ChestData.code ~= 0 and ChestData.pos ~= "" then
                            TriggerServerEvent("Chest:createChest", ChestData)
                            Wait(100)
                            RageUI.CloseAll()
                            isMenuOpened = false
                            check = false
                        else
                            cPlayer:notify("error", "Des champs sont invalides ou vides")
                        end
                    end
                })
            end)
            Wait(0)
        end
    end)
end

RegisterNetEvent("Chest:openChestCreator")
AddEventHandler("Chest:openChestCreator", function()
    openChestCreator()
end)