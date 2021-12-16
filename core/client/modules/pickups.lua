local pickups = {}
local nearObjs = {}

RegisterNetEvent("SendAllPickups")
AddEventHandler("SendAllPickups", function(pick, id, del, newCount)
    for k,v in pairs(nearObjs) do
        DeleteEntity(v.entity)
    end
    nearObjs = {}
    pickups = pick
    SyncPickups()
end)

function SyncPickups()
    local pPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(pPed)
    
    for k,v in pairs(pickups) do
        if #(v.coords - pCoords) < 15 then
            if not v.added then
                table.insert(nearObjs, {item = v.item, label = v.label, count = v.count, id = k, coords = v.coords, prop = false, entity = nil})
                pickups[k].added = true
            end
        end
    end
end

function LoadPickups()
    CreateThread(function()
        while true do
            SyncPickups()
            Wait(500)
        end
    end)

    CreateThread(function()
        while true do
            local isNear = false
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)

            for k,v in pairs(nearObjs) do
                if v.count == nil then 
                    nearObjs[k] = nil
                    break
                end
                if not v.prop then
                    if v.id == nil then break end
                    local prop = "v_serv_abox_02"
                    nearObjs[k].entity = SpawnProp(prop, v.coords)
                    nearObjs[k].prop = true
                end
                if #(v.coords - pCoords) < 2 then
                    isNear = true
                    DrawText3d(GetEntityCoords(nearObjs[k].entity), "Appuyez sur [E] pour ramasser ~b~x"..v.count.."~s~ ~g~"..v.label)
                    if IsControlJustReleased(0, 38) then
                        local amount = tonumber(Key.input(3, "Quantité:"))
                        if amount <= v.count then
                            TriggerServerEvent("takePickup", v.id, v.item, amount, v.count)
                            if amount == v.count then
                                if v.id == nil then break end
                                pickups[v.id].added = false
                                DeleteEntity(v.entity)
                                nearObjs[k] = nil
                            end
                        end
                    end
                    break
                end

                if #(v.coords - pCoords) > 15 then
                    if v.id == nil then break end
                    pickups[v.id].added = false
                    DeleteEntity(v.entity)
                    nearObjs[k] = nil
                end
            end

            if isNear then
                Wait(1)
            else
                if #nearObjs > 0 then
                    Wait(500)
                else
                    Wait(1000)
                end
            end
        end
    end)
end