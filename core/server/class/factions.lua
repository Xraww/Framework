Factions = {}
Factions.Init = false

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM factions', {
    }, function(result)
        for _,v in pairs(result) do
            if not Factions[v.name] then
                AddFaction(v)
            end
            Factions.Init = true
        end
    end)
end)

function AddFaction(params)
    if not Factions[params.name] then
        Factions[params.name] = {
            id = params.id,
            name = params.name,
            label = params.label,
            grades = {},
        }
        local toDecode = json.decode(params.grades)
        for _,v in pairs(toDecode) do
            Factions[params.name].grades[v.id] = v
        end
        Trace(("La faction %s à bien été initialisée"):format(params.label))
    end
end

function CreateFaction(params)
    if not Factions[params.name] then
        if params.grades then
            local toEncode = json.encode(params.grades)
            MySQL.Async.execute('INSERT INTO factions (name, label, grades) VALUES (@name, @label, @grades)', {
                ['@name'] = params.name,
                ['@label'] = params.label,
                ['@grades'] = toEncode
            }, function()
                local toAdd = {
                    name = params.name,
                    label = params.label,
                    grades = toEncode,
                }
                AddFaction(toAdd)
                Trace(("La faction %s à bien été créée"):format(params.label))
            end)
        end
    end
end

function Player:setFaction(newFaction, newGrade)
    if Factions[newFaction] then
        if Factions[newFaction].grades[newGrade] then
            self.faction = {
                name = newFaction,
                label = Factions[newFaction].label,
                grade = {
                    id = newGrade,
                    name = Factions[newFaction].grades[newGrade].name,
                    label = Factions[newFaction].grades[newGrade].label
                }
            }
        else
            Trace(("Le grade %s de la faction %s n'existe pas"):format(newGrade, newFaction))
        end
    else
        Trace(("La faction %s n'existe pas"):format(newFaction))
    end
end

function Player:getFaction(minimal)
    if minimal then
        local minimalFaction = {}

        for k,v in pairs(self.faction) do
            minimalFaction = {name = v.name, grade = v.grade.id}
            return minimalFaction
        end
    else
        return self.faction
    end
end

function Player:getFaction(minimal)
    if minimal then
        local minimalFaction = {name = self.faction.name, grade = self.faction.grade.id}
        return minimalFaction
    end
    return self.faction
end

--[[
RegisterCommand("faction", function()
    CreateFaction({
        name = "none",
        label = "Sans faction",
        grades = {
            {id = 1, name = "none", label = "Civil"}
        }
    })
end, false)
--]]