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
                    RageUI.Separator("Votre sac est vide.")
                else
                    for _,v in pairs(cPlayer.inventory) do
                        RageUI.Button(v.label, nil, {RightLabel = "[~b~"..v.count.."~s~]"}, true, {
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
                        
                    end
                })
                RageUI.Button("Donner", nil, {}, true, {
                    onSelected = function()
                        local amount = Key.input(3, "Quantité:")
                        if tonumber(amount) ~= nil then
                            TriggerServerEvent("giveItem", PersMenu.crtItem.name, tonumber(amount))
                        else
                            
                        end
                    end,
                    onHovered = function()
                        DisplayClosetPlayer()
                    end
                })
                RageUI.Button("Jeter", nil, {}, true, {
                    onSelected = function()
                        local amount = Key.input(3, "Quantité:")
                        if amount ~= nil and tonumber(amount) > 0 and tonumber(amount) <= PersMenu.crtItem.count then
                            TriggerServerEvent("dropItem", PersMenu.crtItem.name, tonumber(amount), GetEntityCoords(GetPlayerPed(-1)))
                        end
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