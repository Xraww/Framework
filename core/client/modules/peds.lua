Peds = {}
Peds.__index = Peds

--[[
    Peds = class
    
    *Create ped*
    local [retVal] = Peds.create("csb_abigail", {x = 27.98, y = -1031.78, z = 28.79, w = 0.0}, false) -- false = Sync or not with other player
    *Modify ped state*
    [retVal]:setInvincible(true/false) -- Set ped invincible or not
    [retVal]:setFreeze(true/false) -- Set ped freeze or not
    [retVal]:setVisible(true/false) -- Set ped visible or not
    [retVal]:setPassif(true/false) -- Set ped passif or not
    [retVal]:setArmour(0.0 -> 100.0) -- Set ped armour
    *Modify ped model*
    [retVal]:setAlpha(51/102/153/204/255) -- Set ped opacity
    [retVal]:defaultComps() -- Set ped default components
    *Other*
    [retval]:playScenario("WORLD_FISH_FLEE") -- Play scenario in place
    [retval]:playAnim("mini@strip_club@idles@bouncer@base", "base") -- Play animation in place
    [retval]:stopAnim() -- Stop anim in progress
]]

function Peds.create(data)
    local self = {}
    setmetatable(self, Peds)
    
    Stream:loadModel(data.hash)
    self.id = CreatePed(1, GetHashKey(data.hash), data.pos.x, data.pos.y, data.pos.z - 0.98, data.head, data.sync, false)
    self.pos = {x = data.pos.x, y = data.pos.y, z = data.pos.z, h = data.head}
    self.exist = DoesEntityExist(self.id)
    self.showDist = data.showDist
    SetPedDefaultComponentVariation(self.id)

    return self
end

--[[ *Set function* ]]--

function Peds:setInvincible(bool)
    Wait(50)
    if self.exist then
        SetEntityInvincible(self.id, bool)
        SetEntityCanBeDamaged(self.id, not bool)
    end
end

function Peds:setPassif(bool)
    Wait(50)
    if self.exist then
        SetBlockingOfNonTemporaryEvents(self.id, bool)
    end
end

function Peds:setFreeze(bool)
    Wait(50)
    if self.exist then
        FreezeEntityPosition(self.id, bool)
    end
end

function Peds:setVisible(bool)
    Wait(50)
    if self.exist then
        SetEntityVisible(self.id, bool, 0)
    end
end

function Peds:setAlpha(int)
    Wait(50)
    if self.exist then
        SetEntityAlpha(self.id, int, false)
    end
end

function Peds:setArmour(int)
    Wait(50)
    if self.exist then
        SetPedArmour(self.id, int)
    end
end

function Peds:defaultComps()
    Wait(50)
    if self.exist then
        SetPedDefaultComponentVariation(self.id)
    end
end

--[[ *Other function* ]]--

function Peds:playScenario(scenario)
    Wait(50)
    if self.exist then
        TaskStartScenarioInPlace(self.id, scenario, -1, true)
    end
end

function Peds:playAnim(dict, anim)
    Wait(50)
    if self.exist then
        self:setFreeze(true)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
        TaskPlayAnim(self.id, dict, anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end

function Peds:stopAnim()
    Wait(50)
    if self.exist then
        ClearPedTasksImmediately(self.id)
    end
end

function Peds:walkToCoords(coords, head, timing)
    if self.exist then
        TaskGoStraightToCoord(PlayerPedId(), coords.x, coords.y, coords.z, 0.5, timing, head, 10)
    end
end

function Peds:getCoords()
    if self.exist then
        return GetEntityCoords(self.id)
    end
end

function Peds:kill()
    if self.exist then
        DeleteEntity(self.id)
    end
end

function Peds:goToCoords(Coords, Head, duration)
    TaskGoStraightToCoord(self.id, Coords.x, Coords.y, Coords.z, 0.5, duration, Head, 10)
end

function Peds:setSkin(skin)
    if skin.dadIndex and skin.motherIndex then SetPedHeadBlendData(self.id, skin.dadIndex, skin.motherIndex, nil, skin.dadIndex, skin.motherIndex, nil, 0.5, 0.5, nil, true) end
	if skin.face and skin.skinColor then SetPedHeadBlendData(self.id, skin.dadIndex, skin.motherIndex, 0, skin.dadIndex, skin.motherIndex, 0, skin.face, skin.skinColor, 0.0, false) end
	if skin.eyesIndex then SetPedEyeColor(self.id, skin.eyesIndex, 0, 1) end
	if skin.hair then SetPedComponentVariation(self.id, 2, skin.hair, nil, 2) end
	if skin.headColor then SetPedHairColor(self.id, skin.headColor, skin.headColor) end
	if skin.barber and skin.barberO then SetPedHeadOverlay(self.id, 1, skin.barber, skin.barberO) end
	if skin.hairCoulour then SetPedHeadOverlayColor(self.id, 1, 1, skin.hairCoulour, skin.hairCoulour) end
	if skin.eyebrows and skin.eyebrowsO then SetPedHeadOverlay(self.id, 2, skin.eyebrows, skin.eyebrowsO) end
	if skin.Maquillage then SetPedHeadOverlay(self.id, 4, skin.Maquillage, 1.0) end

	if skin.Lipstick then SetPedHeadOverlay(self.id, 8, skin.Lipstick, 1.0) end 
	if skin.LipstickColor then SetPedHeadOverlayColor(self.id, 8, 2, skin.LipstickColor, skin.LipstickIndexColor, 1.0) end
	if skin.ageing then SetPedHeadOverlay(self.id, 3, skin.ageing, 1.0) end
	if skin.blemish then SetPedHeadOverlay(self.id, 0, skin.blemish, 1.0) end
	if skin.complexion then SetPedHeadOverlay(self.id, 6, skin.complexion, 1.0) end
	if skin.freckles then SetPedHeadOverlay(self.id, 9, skin.freckles, 1.0) end
	if skin.sundamage then SetPedHeadOverlay(self.id, 7, skin.sundamage, 1.0) end
end

function Peds:setClothe(Clothe)
    if Clothe.tshirtIndex then SetPedComponentVariation(self.id, 8, Clothe.tshirtIndex, Clothe.tshirtColour, 2) end
	if Clothe.vesteIndex then SetPedComponentVariation(self.id, 11, Clothe.vesteIndex, Clothe.vesteColour, 2) end
	if Clothe.armsIndex then SetPedComponentVariation(self.id, 3, Clothe.armsIndex, Clothe.armsColor, 2) end
	if Clothe.pantsIndex then SetPedComponentVariation(self.id, 4, Clothe.pantsIndex, Clothe.pantsColour, 2) end
	if Clothe.shoesIndex then SetPedComponentVariation(self.id, 6, Clothe.shoesIndex, Clothe.shoesColour, 2) end

	if Clothe.maskIndex then SetPedComponentVariation(self.id, 1, Clothe.maskIndex, Clothe.maskColor, 2) end
	if Clothe.hatIndex then SetPedPropIndex(self.id, 0, Clothe.hatIndex, Clothe.hatColor, 2) end
	if Clothe.glassesIndex then SetPedPropIndex(self.id, 1, Clothe.glassesIndex, Clothe.glassesColor, 2) end
	if Clothe.earsIndex then SetPedPropIndex(self.id, 2, Clothe.earsIndex, Clothe.earsColor, 2) end
	if Clothe.neckIndex then SetPedComponentVariation(self.id, 7, Clothe.neckIndex, Clothe.neckColor, 2) end
	if Clothe.bagIndex then SetPedComponentVariation(self.id, 5, Clothe.bagIndex, Clothe.bagColor, 2) end
end