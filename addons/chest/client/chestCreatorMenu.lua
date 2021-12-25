local cat, title, desc, isMenuOpened = "cChest", "Créateur de coffre", "Actions:", false

local function sub(name)
    return cat..name
end

local check = false
local ChestData = {
    name = "",
    label = "",
    owner = "",
    type = "Joueur",
    pos = nil,
}

local tbl = {"Joueur", "Job"}
local tblIndex = 1

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

                RageUI.List('Type de propriétaire', tbl, tblIndex, "Le propriétaire du coffre est un joueur ou un job", {}, true, {
                    onListChange = function(Index, Item)
                        tblIndex = Index
                        ChestData.type = tbl[tblIndex]
                    end
                })

                RageUI.Button("Propriétaire du coffre", nil, {RightLabel = "~g~"..ChestData.owner}, true, {
                    onSelected = function()
                        if tblIndex == 1 then
                            local owner = Key.input(5, "Id du joueur:")

                            if owner ~= nil and tonumber(owner) > 0 then
                                ChestData.owner = tonumber(owner)
                            else
                                cPlayer:notify("error", "Champ invalide")
                            end

                        else
                            local owner = Key.input(25, "Nom du job:")

                            if owner ~= nil then
                                ChestData.owner = string.lower(owner)
                            else
                                cPlayer:notify("error", "Champ invalide")
                            end
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
                
                if ChestData.pos ~= nil then
                    RageUI.Checkbox('Voir la position', nil, check, {}, {
                        onChecked = function()
                            check = true
                            CreateThread(function()
                                while check do
                                    DrawMarker(1, ChestData.pos.x, ChestData.pos.y, ChestData.pos.z-0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
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
                        ChestData = {name = "", label = "", owner = "", pos = ""}
                        check = false
                    end
                })

                RageUI.Button("Valider", nil, {RightLabel = "→", Color = {HightLightColor = {0, 255, 0, 150}}}, true, {
                    onSelected = function()
                        if ChestData.name ~= "" and ChestData.label ~= "" and ChestData.owner ~= "" and ChestData.pos ~= "" then
                            if ChestData.type == "Joueur" then 
                                ChestData.type = "player"
                            else
                                ChestData.type = "job"
                            end

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