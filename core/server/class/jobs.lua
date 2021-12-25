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
            self:notify("info", ("Vous avez été recruté %s - %s"):format(Jobs[newJob].label, Jobs[newJob].grades[newGrade].label))
            self:triggerClient("GM:refreshData:job", self.job)
        else
            Trace(("Le grade %s du job %s n'existe pas"):format(newGrade, newJob))
        end
    else
        Trace(("Le job %s n'existe pas"):format(newJob))
    end
end

function Player:getJob(minimal)
    if minimal then
        local minimalJob = {name = self.job.name, grade = self.job.grade.id}
        return minimalJob
    end
    return self.job
end

--[[
RegisterCommand("createJob", function()
    CreateJob({
        name = "police",
        label = "LSPD",
        grades = {
            {id = 1, name = "cadet", label = "Cadet", salary = 50},
            {id = 2, name = "officier", label = "Officier", salary = 75},
            {id = 3, name = "sergent", label = "Sergent", salary = 100},
            {id = 4, name = "lieutenant", label = "Lieutenant", salary = 125},
            {id = 5, name = "capitaine", label = "Capitaine", salary = 150},
            {id = 6, name = "commandant", label = "Commandant", salary = 175}
        }
    })
end, false)
--]]