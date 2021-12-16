function GetClosestPlayer()
	local pPed = GetPlayerPed(-1)
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
    
	for k,v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

function DisplayClosetPlayer()
	local pPed = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestPlayer()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(GetPlayerPed(pCloset))
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
	end
end

function DrawText3d(coords, text)
	local _, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z+0.8)
	SetTextScale(0.3, 0.3)
	SetTextFont(0)
	SetTextProportional(true)
	SetTextColour(201, 201, 201, 255)
	SetTextDropShadow()
	SetTextDropshadow(50, 0, 0, 0, 255)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

function SpawnProp(model, coords)
	Stream:loadModel(model)
	local entity = CreateObject(GetHashKey(model), coords, 0, 0, 0)
	FreezeEntityPosition(entity, true)
	PlaceObjectOnGroundProperly(entity)

	return entity
end