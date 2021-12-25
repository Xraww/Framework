local cat, title, desc, isMenuOpened = "chest", "Coffre", "Actions:", false

local function sub(name)
    return cat..name
end

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
    setPlayerInMenu()
end
local deposit = RageUI.CreateSubMenu(main, "Déposer objet", desc)
local take = RageUI.CreateSubMenu(main, "Retirer objet", desc)
RegisterNetEvent("Chest:refreshInventory")

local crtChest = {}
local checked = false

function openChest(chest)
    if isMenuOpened then return end
    isMenuOpened = true

    crtChest = chest

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    AddEventHandler("Chest:refreshInventory", function(newInv, newWeight)
        crtChest.inventory = newInv
        crtChest.weight = newWeight
    end)

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                RageUI.Separator(("Coffre:~b~ %s"):format(crtChest.label))
                RageUI.Separator(("Poids du coffre:~b~ %skg"):format(crtChest.weight))

                RageUI.Button('Déposer objet', nil, {RightLabel = "→"}, true, {}, deposit)
                RageUI.Button('Retirer objet', nil, {RightLabel = "→"}, true, {}, take)
            end)

            RageUI.IsVisible(deposit, function()
                if next(cPlayer.inventory) == nil then
                    RageUI.Separator("Votre sac est ~r~vide")
                else
                    RageUI.Checkbox('Afficher le poids des items', nil, checked, {}, {
                        onChecked = function()
                            checked = true
                        end,
                        onUnChecked = function()
                            checked = false
                        end,
                    })
                    for name,item in pairs(cPlayer.inventory) do
                        RageUI.Button((item.label..(checked and " ~r~[%skg]" or "")):format(item.count*cItems[name].weight), nil, {RightLabel = "[~b~x"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                local item = name
                                local count = Key.input(3, "Montant:")

                                if count ~= nil and tonumber(count) > 0 and tonumber(count) <= cPlayer.inventory[item].count then
                                    TriggerServerEvent("Chest:addItem", crtChest, item, tonumber(count))
                                else
                                    cPlayer:notify("error", "Montant invalide")
                                end
                            end
                        })
                    end
                end
            end)

            RageUI.IsVisible(take, function()
                if next(crtChest.inventory) == nil then
                    RageUI.Separator("Le coffre est ~r~vide")
                else
                    RageUI.Checkbox('Afficher le poids des items', nil, checked, {}, {
                        onChecked = function()
                            checked = true
                        end,
                        onUnChecked = function()
                            checked = false
                        end,
                    })

                    for name,item in pairs(crtChest.inventory) do
                        RageUI.Button((item.label..(checked and " ~r~[%skg]" or "")):format(item.count*cItems[name].weight), nil, {RightLabel = "[~b~x"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                local item = name
                                local count = Key.input(3, "Montant:")

                                if count ~= nil and tonumber(count) > 0 and tonumber(count) <= crtChest.inventory[item].count then
                                    TriggerServerEvent("Chest:removeItem", crtChest, item, tonumber(count))
                                else
                                    cPlayer:notify("error", "Montant invalide")
                                end
                            end
                        })
                    end
                end
            end)
            Wait(0)
        end
    end)
end

RegisterNetEvent("Chest:openChest")
AddEventHandler("Chest:openChest", function(data)
    openChest(data)
end)