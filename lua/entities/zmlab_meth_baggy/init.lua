AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 35
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zmlab.f.SetOwnerID(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel("models/zerochain/zmlab/zmlab_methbag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)
	self:SetModelScale(0.5)
	self.PhysgunDisable = true
	self.zmlab_added = false
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.Enabled = false

	timer.Simple(2, function()
		if (IsValid(self)) then
			self.Enabled = true
		end
	end)
end

function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if (not zmlab.config.meth_Consumable) then return end
	--Increase Meth Screeneffect
	zmlab.f.CreateScreenEffectTable("METH", zmlab.config.meth_EffectDuration, ply)
	--Play random tuco sounds
	ply:StopSound("sfx_meth_consum01")
	ply:StopSound("sfx_meth_consum02")
	ply:StopSound("sfx_meth_consum03")
	ply:EmitSound("sfx_meth_consum0" .. math.random(1, 3))
	local newHealth = ply:Health() - zmlab.config.meth_ConsumableDamage

	if (newHealth <= 0) then
		ply:Kill()
	else
		ply:SetHealth(newHealth)
	end

	-- Here we set the on meth logic
	if (ply.zmlab_OnMeth == false or ply.zmlab_OnMeth == nil) then
		ply.zmlab_old_WalkSpeed = ply:GetWalkSpeed()
		ply.zmlab_old_RunSpeed = ply:GetRunSpeed()
		ply:SetRunSpeed(ply:GetRunSpeed() + 200)
		ply:SetWalkSpeed(ply:GetWalkSpeed() + 200 / 2)
	end

	local playertimer = "zmlab_PlayerOnMethTimer" .. ply:Nick()

	if (timer.Exists(playertimer)) then
		timer.Remove(playertimer)
	end

	timer.Create(playertimer, zmlab.config.meth_EffectDuration, 1, function()
		if (IsValid(ply)) then
			ply.zmlab_OnMeth = false
			ply:SetRunSpeed(ply.zmlab_old_RunSpeed or 500)
			ply:SetWalkSpeed(ply.zmlab_old_WalkSpeed or 200)
		end
	end)

	ply.zmlab_OnMeth = true
	self:Remove()
end
