function Player:getClothes(minimal)
    if minimal then
        local minimalClothes = {}

        for k,v in pairs(self.clothes) do
            if v.count > 0 then
                minimalClothes[v.name] = v.count
            end
        end
        
        return minimalClothes
    else
        return self.clothes
    end
end

function Player:canUseClothe(clothe)
    if Clothes[clothe].handler then
        return true
    end
end

function Player:useClothe(clothe)
    if self:canUseClothe(clothe) then
        Clothes.use(self.id, clothe)
    else
        self:notify("error", "Vous ne pouvez pas utiliser ce vêtement")
    end
end

function Player:canCarryClothe(clothe, count)
    if Clothes[clothe] then
        if self.weight <= self.maxWeight then
            local calc = (self.weight + (Clothes[clothe].weight * count))
            if calc <= self.maxWeight then
                return true, calc
            else
                return false, calc
            end
        else
            return false
        end
    else
        return false 
    end
end

function Player:addClothe(clothe, count)
    if Clothes[clothe] then
        if self.clothes[clothe] then
            if (self.weight + (Clothes[clothe].weight * count)) <= self.maxWeight then
                self.clothes[clothe].count = self.clothes[clothe].count + count
                self.weight = self.weight + (Clothes[clothe].weight * count)

                local str = string.format("~g~x%s %s", count, Clothes[clothe].label)
                self:notify("clothe", "Vous avez reçu "..str)
                self:triggerClient("GM:refreshData:clothes", self.clothes, self.weight)
                return true
            else
                self:notify("clothe", "Vous êtes trop lourd")
                return false
            end
        else
            if (self.weight + (Clothes[clothe].weight * count)) <= self.maxWeight then
                self.clothes[clothe] = {}
                self.clothes[clothe].label = Clothes[clothe].label
                self.clothes[clothe].name = clothe
                self.clothes[clothe].count = count
                self.weight = self.weight + (Clothes[clothe].weight * count)

                local str = string.format("~g~x%s %s", count, Clothes[clothe].label)
                self:notify("clothe", "Vous avez reçu "..str)
                self:triggerClient("GM:refreshData:clothes", self.clothes, self.weight)
                return true
            else
                self:notify("clothe", "Vous êtes trop lourd")
                return false
            end
        end
    end
end

function Player:removeClothe(clothe, count)
    if Clothes[clothe] then
        if self.clothes[clothe] then
            if (self.clothes[clothe].count - count) >= 0 then
                self.clothes[clothe].count = self.clothes[clothe].count - count
                self.weight = self.weight - (Clothes[clothe].weight * count)

                if (self.clothes[clothe].count) == 0 then
                    self.clothes[clothe] = nil      
                end

                self:triggerClient("GM:refreshData:clothes", self.clothes, self.weight)
            end
        end
    end
end

function Player:saveClothes()
    local clothes = json.encode(self:getClothes(true))
    MySQL.Async.execute('UPDATE players SET clothes = @clothes WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@clothes'] = clothes
    }, function()
        self:triggerClient("GM:refreshData:clothes", self.clothes, self.weight)
    end)
end