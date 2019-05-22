if (not SERVER) then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}
util.AddNetworkString("zmlab_stop_screeneffects")

hook.Add("PlayerDeath", "zmlab_PlayerDeath", function(victim, inflictor, attacker)
    net.Start("zmlab_stop_screeneffects")
    net.Send(victim)

    if (zmlab.config.player_DropMeth_OnDeath) then
        zmlab.f.PlayerDeath(victim, inflictor, attacker)
    end
end)

local function spawnMethBox(pos)
    local ent = ents.Create("zmlab_collectcrate")
    ent:SetAngles(Angle(0, 0, 0))
    ent:SetPos(pos)
    ent:Spawn()
    ent:Activate()

    return ent
end

function zmlab.f.PlayerDeath(victim, inflictor, attacker)
    if (IsValid(victim) and victim.zmlab_meth ~= nil and victim.zmlab_meth > 0) then
        local meth = spawnMethBox(victim:GetPos() + Vector(0, 0, 10))
        meth:SetMethAmount(victim.zmlab_meth)
        meth:UpdateVisuals()
        victim.zmlab_meth = 0
        victim.zmlab_OnMeth = false

        if (victim.zmlab_old_RunSpeed) then
            victim:SetRunSpeed(victim.zmlab_old_RunSpeed)
        end

        if (victim.zmlab_old_WalkSpeed) then
            victim:SetWalkSpeed(victim.zmlab_old_WalkSpeed)
        end
    end
end

hook.Add("EntityTakeDamage", "zmlab_PlayerOnMeth_EntityTakeDamage", function(target, dmginf)
    if target:IsPlayer() and target.zmlab_OnMeth then
        dmginf:ScaleDamage(0.5)
    end
end)

local function PlayerCleanUp(pl)
    if (IsValid(pl.DropOffPoint)) then
        pl.DropOffPoint:DropOff_Close()
    end
end

local zmlab_DeleteEnts = {"zmlab_aluminium", "zmlab_collectcrate", "zmlab_combiner", "zmlab_filter", "zmlab_frezzer", "zmlab_frezzingtray", "zmlab_methylamin", "zmlab_palette"}
hook.Add("OnPlayerChangedTeam", "zmlab_OnPlayerChangedTeam", function(pl, before, after)
    PlayerCleanUp(pl)
    for k, v in pairs(ents.GetAll()) do
        if IsValid(v) and table.HasValue(zmlab_DeleteEnts, v:GetClass()) and zmlab.f.GetOwnerID(v) == pl:SteamID() then
            v:Remove()
        end
    end
end)

hook.Add("PostPlayerDeath", "zmlab_PostPlayerDeath", function(pl, text)
    PlayerCleanUp(pl)
end)

hook.Add("PlayerSilentDeath", "zmlab_PlayerSilentDeath", function(pl, text)
    PlayerCleanUp(pl)
end)
