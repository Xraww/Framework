local cat, title, desc, isMenuOpened = "skin_dev", "Skin Dev", "Liste:", false

local function sub(name)
    return cat..name
end

local main = RageUI.CreateMenu(title, desc)
main.Closed = function()
    isMenuOpened = false
    setPlayerInMenu()
end
local second =  RageUI.CreateSubMenu(main, "Second", desc)
local third = RageUI.CreateSubMenu(second, "Third", desc)

local tblParts = {"Masque", "Cheveux", "Gant", "Pantalon", "Sac", "Chaussures", "Chaines", "Tshirt", "Gilet par balle", "Autocollants (useless)", "Torse"}
local Selected = {
	part = 1,
	clotheId = 1,
	colourId = 1,
}

function openSkinMenu()
    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(main, not RageUI.Visible(main))
    setPlayerInMenu()

    CreateThread(function()
        while isMenuOpened do 
            RageUI.IsVisible(main, function()
                for i=1, #tblParts, 1 do
					RageUI.Button(tblParts[i], nil, {}, true, {
						onSelected = function()
							Selected.part = i
						end
					}, second)
				end
            end)

			RageUI.IsVisible(second, function()
				for i=0, GetNumberOfPedDrawableVariations(PlayerPedId(), Selected.part)-1, 1 do
					RageUI.Button(tblParts[Selected.part].." #"..i, nil, {}, true, {
						onActive = function()
							Selected.clotheId = i
							SetPedComponentVariation(PlayerPedId(), Selected.part, Selected.clotheId, 0, 2)
						end,

						onSelected = function()
							Selected.clotheId = i
						end
					}, third)
				end
			end)

			RageUI.IsVisible(third, function()
				for i=1, GetNumberOfPedTextureVariations(PlayerPedId(), Selected.part, Selected.clotheId), 1 do
					RageUI.Button("Couleur: "..i, nil, {}, true, {
						onActive = function()
							Selected.colourId = i
							SetPedComponentVariation(PlayerPedId(), Selected.part, Selected.clotheId, i-1, 2)
						end
					})
				end
			end)

			Wait(0)
		end
	end)
end

RegisterCommand("skinMenu", function()
	openSkinMenu()
end, false)

local Clothes = {}
local Accessories = {}
local clothesParts = {[4] = "Pantalon", [6] = "Chaussures", [8] = "Tshirt", [11] = "Torse"}
local accessoriesParts = {[1] = "Masque", [3] = "Gant", [5] = "Sac", [7] = "Chaines", [9] = "Gilet par balle"}

RegisterCommand("registerClothes", function()
	for k, v in pairs(clothesParts) do
		Clothes[v] = {}

		for index=0, GetNumberOfPedDrawableVariations(PlayerPedId(), k)-1, 1 do
			for i=1, GetNumberOfPedTextureVariations(PlayerPedId(), k, index), 1 do
				Clothes[v][index] = {colorMax = i}
			end
		end
	end
	TriggerServerEvent("Items:registerClothes", Clothes)
end, false)

RegisterCommand("registerAccessories", function()
	for k, v in pairs(accessoriesParts) do
		Accessories[v] = {}

		for index=0, GetNumberOfPedDrawableVariations(PlayerPedId(), k)-1, 1 do
			for i=1, GetNumberOfPedTextureVariations(PlayerPedId(), k, index), 1 do
				Accessories[v][index] = {colorMax = i}
			end
		end
	end
	TriggerServerEvent("Items:registerAccessories", Accessories)
end, false)

RegisterCommand("getNumberOfDrawableVariations", function()
	for k, v in pairs(tblParts) do
		print(k, v.." #"..GetNumberOfPedDrawableVariations(PlayerPedId(), k)-1)
	end
end, false)

RegisterCommand("getNumberTextureVariations", function()
	local clothe = {}
	for k, v in pairs(tblParts) do
		clothe[v] = {}
		for i=0, GetNumberOfPedDrawableVariations(PlayerPedId(), k)-1, 1 do
			local name = v.." #"..i
			clothe[v][name] = GetNumberOfPedTextureVariations(PlayerPedId(), k, i)
		end
	end
	TriggerServerEvent("dev:printServerTbl", clothe)
end, false)

RegisterCommand("resetPed", function()
	local model = GetHashKey('mp_m_freemode_01')
    Stream:loadModel(model)
	
	if IsModelInCdimage(model) and IsModelValid(model) then
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(-1))
    end
    SetModelAsNoLongerNeeded(model)
end, false)