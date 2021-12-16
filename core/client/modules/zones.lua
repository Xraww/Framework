Zones = {}
Zones.__index = Zones
ZonesAdded = {}
local ActualZone = nil
local PosSended = false

function Zones.create(params)
    local self = {}
    
    self.pos = params.pos or nil
    self.blip = params.blip or nil
    self.ped = params.ped or nil
    self.forJob = params.forJob or nil
    self.marker = params.marker or nil
    self.methode = params.methode or nil
    self.radius = params.radius or 1.5
    self.inputText = params.inputText or ""

    table.insert(ZonesAdded, self)
    return setmetatable(self, Zones)
end

local ZoneTiming = 500
CreateThread( function()
    while true do
        Wait(ZoneTiming)
        
        if cPlayer then
            for _,v in pairs(ZonesAdded) do
                if v.marker then
                    local MarkerDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.marker.radius)
                    if MarkerDist then
                        ZoneTiming = 0
                        ActualZone = v
                        if not PosSended then
                            PosSended = true
                            TriggerServerEvent("sendActualZone", v)
                        end
                        v.marker:showMarker()
                    end
                end
                local posDist = cPlayer:isNear(vector3(v.pos.x, v.pos.y, v.pos.z), v.radius)
                if posDist then
                    ZoneTiming = 0
                    ActualZone = v
                    if not PosSended then
                        PosSended = true
                        TriggerServerEvent("sendActualZone", v)
                    end
                    if not crtMenu then
                        CreateThread( function()
                            if not v.forJob then
                                cPlayer:helpNotify(v.inputText)
                                v.methode()
                            else
                                if v.forJob == cPlayer.jobName then
                                    cPlayer:helpNotify(v.inputText)
                                    v.methode()
                                end
                            end
                        end)
                    end
                else
                    if ActualZone then 
                        local posDist2 = cPlayer:isNear(vector3(ActualZone.pos.x, ActualZone.pos.y, ActualZone.pos.z), (ActualZone.radius*5))
                        if not posDist2 then
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
end)

function Zones:showPed()
    if self.ped then
        self.ped:setInvincible(true)
        self.ped:setFreeze(true)
        self.ped:setPassif(true)
    end
end

--[[ Zone exemple:
    Client side:
    
    Blips.create({label = "Magasin", sprite = 52, colour = 43, scale = 0.7, pos = vector3(-521.8681, -231.7319, 35.90186)})
    Peds[_] = Peds.create("mp_m_shopkeep_01", vector3(645.3494, 460.3517, 144.6337), false)
    Shopz[_] = Zones.create({
        ped = Peds[_],
        marker = Markers.create({type = 2, radius = 15.0, pos = vector3(645.3494, 460.3517, 144.6337 + 1.18), width = 0.3, height = 0.3, colour = {r = 0, g = 245, b = 245, a = 185}, blowUp = true, faceCam = true, inversed = true}),
        pos = vector3(645.3494, 460.3517, 144.6337),
        radius = 2.0,
        inputText = "Appuyer sur ~INPUT_CONTEXT~ pour intéragir.",
        methode = function()
            Key.onPress("e", function()
                -- action
            end)
        end,
    })
    Shopz[_]:showPed()

    Server side:
    if sPlayer:isNearZone() then
        -- action
    end
]]