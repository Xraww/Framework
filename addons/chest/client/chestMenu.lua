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

function openChest(data)
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                RageUI.Separator(("Nom du coffre:~b~ %s"):format(data.label))
                RageUI.Separator(("Poids du coffre:~b~ %skg"):format(data.weight))

                RageUI.Button('Déposer objet', nil, {RightLabel = "→"}, true, {}, deposit)
                RageUI.Button('Retirer objet', nil, {RightLabel = "→"}, true, {}, take)
            end)

            RageUI.IsVisible(deposit, function()
                if next(cPlayer.inventory) == nil then
                    RageUI.Separator("Votre sac est ~r~vide")
                else
                    for name,item in pairs(cPlayer.inventory) do
                        RageUI.Button(item.pLabel, nil, {RightLabel = "[~b~"..item.count.."~s~]"}, true, {
                            onSelected = function()
                                local amount = Key.input(3, "Montant:")
                                TriggerServerEvent("Chest:addItem")
                            end
                        })
                    end
                end
            end)

            RageUI.IsVisible(take, function()

            end)
            Wait(0)
        end
    end)
end

RegisterNetEvent("Chest:openChest")
AddEventHandler("Chest:openChest", function(data)
    openChest(data)
end)