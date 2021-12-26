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

local value = 1
local value2 = 1
local tblParts = {"Head", "Beard", "Hair", "Torso", "Legs", "Hands", "Foot", "None", "Accessories parahute", "Accessories bags/mask", "Parts for torso"}

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
							value = i
						end
					}, second)
				end
            end)

			RageUI.IsVisible(second, function()
				for i=1, GetNumberOfPedDrawableVariations(PlayerPedId(), value), 1 do
					RageUI.Button("Id: "..i, nil, {}, true, {
						-- onSelected = function()
						-- 	value2 = i
						-- end,

						onActive = function()
							value2 = i
							SetPedComponentVariation(PlayerPedId(), value, value2, 0, 2)
						end
					}, third)
				end
			end)

			RageUI.IsVisible(third, function()
				for i=1, GetNumberOfPedTextureVariations(PlayerPedId(), value, value2), 1 do
					RageUI.Button("Colour: "..i, nil, {}, true, {
						onActive = function()
							SetPedComponentVariation(PlayerPedId(), value, value2, i, 2)
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