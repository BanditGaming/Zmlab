if not SERVER then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

-- Is the player allowed do get another droppoff point or is there still a cooldown to wait
function zmlab.f.Player_DropOffRequest(ply)
    if (ply.NextDropoffRequest == nil or ply.NextDropoffRequest < CurTime()) then
        return true
    else
        local string = string.Replace(zmlab.language.methbuyer_requestfail_cooldown, "$DropRequestCoolDown", math.Round(ply.NextDropoffRequest - CurTime()))
        zmlab.f.Notify(ply, string, 1)

        return false
    end
end

-- Does the player have allready a DropOffPoint?
function zmlab.f.HasPlayerDropOffPoint(ply)
    if (not ply.DropOffPoint or not IsValid(ply.DropOffPoint)) then
        return true
    else
        zmlab.f.Notify(ply, zmlab.language.methbuyer_requestfail, 1)

        return false
    end
end

-- This searches and returns a valid dropoffpoint
function zmlab.f.SearchUnusedDropOffPoint(ply)
    local unUsedDropOffs = {}

    for k, v in pairs(ents.FindByClass("zmlab_methdropoff")) do
        if (not IsValid(v.Deliver_Player)) then
            table.insert(unUsedDropOffs, v)
        end
    end

    if (table.Count(unUsedDropOffs) > 0) then
        local ent = unUsedDropOffs[math.random(#unUsedDropOffs)]

        return ent
    else
        return false
    end
end

-- This assigns a DropOffPoint
function zmlab.f.AssignDropOffPoint(ply, dropoffpoint)
    if (dropoffpoint) then
        dropoffpoint:DropOff_Open(ply)
        ply.DropOffPoint = dropoffpoint
        zmlab.f.Notify(ply, zmlab.language.methbuyer_dropoff_assigned, 0)
    else
        zmlab.f.Notify(ply, zmlab.language.methbuyer_requestfail_nonfound, 1)
    end
end

-- This handles the main sell action
function zmlab.f.SellMeth(ply,meth)

    -- Give the player the Cash
    local Earning = meth * ( zmlab.config.SellRanks[ply:GetNWString("usergroup", "")] or zmlab.config.SellRanks["default"])
    zmlab.f.GiveMoney(ply, Earning)

    --Vrondakis
    if (zmlab.config.VrondakisLevelSystem) then
        ply:addXP(zmlab.config.Vrondakis["Selling"].XP * meth, " ", true)
    end

    -- Create VFX
    if (zmlab.config.MethBuyer_ShowEffect) then
        if (meth > 200) then
            zmlab.f.CreateEffectTable("zmlab_sell_effect_big", "Meth_Sell01", ply, ply:GetAngles(), ply:GetPos())
        else
            zmlab.f.CreateEffectTable("zmlab_sell_effect_small", "Meth_Sell01", ply, ply:GetAngles(), ply:GetPos())
        end
    end

    -- Notify the player
    local string = string.Replace(zmlab.language.methbuyer_soldMeth, "$methAmount", tostring(math.Round(meth)))
    string = string.Replace(string, "$earning", tostring(math.Round(Earning)))
    string = string.Replace(string, "$currency", zmlab.config.MethBuyer_Currency)
    zmlab.f.Notify(ply, string, 0)

    -- Informs the police
    zmlab.f.AlarmPolice(ply)
end

-- Called when Meth gets sold by a npc
function zmlab.f.SellMeth_NPC(ply, buyer)

    hook.Run("zmlab_OnMethSell_NPC", ply, meth,buyer)

    zmlab.f.SellMeth(ply,ply.zmlab_meth)

    -- Resets Players Meth amount
    ply.zmlab_meth = 0
end

-- Called when meth gets sold via gravgun drop
function zmlab.f.SellMeth_DropOffPoint(ply, droppoint,methEnt)

    if (ply ~= droppoint.Deliver_Player) then
        local string = string.Replace(zmlab.language.methbuyer_dropoff_wrongguy, "$deliverguy", tostring(droppoint.Deliver_Player:Nick()))
        zmlab.f.Notify(ply, string, 0)
    end

    hook.Run("zmlab_OnMethSell_DropOff", ply, methEnt,droppoint)

    zmlab.f.SellMeth(droppoint.Deliver_Player,methEnt:GetMethAmount())

    if (zmlab.config.MethBuyer_DropOffPoint_OnTimeUse) then
        droppoint:DropOff_Close()
    end
    if IsValid(methEnt) then
        methEnt:Remove()
    end
end

-- Called when meth gets sold via use
function zmlab.f.SellMeth_DropOffPoint_USE(ply, droppoint)
    zmlab.f.SellMeth(ply,ply.zmlab_meth)

    hook.Run("zmlab_OnMethSell_DropOff_Use", ply, ply.zmlab_meth,droppoint)


    if (zmlab.config.MethBuyer_DropOffPoint_OnTimeUse) then
        droppoint:DropOff_Close()
    end

    -- Resets Players Meth amount
    ply.zmlab_meth = 0
end

-- This performs the Core Logic of the Meth Selling
function zmlab.f.SellSystem(ply, buyer)
    if (not zmlab.f.Player_CheckJob(ply)) then
        zmlab.f.Notify(ply, zmlab.language.methbuyer_wrongjob, 1)
        buyer:EmitSound("zmlab_npc_wrongjob")
        return
    end


    --1 = Methcrates can be absorbed by Players and sold by the MethBuyer on use
    if (zmlab.config.MethBuyer_Mode == 1) then
        if (zmlab.f.HasPlayerMeth(ply)) then
            zmlab.f.SellMeth_NPC(ply, buyer)
            buyer:EmitSound("zmlab_npc_sell")
        end

    -- 2 = Methcrates cant be absorbed and the MethBuyer tells you a dropoff point instead
    elseif (zmlab.config.MethBuyer_Mode == 2 and zmlab.f.HasPlayerDropOffPoint(ply) and zmlab.f.Player_DropOffRequest(ply)) then
        local dropoffpoint = zmlab.f.SearchUnusedDropOffPoint(ply)

        if (dropoffpoint) then
            ply.NextDropoffRequest = CurTime() + zmlab.config.MethBuyer_DeliverRequest_CoolDown
        end
        buyer:EmitSound("zmlab_npc_sell")
        zmlab.f.AssignDropOffPoint(ply, dropoffpoint)

    -- 3 = Methcrates can be absorbed and the MethBuyer tells you a dropoff point
    elseif (zmlab.config.MethBuyer_Mode == 3 and zmlab.f.Player_DropOffRequest(ply) and zmlab.f.HasPlayerDropOffPoint(ply) and zmlab.f.HasPlayerMeth(ply)) then

        local dropoffpoint = zmlab.f.SearchUnusedDropOffPoint(ply)

        if (dropoffpoint) then
            ply.NextDropoffRequest = CurTime() + zmlab.config.MethBuyer_DeliverRequest_CoolDown
        end
        buyer:EmitSound("zmlab_npc_sell")
        zmlab.f.AssignDropOffPoint(ply, dropoffpoint)
    end
end

-- Informs the police that the player just sold meth
function zmlab.f.AlarmPolice(ply)
    if zmlab.config.WantedOnMethSell == false then return end

    hook.Run("zmlab_OnWanted", ply)

    local police = {}

    for k, v in pairs(player.GetAll()) do
        if (table.HasValue(zmlab.config.PoliceJobs, team.GetName( v:Team() ) ) ) then
            table.insert(police,v)
        end
    end

    if (police and table.Count(police) > 0) then
        for k, v in pairs(police) do
            ply:wanted(v, zmlab.language.General_WantedNotify, 120)
        end
    end
end
