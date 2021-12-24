function Player:getAccount(str)
    local type = {
        ["money"] = self.account.money,
        ["bank"] = self.account.bank,
        ["black"] = self.account.black,
    }
    return type[str]
end

function Player:canBuy(str, price)
    local type = {
        ["money"] = self.account.money,
        ["bank"] = self.account.bank,
        ["black"] = self.account.black,
    }
    if (type[str] - price) >= 0 then
        return true
    else
        return false
    end
end

function Player:addAccountMoney(str, amount)
    local type = {
        ["money"] = self.account.money,
        ["bank"] = self.account.bank,
        ["black"] = self.account.black,
    }
    if str == "money" then
        self.account.money = self.account.money + amount
    elseif str == "bank" then
        self.account.bank = self.account.bank + amount
    else
        self.account.black = self.account.black + amount
    end
    self:saveAccount()
end

function Player:removeAccountMoney(str, amount)
    local type = {
        ["money"] = self.account.money,
        ["bank"] = self.account.bank,
        ["black"] = self.account.black,
    }
    if str == "money" then
        self.account.money = self.account.money - amount
    elseif str == "bank" then
        self.account.bank = self.account.bank - amount
    else
        self.account.black = self.account.black - amount
    end
    self:saveAccount()
end

function Player:saveAccount()
    local account = json.encode(self.account)
    MySQL.Async.execute(
	    'UPDATE players SET account = @account WHERE identifier = @identifier',{
        ['@identifier'] = self.identifier,
        ['@account'] = account
    }, function()
        self:triggerClient("GM:refreshData:account", self.account)
    end)
end