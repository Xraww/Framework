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

RegisterNetEvent("GM:teleportToMarker")
AddEventHandler("GM:teleportToMarker", function()
    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

        cPlayer:notify("success", "Vous avez été téléporté à votre marker")
    else
        cPlayer:notify("error", "Vous n'avez pas placé de marker")
    end
end)

local bucketId = nil
local id = GetPlayerServerId(PlayerId())

RegisterNetEvent("GM:getDevInfos")
AddEventHandler("GM:getDevInfos", function(_bucketId)
    bucketId = _bucketId
end)

CreateThread(function()
    while true do 
		local y, m, d, h, min, s = GetLocalTime()
		local date = (("%s:%s:%s"):format(h, min, s))

        SetTextColour(255, 255, 255, 255)
		SetTextFont(4)
		SetTextScale(0.4, 0.4)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(2, 2, 0, 0, 0)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(("Bucket: %s\nId: %s\nTime: %s"):format(bucketId, id, date))
		DrawText(0.95, 0.001)
        Wait(0)
    end
end)