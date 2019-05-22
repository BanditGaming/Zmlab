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
	self:SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl")
	self:SetModelScale(1)
	self:SetBodygroup(0, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:UseClientSideAnimation()

	if (zmlab.config.TransportCrate_FullCollide) then
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
	else
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	self.IsClosed = false
	self.PhysgunDisable = true
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end
end

------------------------------//
function ENT:Inputer(methObject)
	methObject.zmlab_added = true
	self:SetMethAmount(self:GetMethAmount() + methObject:GetMethAmount())
	zmlab.f.CreateEffectTable("zmlab_meth_filling", "progress_fillingcrate", self, self:GetAngles(), self:GetPos())

	if (zmlab.config.debug) then
		print("Added: " .. methObject:GetMethAmount())
		print("In Crate Now: " .. self:GetMethAmount())
	end

	methObject:Remove()
	self:UpdateVisuals()
end

------------------------------//
------------------------------//
function ENT:Delayed_UpdateVisuals()
	timer.Simple(0.1, function()
		if (IsValid(self)) then
			self.IsClosed = true
			zmlab.f.CreateAnimTable(self, "close", 10)
			self:SetBodygroup(0, 3)
		end
	end)
end

function ENT:UpdateVisuals()
	if (self:GetMethAmount() >= zmlab.config.TransportCrate_Capacity) then
		self.IsClosed = true
		zmlab.f.CreateAnimTable(self, "close", 1)
		self:SetBodygroup(0, 3)
	elseif (self:GetMethAmount() > zmlab.config.TransportCrate_Capacity * 0.7) then
		self:SetBodygroup(0, 3)
	elseif (self:GetMethAmount() > zmlab.config.TransportCrate_Capacity * 0.5) then
		self:SetBodygroup(0, 2)
	else
		self:SetBodygroup(0, 1)
	end
end

function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end

	if (not zmlab.f.Player_CheckJob(ply)) then
		zmlab.f.Notify(ply, zmlab.language.General_Interactjob, 1)

		return
	end

	if (zmlab.config.TransportCrate_NoWait) then
		if (self:GetMethAmount() <= 0) then return end
	else
		if (self:GetMethAmount() < zmlab.config.TransportCrate_Capacity) then return end
	end

	if (zmlab.config.MethBuyer_Mode == 1 or zmlab.config.MethBuyer_Mode == 3) then
		zmlab.f.CreateEffectTable(nil, "progress_fillingcrate", self, self:GetAngles(), self:GetPos())
		ply.zmlab_meth = ply.zmlab_meth or 0
		ply.zmlab_meth = ply.zmlab_meth + self:GetMethAmount()
		local string = string.Replace(zmlab.language.transportcrate_collect, "$methAmount", tostring(math.Round(self:GetMethAmount())))
		zmlab.f.Notify(ply, string, 0)
		self:Remove()
	else
		if (self:GetMethAmount() >= zmlab.config.TransportCrate_Capacity and self.IsClosed == false) then
			self.IsClosed = true
			zmlab.f.CreateAnimTable(self, "close", 1)
		end
	end
end


function ENT:StartTouch(ent)
	if IsValid(ent) and (ent:GetClass() == "zmlab_meth" or (ent:GetClass() == "zmlab_meth_baggy" and ent.Enabled)) and ent.zmlab_added == false and self:GetMethAmount() < zmlab.config.TransportCrate_Capacity then
		self:Inputer(ent)
	end
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["TransportCrate"].EntityHealth
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
