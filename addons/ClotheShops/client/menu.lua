local cat, title, desc, isMenuOpened = "clothe", "Vêtements", "Actions:", false
local partsClothes = {[4] = "Pantalon", [6] = "Chaussures", [8] = "Tshirt", [11] = "Torse"}
local partsAccessories = {[1] = "Masque", [3] = "Gant", [5] = "Sac", [7] = "Chaines", [9] = "Gilet par balle"}
local ClotheShopMenu = {
    partId = nil,
    clotheId = 0,
    colourId = 0,
}

local function sub(name)
    return cat..name
end

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
    setPlayerInMenu()
end
local clothe =  RageUI.CreateSubMenu(main, "Acheter vêtement", desc)
local clotheList = RageUI.CreateSubMenu(clothe, ClotheShopMenu.partId, desc)
local clotheColour = RageUI.CreateSubMenu(clotheList, "Couleur", desc)
local buyClothe = RageUI.CreateSubMenu(clothe, "Acheter", desc)

function openClotheShopMenu()
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    CreateThread(function()
        while isMenuOpened do 

            RageUI.IsVisible(main, function()
                RageUI.Button("Acheter des vêtements", nil, {}, true, {}, clothe)
            end)

            RageUI.IsVisible(clothe, function()
                for index, part in pairs(partsClothes) do
					RageUI.Button(part, nil, {}, true, {
						onSelected = function()
							ClotheShopMenu.partId = part
						end
					}, clotheList)
				end
            end)

            RageUI.IsVisible(clotheList, function()
				for i=0, GetNumberOfPedDrawableVariations(PlayerPedId(), ClotheShopMenu.partId)-1, 1 do
					RageUI.Button(partsClothes[ClotheShopMenu.partId].." #"..i, nil, {}, true, {
						onActive = function()
							ClotheShopMenu.clotheId = i
							SetPedComponentVariation(PlayerPedId(), ClotheShopMenu.part, ClotheShopMenu.clotheId, 0, 2)
						end,

						onSelected = function()
							ClotheShopMenu.clotheId = i
						end
					}, clotheColour)
				end
			end)

            RageUI.IsVisible(clotheColour, function()
				for i=1, GetNumberOfPedTextureVariations(PlayerPedId(), ClotheShopMenu.part, ClotheShopMenu.clotheId), 1 do
					RageUI.Button("Couleur: "..i, nil, {}, true, {
						onActive = function()
							ClotheShopMenu.colourId = i
							SetPedComponentVariation(PlayerPedId(), ClotheShopMenu.part, ClotheShopMenu.clotheId, i-1, 2)
						end
					}, buyClothe)
				end
			end)

            Wait(0)
        end
    end)
end

RegisterNetEvent("ClotheShops:openMenu")
AddEventHandler("ClotheShops:openMenu", function()
    openClotheShopMenu()
end)