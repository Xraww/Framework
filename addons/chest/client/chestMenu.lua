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

local chestInventory = {}
local received = false

function openChest(chest)
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                received = false
                RageUI.Separator(("Nom du coffre:~b~ %s"):format(chest.label))
                RageUI.Separator(("Poids du coffre:~b~ %skg"):format(chest.weight))

                RageUI.Button('Déposer objet', nil, {RightLabel = "→"}, true, {}, deposit)
                RageUI.Button('Retirer objet', nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        TriggerServerEvent("Chest:getInventory", chest)
                    end
                }, take)
            end)

            RageUI.IsVisible(deposit, function()
                if next(cPlayer.inventory) == nil then
                    RageUI.Separator("Votre sac est ~r~vide")
                else
                    for name,item in pairs(cPlayer.inventory) do
                        RageUI.Button(item.pLabel, nil, {RightLabel = "[~b~"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                local item = name
                                local count = Key.input(3, "Montant:")
                                TriggerServerEvent("Chest:addItem", chest, item, count)
                            end
                        })
                    end
                end
            end)

            RageUI.IsVisible(take, function()
                if next(chestInventory) == nil then
                    RageUI.Separator("Le coffre est ~r~vide")
                else
                    for name,item in pairs(chestInventory) do
                        RageUI.Button(item.label, nil, {RightLabel = "[~b~"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                local item = name
                                local count = Key.input(3, "Montant:")
                                TriggerServerEvent("Chest:removeItem", chest, item, count)
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

RegisterNetEvent("Chest:cbChestInventory")
AddEventHandler("Chest:cbChestInventory", function(data)
    chestInventory = data
    received = true
end)