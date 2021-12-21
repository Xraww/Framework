Zones = {}
Zones.__index = Zones
ZonesAdded = {}
ActualZone = {}

function Zones.create(params)
    local self = {}
    
    self.pos = params.pos or nil
    self.blip = params.blip or nil
    self.ped = params.ped or nil
    self.forJob = params.forJob or nil
    self.marker = params.marker or nil
    self.trigger = params.trigger or nil
    self.radius = params.radius or 1.5
    self.inputText = params.inputText or ""

    table.insert(ZonesAdded, self)
    return setmetatable(self, Zones)
end

local ZoneTiming = 500
local notifSended = false
local markerActive = false
local inZone = false

RegisterNetEvent("initZones")
AddEventHandler("initZones", function()
    local src = source
    local myPlayer = GetPlayer(src)

    Trace("Init zones loop")

    CreateThread(function()
        while true do
            Wait(ZoneTiming)

            if myPlayer then
                for _,v in pairs(ZonesAdded) do
                    if v.marker then
                        local markerDist = myPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.marker.radius)
                        if markerDist and ActualZone[src] == nil and not markerActive then
                            myPlayer:triggerClient("showMarker", true, v.marker)
                            ActualZone[src] = v
                            markerActive = true
                        else
                            if ActualZone[src] then 
                                local posDist2 = myPlayer:isNear(vector3(ActualZone[src].pos.x, ActualZone[src].pos.y, ActualZone[src].pos.z), (ActualZone[src].marker.radius))
                                if not posDist2 and markerActive then
                                    ActualZone[src] = nil
                                    myPlayer:triggerClient("showMarker", false)
                                    markerActive = false
                                end
                            end
                        end
                    end
                    local posDist = myPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.radius)
                    if posDist then
                        CreateThread(function()
                            if not v.forJob then
                                if not notifSended then
                                    myPlayer:helpNotify(v.inputText) 
                                    notifSended = true
                                end

                                if not inZone then
                                    myPlayer:triggerClient("zone:setInZone", true, v.trigger)
                                    inZone = true
                                end
                            else
                                if v.forJob == myPlayer.job.name then
                                    if not notifSended then
                                        myPlayer:helpNotify(v.inputText)
                                        notifSended = true
                                    end
                                    if not inZone then
                                        myPlayer:triggerClient("zone:setInZone", true, v.trigger)
                                        inZone = true
                                    end
                                end
                            end
                        end)
                    else
                        notifSended = false
                        if inZone then
                            myPlayer:triggerClient("zone:setInZone", false)
                            inZone = false
                        end
                    end
                end
            end
        end
    end)
end)

RegisterCommand("zone", function(source)
    local zone = Zones.create({
        --ped = Peds.create("mp_m_shopkeep_01", vector3(-1495.081, 142.6945, 55.64978), false),
        marker = {type = 2, radius = 15.0, pos = vector3(-1495.081, 142.6945, 55.64978), width = 0.3, height = 0.3, colour = {r = 0, g = 245, b = 245, a = 185}, blowUp = true, faceCam = true, inversed = true},
        pos = vector3(-1495.081, 142.6945, 55.64978),
        radius = 2.0,
        inputText = "Appuyer sur [E] pour intéragir",
        trigger = "openChestCreator"
    })
end, false)