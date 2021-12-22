Zones = {}
Zones.__index = Zones
ZonesAdded = {}

function Zones.create(params)
    local self = {}
    
    self.name = nil
    if not ZonesAdded[params.name] then
        self.name = params.name
    else
        print("[^1Zones^7] Une zone porte déjà le nom: ^1"..params.name)
        return
    end
    self.pos = params.pos or nil
    self.blip = params.blip or nil
    self.ped = params.ped or nil
    self.forJob = params.forJob or nil
    self.marker = params.marker or nil
    self.methode = params.methode or nil
    self.showDistZone = params.showDistZone or 1.5
    self.showDistPed = params.showDistPed or 40.0
    self.showDistMarker = params.showDistMarker or 20.0
    self.inputText = params.inputText or ""
    self.spawnedPed = nil

    ZonesAdded[self.name] = self
    print(("[^1Zones^7] Création de la zone ^4%s"):format(self.name))
    return setmetatable(self, Zones)
end

local ZoneTiming = 500
local zoneState = {}
local ActualZone = nil
local PosSended = false

CreateThread(function()
    while true do
        Wait(ZoneTiming)
        
        if cPlayer then
            for _,v in pairs(ZonesAdded) do
                if not zoneState[v.name] then
                    zoneState[v.name] = {blip = false, ped = false}
                end
                if v.forJob ~= "no" then
                    if v.forJob == cPlayer.job.name then
                        if v.blip and not zoneState[v.name].blip then
                            local blip = Blips.create({label = v.blip.label, pos = v.blip.pos, scale = v.blip.scale, colour = v.blip.colour, sprite = v.blip.sprite})
                            zoneState[v.name].blip = true
                        end
    
                        if v.ped then
                            local pedDist = cPlayer:isNear(vector3(v.ped.pos.x, v.ped.pos.y, v.ped.pos.z), v.showDistPed)
                            if pedDist and not zoneState[v.name].ped then
                                v:showPed()
                                zoneState[v.name].ped = true
                            elseif not pedDist and zoneState[v.name].ped then
                                v:deletePed()
                                zoneState[v.name].ped = false
                            end
                        end
    
                        if v.marker then
                            local markerDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.showDistMarker)
                            if markerDist then
                                ZoneTiming = 0
                                v.marker:showMarker()
                            end
                        end

                        local zoneDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.showDistZone)
                        if zoneDist then
                            ZoneTiming = 0
                            ActualZone = v
                            if not PosSended then
                                PosSended = true
                                TriggerServerEvent("sendActualZone", v)
                            end
                            CreateThread(function()
                                cPlayer:helpNotify(v.inputText)
                                v.methode()
                            end)
                        else
                            if ActualZone then 
                                local zoneDist2 = cPlayer:isNear(vector3(ActualZone.pos.x, ActualZone.pos.y, ActualZone.pos.z), (ActualZone.showDistMarker))
                                if not zoneDist2 then
                                    ZoneTiming = 500
                                    PosSended = false
                                    TriggerServerEvent("resetActualZone")
                                    ActualZone = nil
                                end
                            end
                        end
                    end
                else
                    if v.blip and not zoneState[v.name].blip then
                        local blip = Blips.create({label = v.blip.label, pos = v.blip.pos, scale = v.blip.scale, colour = v.blip.colour, sprite = v.blip.sprite})
                        zoneState[v.name].blip = true
                    end

                    if v.ped then
                        local pedDist = cPlayer:isNear(vector3(v.ped.pos.x, v.ped.pos.y, v.ped.pos.z), v.showDistPed)
                        if pedDist and not zoneState[v.name].ped then
                            v:showPed()
                            zoneState[v.name].ped = true
                        elseif not pedDist and zoneState[v.name].ped then
                            v:deletePed()
                            zoneState[v.name].ped = false
                        end
                    end

                    if v.marker then
                        local markerDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.showDistMarker)
                        if markerDist then
                            ZoneTiming = 0
                            v.marker:showMarker()
                        end
                    end

                    local zoneDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.showDistZone)
                    if zoneDist then
                        ZoneTiming = 0
                        ActualZone = v
                        if not PosSended then
                            PosSended = true
                            TriggerServerEvent("sendActualZone", v)
                        end
                        CreateThread(function()
                            cPlayer:helpNotify(v.inputText)
                            v.methode()
                        end)
                    else
                        if ActualZone then 
                            local zoneDist2 = cPlayer:isNear(vector3(ActualZone.pos.x, ActualZone.pos.y, ActualZone.pos.z), (ActualZone.showDistMarker))
                            if not zoneDist2 then
                                ZoneTiming = 500
                                PosSended = false
                                TriggerServerEvent("resetActualZone")
                                ActualZone = nil
                            end
                        end
                    end
                end
            end
        end
    end
end)

function Zones:showPed()
    if not self.spawnedPed then
        self.spawnedPed = Peds.create({hash = self.ped.hash, pos = {x = self.ped.pos.x, y = self.ped.pos.y, z = self.ped.pos.z, h = self.ped.heading}, sync = self.ped.sync})
        self.spawnedPed:setInvincible(true)
        self.spawnedPed:setFreeze(true)
        self.spawnedPed:setPassif(true)
    end
end

function Zones:deletePed()
    if self.spawnedPed and self.spawnedPed.exist then
        DeleteEntity(self.spawnedPed.id)
        self.spawnedPed = nil
    end
end