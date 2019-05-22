if (not SERVER) then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

function zmlab.f.PublicEnts_Save(ply)
    if not file.Exists("zmlab", "DATA") then
        file.CreateDir("zmlab")
    end

    local ddata = {}

    for u, j in pairs(ents.FindByClass("zmlab_methdropoff")) do
        table.insert(ddata, {
            class = j:GetClass(),
            pos = j:GetPos(),
            ang = j:GetAngles()
        })
    end

    file.Write("zmlab/" .. game.GetMap() .. "_MethDropOff" .. ".txt", util.TableToJSON(ddata))
    zmlab.f.Notify(ply, "DropOffPoints have been saved for the map " .. game.GetMap() .. "!", 0)
    local bdata = {}

    for u, j in pairs(ents.FindByClass("zmlab_methbuyer")) do
        table.insert(bdata, {
            class = j:GetClass(),
            pos = j:GetPos(),
            ang = j:GetAngles()
        })
    end

    file.Write("zmlab/" .. game.GetMap() .. "_MethNPCs" .. ".txt", util.TableToJSON(bdata))
    zmlab.f.Notify(ply, "Meth BuyerNPCs have been saved for the map " .. game.GetMap() .. "!", 0)
end

function zmlab.f.PublicEnts_Load()
    timer.Simple(0.5, function()
        if file.Exists("zmlab/" .. game.GetMap() .. "_MethDropOff" .. ".txt", "DATA") then
            local data = file.Read("zmlab/" .. game.GetMap() .. "_MethDropOff" .. ".txt", "DATA")
            data = util.JSONToTable(data)

            for k, v in pairs(data) do
                local dropoff = ents.Create(v.class)
                dropoff:SetPos(v.pos)
                dropoff:SetAngles(v.ang)
                dropoff:Spawn()
                dropoff:GetPhysicsObject():EnableMotion(false)
            end

            print("[Zeros MethLab] Finished loading DropOffPoint entities.")
        else
            print("[Zeros MethLab] No map data found for DropOffPoint entities.")
        end

        if file.Exists("zmlab/" .. game.GetMap() .. "_MethNPCs" .. ".txt", "DATA") then
            local data = file.Read("zmlab/" .. game.GetMap() .. "_MethNPCs" .. ".txt", "DATA")
            data = util.JSONToTable(data)

            for k, v in pairs(data) do
                local ent = ents.Create(v.class)
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:Spawn()
                ent:Activate()
            end

            print("[Zeros MethLab] Finished loading MethBuyer entities.")
        else
            print("[Zeros MethLab] No map data found for MethBuyer entities.")
        end
    end)
end

hook.Add("InitPostEntity", "zmlab_PublicEnts_OnMapLoad", function()
    zmlab.f.PublicEnts_Load()
end)

hook.Add("PostCleanupMap", "zmlab_PublicEnts_PostCleanUp", function()
    zmlab.f.PublicEnts_Load()
end)

concommand.Add("zmlab_saveents", function(ply, cmd, args)
    if zmlab.f.IsAdmin(ply) then
        zmlab.f.PublicEnts_Save(ply)
    else
        zmlab.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
    end
end)

hook.Add("PlayerSay", "zmlab_HandleConCanCommands", function(ply, text)
    if string.sub(string.lower(text), 1, 10) == "!savezmlab" then
        if zmlab.f.IsAdmin(ply) then
            zmlab.f.PublicEnts_Save(ply)
        else
            zmlab.f.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
        end
    end
end)
