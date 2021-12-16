Blips = {}
Blips.__index = Blips

--[[
    Blips = class
    
    *Create blip*
    local [retVal] = Blips.create(Label, Pos, Sprite, Colour) -- Create Blip
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