function Player:getAccessories(minimal)
    if minimal then
        local minimalAccessories = {}

        for k,v in pairs(self.accessories) do
            if v.count > 0 then
                minimalAccessories[v.name] = v.count
            end
        end
        
        return minimalAccessories
    else
        return self.accessories
    end
end

function Player:canUseAccessory(accessory)
    if Accessories[accessory].handler then
        return true
    end
end

function Player:useAccessory(accessory)
    if self:canUseAccessory(accessory) then
        Accessories.use(self.id, accessory)
    else
        self:notify("error", "Vous ne pouvez pas utiliser cet accéssoire")
    end
end

function Player:canCarryAccessory(accessory, count)
    if Accessories[accessory] then
        if self.weight <= self.maxWeight then
            local calc = (self.weight + (Accessories[accessory].weight * count))
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

function Player:addAccessory(accessory, count)
    if Accessories[accessory] then
        if self.accessories[accessory] then
            if (self.weight + (Accessories[accessory].weight * count)) <= self.maxWeight then
                self.accessories[accessory].count = self.accessories[accessory].count + count
                self.weight = self.weight + (Accessories[accessory].weight * count)

                local str = string.format("~g~x%s %s", count, Accessories[accessory].label)
                self:notify("accessory", "Vous avez reçu "..str)
                self:triggerClient("GM:refreshData:accessories", self.accessories, self.weight)
                return true
            else
                self:notify("accessory", "Vous êtes trop lourd")
                return false
            end
        else
            if (self.weight + (Accessories[accessory].weight * count)) <= self.maxWeight then
                self.accessories[accessory] = {}
                self.accessories[accessory].label = Accessories[accessory].label
                self.accessories[accessory].name = accessory
                self.accessories[accessory].count = count
                self.weight = self.weight + (Accessories[accessory].weight * count)

                local str = string.format("~g~x%s %s", count, Accessories[accessory].label)
                self:notify("accessory", "Vous avez reçu "..str)
                self:triggerClient("GM:refreshData:accessories", self.accessories, self.weight)
                return true
            else
                self:notify("accessory", "Vous êtes trop lourd")
                return false
            end
        end
    end
end

function Player:removeAccessory(accessory, count)
    if Accessories[accessory] then
        if self.accessories[accessory] then
            if (self.accessories[accessory].count - count) >= 0 then
                self.accessories[accessory].count = self.accessories[accessory].count - count
                self.weight = self.weight - (Accessories[accessory].weight * count)

                if (self.accessories[accessory].count) == 0 then
                    self.accessories[accessory] = nil      
                end

                self:triggerClient("GM:refreshData:accessories", self.accessories, self.weight)
            end
        end
    end
end

function Player:saveAccessories()
    local accessories = json.encode(self:getAccessories(true))
    MySQL.Async.execute('UPDATE players SET accessories = @accessories WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@accessories'] = accessories
    }, function()
        self:triggerClient("GM:refreshData:accessories", self.accessories, self.weight)
    end)
end