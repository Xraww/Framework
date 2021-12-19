local cat, title, desc, isMenuOpened = "personal", "Menu Personnel", "Actions:", false

local function sub(name)
    return cat..name
end

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
end
local mainInv =  RageUI.CreateSubMenu(main, "Inventaire", desc)
local invActions = RageUI.CreateSubMenu(mainInv, "Utilisation", desc)

local PersMenu = {
    crtItem = {},
}

function openPersonalMenu()
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                RageUI.Button('Inventaire', nil, {RightLabel = "→"}, true, {}, mainInv)
            end)

            RageUI.IsVisible(mainInv, function()
                if next(cPlayer.inventory) == nil then
                    RageUI.Separator("Votre sac est ~r~vide")
                else
                    for _,v in pairs(cPlayer.inventory) do
                        RageUI.Button(v.pLabel, nil, {RightLabel = "[~b~"..v.count.."~s~]"}, true, {
                            onSelected = function()
                                PersMenu.crtItem = v
                            end
                        }, invActions)
                    end
                end
            end)

            RageUI.IsVisible(invActions, function()
                RageUI.Button("Utiliser", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("useItem", PersMenu.crtItem.name)
                    end
                })
                RageUI.Button("Renommer", "Tous vos items de ce type porteront le même nom.", {}, true, {
                    onSelected = function()
                        local newLabel = Key.input(25, "Nouveau label:")
                        if newLabel ~= nil then
                            TriggerServerEvent("renameItem", PersMenu.crtItem.name, newLabel)
                        else
                            cPlayer:notify("error", "Champ invalide.")
                        end
                    end
                })
                RageUI.Button("Donner", nil, {}, true, {
                    onSelected = function()
                        local closestPlayer, dist = GetClosestPlayer()
                        if closestPlayer ~= nil and -1 then
                            local count = Key.input(3, "Quantité:")
                            if count ~= nil and tonumber(count) > 0 and tonumber(count) <= PersMenu.crtItem.count then
                                TriggerServerEvent("giveItem", closestPlayer, PersMenu.crtItem.name, tonumber(count))
                            else
                                cPlayer:notify("error", ("Vous n'avez pas assez de: ~b~%s ~s~(%s)"):format(PersMenu.crtItem.label, PersMenu.crtItem.count))
                            end
                        else
                            cPlayer:notify("error", "Aucune personne proche de vous.")
                        end
                    end,
                    onHovered = function()
                        DisplayClosetPlayer()
                    end
                })
                RageUI.Button("Jeter", nil, {}, true, {
                    onSelected = function()
                        local count = Key.input(3, "Quantité:")
                        if count ~= nil and tonumber(count) > 0 and tonumber(count) <= PersMenu.crtItem.count then
                            TriggerServerEvent("dropItem", PersMenu.crtItem.name, tonumber(count), GetEntityCoords(GetPlayerPed(-1)))
                        else
                            cPlayer:notify("error", ("Vous n'avez pas assez de: ~b~%s ~s~(%s)"):format(PersMenu.crtItem.label, PersMenu.crtItem.count))
                        end
                    end
                })
                RageUI.Button("Infos", nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("itemInfos", PersMenu.crtItem.name)
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