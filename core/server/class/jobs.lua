Jobs = {}
Jobs.Init = false

CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM jobs', {
    }, function(result)
        for _,v in pairs(result) do
            if not Jobs[v.name] then
                AddJob(v)
            end
            Jobs.Init = true
        end
    end)
end)

function AddJob(params)
    if not Jobs[params.name] then
        Jobs[params.name] = {
            id = params.id,
            name = params.name,
            label = params.label,
            grades = {},
        }
        local toDecode = json.decode(params.grades)
        for _,v in pairs(toDecode) do
            Jobs[params.name].grades[v.id] = v
        end
        Trace(("Le job %s à bien été initialisé"):format(params.label))
    end
end

function CreateJob(params)
    if not Jobs[params.name] then
        if params.grades then
            local toEncode = json.encode(params.grades)
            MySQL.Async.execute('INSERT INTO jobs (name, label, grades) VALUES (@name, @label, @grades)', {
                ['@name'] = params.name,
                ['@label'] = params.label,
                ['@grades'] = toEncode
            }, function()
                local toAdd = {
                    name = params.name,
                    label = params.label,
                    grades = toEncode,
                }
                AddJob(toAdd)
                Trace(("Le job %s à bien été crée"):format(params.label))
            end)
        end
    end
end

function Player:setJob(newJob, newGrade)
    if Jobs[newJob] then
        if Jobs[newJob].grades[newGrade] then
            self.job = {
                name = newJob,
                label = Jobs[newJob].label,
                grade = {
                    id = newGrade,
                    name = Jobs[newJob].grades[newGrade].name,
                    label = Jobs[newJob].grades[newGrade].label
                }
            }
        else
            Trace(("Le grade %s du job %s n'existe pas"):format(newGrade, newJob))
        end
    else
        Trace(("Le job %s n'existe pas"):format(newJob))
    end
end

--[[
RegisterCommand("job", function()
    CreateJob({
        name = "none",
        label = "Sans emploi",
        grades = {
            {id = 1, name = "none", label = "Chômeur", salary = 50}
        }
    })
end, false)
--]]