function Player:getInventory(minimal)
    if minimal then
        local minimalInventory = {}

        for k,v in pairs(self.inventory) do
            if v.count > 0 then
                minimalInventory[v.name] = v.count
            end
        end
        
        return minimalInventory
    else
        return self.inventory
    end
end

function Player:canUseItem(item)
    if ItemList[item].handler then
        return true
    end
end

function Player:useItem(item)
    if self:canUseItem(item) then
        Items.use(self.id, item)
    else
        self:notify("error", "Vous ne pouvez pas utiliser cet item.")
    end
end

function Player:canCarryItem(item, count)
    if ItemList[item] then
        if self.weight <= self.maxWeight then
            local calc = (self.weight + (ItemList[item].weight * count))
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

function Player:addInventory(item, count)
    if ItemList[item] then
        if self.inventory[item] then
            if (self.weight + (ItemList[item].weight * count)) <= self.maxWeight then
                self.inventory[item].count = self.inventory[item].count + count
                self.weight = self.weight + (ItemList[item].weight * count)

                local str = string.format("~g~x%s %s", count, ItemList[item].label)
                self:notify("item", "Vous avez reçu "..str)
                self:triggerClient("refreshData:inventory", self.inventory)
                return true
            else
                self:notify("item", "Vous avez trop de ~r~"..ItemList[item].label.."~s~ sur vous, ou vous êtes trop lourd.")
                return false
            end
        else
            if (self.weight + (ItemList[item].weight * count)) <= self.maxWeight then
                self.inventory[item] = {}
                self.inventory[item].label = ItemList[item].label
                self.inventory[item].name = item
                self.inventory[item].count = count
                self.weight = self.weight + (ItemList[item].weight * count)

                local str = string.format("~g~x%s %s", count, ItemList[item].label)
                self:notify("item", "Vous avez reçu "..str)
                self:triggerClient("refreshData:inventory", self.inventory)
                return true
            else
                self:notify("item", "Vous avez trop de ~r~"..ItemList[item].label.."~s~ sur vous, ou vous êtes trop lourd.")
                return false
            end
        end
    end
end

function Player:removeInventory(item, count)
    if ItemList[item] then
        if self.inventory[item] then
            if (self.inventory[item].count - count) >= 0 then
                self.inventory[item].count = self.inventory[item].count - count
                self.weight = self.weight - (ItemList[item].weight * count)

                if (self.inventory[item].count) == 0 then
                    self.inventory[item] = nil      
                end

                local str = string.format("~r~x%s %s", count, ItemList[item].label)
                self:triggerClient("refreshData:inventory", self.inventory)
            end
        end
    end
end

function Player:saveInventory()
    local inventory = json.encode(self:getInventory(true))
    MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE identifier = @identifier', {
        ['@identifier'] = self.identifier,
        ['@inventory'] = inventory
    }, function()
        self:triggerClient("refreshData:inventory", self.inventory)
    end)
end