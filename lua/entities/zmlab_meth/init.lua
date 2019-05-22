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
	self.PhysgunDisable = true
	self.zmlab_added = false
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["MethBag"].EntityHealth
	local ply = dmg:GetAttacker()

	if (entHealth > 0) then
		local m_amount = self:GetMethAmount()

		if m_amount > 0 then
			self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

			if (self.CurrentHealth <= 0) then
				-- If the attacker is a player with a police job then we reward that player
				if IsValid(ply) and ply:IsPlayer() and ply:Alive() and table.HasValue(zmlab.config.PoliceJobs, team.GetName(ply:Team())) then
					local Earning = m_amount * (zmlab.config.SellRanks[ply:GetNWString("usergroup", "")] or zmlab.config.SellRanks["default"])
					zmlab.f.GiveMoney(ply, Earning * zmlab.config.PoliceCut)
					zmlab.f.Notify(ply, zmlab.config.MethBuyer_Currency .. Earning, 0)
				end

				zmlab.f.Destruct(self,"WheelDust")
				self:Remove()
			end
		end
	end
end
