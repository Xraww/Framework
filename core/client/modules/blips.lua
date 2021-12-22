Blips = {}
Blips.__index = Blips

--[[
    Blips = class
    
    *Create blip*
    local [retVal] = Blips.create({label = "label", pos = vector3(0.0, 0.0, 0.0), scale = 0.7, colour = 54, sprite = 3})
]]

function Blips.create(params)
    local self = {}

    self.id = AddBlipForCoord(params.pos)
    SetBlipSprite(self.id, params.sprite)
    SetBlipColour(self.id, params.colour)
    SetBlipScale(self.id, params.scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(params.label)
    EndTextCommandSetBlipName(self.id)
end