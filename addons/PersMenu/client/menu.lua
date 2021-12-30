local cat, title, desc, isMenuOpened = "personal", "Menu Personnel", "Actions:", false

local function sub(name)
    return cat..name
end

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
    setPlayerInMenu()
end

local mainInv =  RageUI.CreateSubMenu(main, "Inventaire", desc)
local invActions = RageUI.CreateSubMenu(mainInv, "Utilisation", desc)
local mainClothe = RageUI.CreateSubMenu(main, "Vêtement", desc)
local clothActions = RageUI.CreateSubMenu(mainClothe, "Utilisation", desc)
local removeClothe = RageUI.CreateSubMenu(clothActions, "Enlever", desc)
local mainAccessory = RageUI.CreateSubMenu(main, "Accéssoire", desc)
local accesActions = RageUI.CreateSubMenu(mainAccessory, "Utilisation", desc)
local removeAccessory = RageUI.CreateSubMenu(accesActions, "Enlever", desc)

local PersMenu = {
    crtItem = {},
    crtClothe = {},
    crtAccessory = {},
    checked = false,

    clothesList = {"Pantalon", "Chaussures", "Haut"},
    clothesIndex = 1,
    accessoriesList = {"Masque", "Gants", "Sac", "Chaine", "Gilet pare-balles"},
    accessoriesIndex = 1,
}

local function RemovePart(part)
    if part == "Masque" then
        SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
    elseif part == "Gants" then
        SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)
    elseif part == "Sac" then
        SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 2)
    elseif part == "Chaine" then
        SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
    elseif part == "Gilet pare-balles" then
        SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
    elseif part == "Pantalon" then
        SetPedComponentVariation(PlayerPedId(), 4, 18, 0, 2)
    elseif part == "Chaussures" then
        SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
    elseif part == "Tshirt" then
        SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
    elseif part == "Haut" then
        SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)
        SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
        SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2)
    end
end

function openPersonalMenu()
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                RageUI.Button('Inventaire', nil, {RightLabel = "→"}, true, {}, mainInv)
                RageUI.Button('Vêtement', nil, {RightLabel = "→"}, true, {}, mainClothe)
                RageUI.Button('Accéssoire', nil, {RightLabel = "→"}, true, {}, mainAccessory)
            end)

            RageUI.IsVisible(mainClothe, function()
                RageUI.Separator(("Poids: ~b~%s/%skg"):format(cPlayer.weight, shConfig.maxWeight))

                RageUI.Button('Enlever vêtement', nil, {RightLabel = "→"}, true, {}, removeClothe)

                RageUI.Checkbox('Afficher le poids des vêtements', nil, PersMenu.checked, {}, {
                    onChecked = function()
                        PersMenu.checked = true
                    end,
                    onUnChecked = function()
                        PersMenu.checked = false
                    end,
                })

                for name,clothe in pairs(cPlayer.clothes) do
                    RageUI.Button((clothe.label..(PersMenu.checked and " ~r~[%skg]" or "")):format(clothe.count*cClothes[name].weight), nil, {RightLabel = "[~b~"..clothe.count.."~s~]"}, true, {
                        onSelected = function()
                            PersMenu.crtClothe = clothe
                        end
                    }, clothActions)
                end

                if next(cPlayer.clothes) == nil then
                    RageUI.Separator("Vous n'avez ~r~aucun~s~ vêtement")
                end
            end)

            RageUI.IsVisible(mainAccessory, function()
                RageUI.Separator(("Poids: ~b~%s/%skg"):format(cPlayer.weight, shConfig.maxWeight))

                RageUI.Button('Enlever accéssoire', nil, {RightLabel = "→"}, true, {}, removeAccessory)

                RageUI.Checkbox('Afficher le poids des accéssoires', nil, PersMenu.checked, {}, {
                    onChecked = function()
                        PersMenu.checked = true
                    end,
                    onUnChecked = function()
                        PersMenu.checked = false
                    end,
                })

                for name,accessory in pairs(cPlayer.accessories) do
                    RageUI.Button((accessory.label..(PersMenu.checked and " ~r~[%skg]" or "")):format(accessory.count*cAccessories[name].weight), nil, {RightLabel = "[~b~"..accessory.count.."~s~]"}, true, {
                        onSelected = function()
                            PersMenu.crtAccessory = accessory
                        end
                    }, accesActions)
                end

                if next(cPlayer.accessories) == nil then
                    RageUI.Separator("Vous n'avez ~r~aucun~s~ accéssoire")
                end
            end)

            RageUI.IsVisible(mainInv, function()
                if next(cPlayer.inventory) == nil then
                    RageUI.Separator("Votre sac est ~r~vide")
                else
                    RageUI.Separator(("Poids: ~b~%s/%skg"):format(cPlayer.weight, shConfig.maxWeight))

                    RageUI.Checkbox('Afficher le poids des items', nil, PersMenu.checked, {}, {
                        onChecked = function()
                            PersMenu.checked = true
                        end,
                        onUnChecked = function()
                            PersMenu.checked = false
                        end,
                    })

                    for name,item in pairs(cPlayer.inventory) do
                        RageUI.Button((item.label..(PersMenu.checked and " ~r~[%skg]" or "")):format(item.count*cItems[name].weight), nil, {RightLabel = "[~b~"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                PersMenu.crtItem = item
                            end
                        }, invActions)
                    end
                end
            end)

            RageUI.IsVisible(invActions, function()
                RageUI.Button("Utiliser", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("PersMenu:useItem", PersMenu.crtItem.name)
                    end
                })
                RageUI.Button("Donner", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, dist = GetClosestPlayer()
                        if closestPlayer ~= nil and -1 then
                            local count = Key.input(3, "Quantité:")
                            if count ~= nil and tonumber(count) > 0 and tonumber(count) <= PersMenu.crtItem.count then
                                TriggerServerEvent("PersMenu:giveItem", closestPlayer, PersMenu.crtItem.name, tonumber(count))
                            else
                                cPlayer:notify("error", ("Vous n'avez pas assez de: ~b~%s ~s~(%s)"):format(PersMenu.crtItem.label, PersMenu.crtItem.count))
                            end
                        else
                            cPlayer:notify("error", "Aucune personne proche de vous")
                        end
                    end,
                    onActive = function()
                        DisplayClosetPlayer()
                    end
                })
                RageUI.Button("Jeter", nil, {}, true, {
                    onSelected = function()
                        local count = Key.input(3, "Quantité:")
                        if count ~= nil and tonumber(count) > 0 and tonumber(count) <= PersMenu.crtItem.count then
                            TriggerServerEvent("PersMenu:dropItem", PersMenu.crtItem.name, tonumber(count), GetEntityCoords(GetPlayerPed(-1)))
                        else
                            cPlayer:notify("error", ("Vous n'avez pas assez de: ~b~%s ~s~(%s)"):format(PersMenu.crtItem.label, PersMenu.crtItem.count))
                        end
                    end
                })
                RageUI.Button("Infos", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("PersMenu:itemInfos", PersMenu.crtItem.name)
                    end
                })
            end)

            RageUI.IsVisible(removeClothe, function()
                RageUI.List('Vêtement: ', PersMenu.clothesList, PersMenu.clothesIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        PersMenu.clothesIndex = Index
                    end
                })

                RageUI.Button("Enlever", nil, {}, true, {
                    onSelected = function()
                        RemovePart(PersMenu.clothesList[PersMenu.clothesIndex])
                    end
                })
            end)

            RageUI.IsVisible(removeAccessory, function()
                RageUI.List('Accéssoire: ', PersMenu.accessoriesList, PersMenu.accessoriesIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        PersMenu.accessoriesIndex = Index
                    end
                })
                
                RageUI.Button("Enlever", nil, {}, true, {
                    onSelected = function()
                        RemovePart(PersMenu.accessoriesList[PersMenu.accessoriesIndex])
                    end
                })
            end)

            RageUI.IsVisible(clothActions, function()
                RageUI.Button("Utiliser", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("PersMenu:useClothe", PersMenu.crtClothe.name)
                    end
                })
            end)

            RageUI.IsVisible(accesActions, function()
                RageUI.Button("Utiliser", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("PersMenu:useAccessory", PersMenu.crtAccessory.name)
                    end
                })
            end)
            
            Wait(0)
        end
    end)
end

RegisterCommand("openPersonalMenu", function()
    -- if the player is not dead then openPersonalMenu() end
    openPersonalMenu()
end, false)

RegisterKeyMapping("openPersonalMenu", "Menu Personnel", "keyboard", "F5")