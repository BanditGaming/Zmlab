AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 15
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
	self:SetModel("models/zerochain/zmlab/zmlab_filter.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:UseClientSideAnimation()
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.PhysgunDisable = true
	self:SetFilterHealth(zmlab.config.FilterHealth)
end

function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if (not zmlab.f.IsOwner(ply, self)) then return end

	if IsValid(self:GetCombinerEnt()) then
		self:Combiner_deattach(ply)
	end
end

function ENT:Combiner_attach(combiner)
	DropEntityIfHeld(self)
	self:SetCombinerEnt(combiner)
	self:SetPos(combiner:GetAttachment(combiner:LookupAttachment("input")).Pos + combiner:GetUp() * 7)
	self:SetAngles(combiner:GetAngles())
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:SetParent(combiner)
	combiner:SetHasFilter(true)
end

function ENT:Combiner_deattach(ply)
	local combiner = self:GetCombinerEnt()
	self:SetParent(nil)
	if IsValid(ply) then
		self:SetPos(ply:GetPos() + ply:GetUp() * 10)
	end
	self:SetAngles(combiner:GetAngles())
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	combiner.InputModule = nil
	combiner:SetHasFilter(false)
	self:SetCombinerEnt(NULL)
end

function ENT:CheckHealth()
	if (zmlab.config.FilterHealth > 0) then
		local combiner = self:GetCombinerEnt()

		if IsValid(combiner) and combiner:GetStage() == 5 then
			local filterHealth = self:GetFilterHealth()
			self:SetFilterHealth(filterHealth - 1)

			if (filterHealth <= 0) then
				combiner.CheckInput = true
				combiner:SetHasFilter(false)
				self:Remove()
			end
		end
	end
end

function ENT:Think()

	self:CheckHealth()
	self:NextThink( CurTime() + 1 )
	return true
end

-- Damage Stuff
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["Filter"].EntityHealth

	if (entHealth > 0) then
		self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

		if (self.CurrentHealth <= 0) then
			if IsValid(self:GetCombinerEnt()) then
				self:Combiner_deattach(nil)
			end

			zmlab.f.Destruct(self,"Explosion")
			self:Remove()
		end
	end
end
