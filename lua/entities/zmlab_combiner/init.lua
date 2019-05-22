AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create("zmlab_combiner")
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
	self.DirtLevel = 0
	self.LastCleanPos = Vector(0, 0, 0)
	self:ResetMachine()
	self:SetModel("models/zerochain/zmlab/zmlab_combiner.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:UseClientSideAnimation()
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
	end

	self.PhysgunDisable = true
	self.LastStage = nil
	self.InputModule = nil
	self.CheckInput = true
	self.LastOutput = nil
	self.OutputModule = nil

	self.zmlab_outSoundTime = 0
end

function ENT:MainLogic()
	local currentStage = self:GetStage()

	if currentStage == 7 then
		self:FillLogic()
	end

	if ((self.lastLogicTick or CurTime()) > CurTime()) then return end
	self.lastLogicTick = CurTime() + 1

	if (currentStage == 2 or currentStage == 4) then
		self:TimerLogic(self:GetMaxProcessingTime())
	end

	if (currentStage == 5) then
		if (self:FilterLogic()) then
			local MethPerFilter = zmlab.config.Max_Meth_perBatch / zmlab.config.FilterProcessingTime

			if (self:GetMaxMethSludge() ~= zmlab.config.Max_Meth_perBatch) then
				local maxMeth = math.Clamp(self:GetMaxMethSludge() + MethPerFilter, 1, zmlab.config.Max_Meth_perBatch)
				self:SetMaxMethSludge(maxMeth)
			end
		end

		if (self:GetMaxProcessingTime() ~= zmlab.config.FilterProcessingTime) then
			self:SetMaxProcessingTime(zmlab.config.FilterProcessingTime)
		end

		self:TimerLogic(self:GetMaxProcessingTime())
	end

	if (currentStage == 6) then
		if (self:GetMaxMethSludge() <= 0) then
			self:SetMaxMethSludge(zmlab.config.Max_Meth_perBatch * zmlab.config.NoFilterPenalty)
		end

		if (self:GetMethSludge() < self:GetMaxMethSludge()) then
			self:SetMethSludge(math.Clamp(self:GetMethSludge() + zmlab.config.Max_Meth_perBatch / zmlab.config.FinishProcessingTime, 0, self:GetMaxMethSludge()))
		else
			--This only gets called after we reach our MaxMethSludge
			self:NextStage()
		end
	end
end

function ENT:NextStage()
	self.CheckInput = true
	self:SetStage(self:GetStage() + 1)
	local currentStage = self:GetStage()

	if (currentStage == 3) then
		self.CheckInput = true
	end

	if (zmlab.config.Combiner_DirtAmount > 0 and currentStage < 8) then
		self:DirtyMachine(zmlab.config.Combiner_DirtAmount / 8)
	end
end

function ENT:Think()
	self:MainLogic()
end

------------------------------//

------------------------------//
function ENT:TimerLogic(time)
	if (self:GetProcessingTime() < time) then
		self:SetProcessingTime(self:GetProcessingTime() + 1)
	else
		self:SetProcessingTime(0)
		self:NextStage()
	end
end

------------------------------//
------------------------------//
function ENT:StartTouch(ent)
	if IsValid(ent) then

		if not IsValid(self.InputModule) then

			local currentStage = self:GetStage()

			if ent:GetClass() == "zmlab_filter" and self:GetHasFilter() == false then

				self.InputModule = ent
				ent:Combiner_attach(self)

			elseif ent:GetClass() == "zmlab_methylamin" and currentStage == 1 and self:GetMethylamin() < self:GetNeedMethylamin() then

				self.InputModule = ent
				self:MethylaminLoader()

			elseif ent:GetClass() == "zmlab_aluminium" and currentStage == 3 and self:GetAluminium() < self:GetNeedAluminium() then

				self.InputModule = ent
				self:AluminiumLoader()
			end
		end

		if not IsValid(self.OutputModule) then

			local currentStage = self:GetStage()

			if ent:GetClass() == "zmlab_frezzingtray" and currentStage == 7 and ent.STATE == "EMPTY" then

				self.OutputModule = ent
				self:AddTray(ent)
			end
		end
	end
end

function ENT:MethylaminLoader()
	DropEntityIfHeld(self.InputModule)
	local attachID = self:LookupAttachment("input")
	local attach = self:GetAttachment(attachID)
	self.InputModule:SetPos(attach.Pos + self:GetUp() * 60 + self:GetForward() * 10)
	self.InputModule:SetParent(self, attachID)
	local ang = attach.Ang
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)
	self.InputModule:SetAngles(ang)

	local effectPos = self.InputModule:GetPos() + self.InputModule:GetUp() * 40 + self.InputModule:GetForward() * 10
	zmlab.f.CreateEffectTable("zmlab_methylamin_fill", "Methylamin_filling", self.InputModule, self:GetAngles(), effectPos)

	timer.Simple(3, function()
		if (not self:IsValid()) then return end
		self.InputModule:StopSound("Methylamin_filling")
		self:SetMethylamin(self:GetMethylamin() + 1)
		self.InputModule:Remove()
		self.InputModule = nil

		if (self:GetMethylamin() == self:GetNeedMethylamin()) then
			self:NextStage()
		else
			self.CheckInput = true
		end
	end)
end

function ENT:AluminiumLoader()
	DropEntityIfHeld(self.InputModule)

	local attachID = self:LookupAttachment("input")
	local attach = self:GetAttachment(attachID)
	self.InputModule:SetPos(attach.Pos + self:GetUp() * 40)
	self.InputModule:SetParent(self, attachID)
	local ang = attach.Ang
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)
	self.InputModule:SetAngles(ang)

	zmlab.f.CreateEffectTable("zmlab_aluminium_fill01", "Aluminium_filling", self.InputModule, self:GetAngles(), self.InputModule:GetPos())

	timer.Simple(3, function()
		if (not self:IsValid()) then return end
		self:SetAluminium(self:GetAluminium() + 1)
		self.InputModule:Remove()
		self.InputModule = nil

		if (self:GetAluminium() == self:GetNeedAluminium()) then
			self:NextStage()
		else
			self.CheckInput = true
		end
	end)
end

------------------------------//
------------------------------//
function ENT:FilterLogic()
	if (self:GetHasFilter()) then
		return true
	else
		self:PoisenDamage()

		return false
	end
end

function ENT:PoisenDamage()
	if (zmlab.config.PoisenDamage <= 0) then return end
	if ((self.lastHurt or CurTime()) > CurTime()) then return end
	self.lastHurt = CurTime() + 1

	for k, v in pairs(player.GetAll()) do
		if zmlab.f.InDistance(v:GetPos(), self:GetPos(), 150) then
			v:TakeDamage(zmlab.config.PoisenDamage, self, self)
		end
	end
end

------------------------------//
------------------------------//
function ENT:AddTray(ent)
	DropEntityIfHeld(ent)

	local attach = self:GetAttachment(self:LookupAttachment("effect03"))

	self:EmitSound("progress_fillingcrate")

	local pos = attach.Pos + attach.Ang:Up() * 13
	ent:SetPos(pos)

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(), 180)

	ent:SetAngles(ang)
	ent:SetParent(self)

	self:SetHasTray(true)
end
function ENT:FillLogic()
	if IsValid(self.OutputModule) then
		if (self:GetMethSludge() > 0) then
			if (IsValid(self.OutputModule) and self.OutputModule:GetClass() == "zmlab_frezzingtray") then
				if (self.OutputModule:GetInBucket() < zmlab.config.TrayCapacity) then
					self.OutputModule:AddSludge(zmlab.config.Combiner_PumpAmount)
					self:SetMethSludge(self:GetMethSludge() - zmlab.config.Combiner_PumpAmount)
				else
					self:DropTray(self.OutputModule)
				end
			end
		else
			self:DropTray(self.OutputModule)

			if (zmlab.config.Combiner_DirtAmount > 0) then
				self.DirtLevel = zmlab.config.Combiner_DirtAmount
				self:CheckDirtLevel()
				self:NextStage()
				self:SetCleaningProgress(self.DirtLevel)
			else
				self:ResetMachine()
			end
		end
	end
end

function ENT:DropTray(tray)
	tray:SetParent(nil)
	tray:SetPos(self:GetAttachment(self:LookupAttachment("effect03")).Pos + self:GetForward() * -50)
	tray:PhysicsInit(SOLID_VPHYSICS)
	tray:SetSolid(SOLID_VPHYSICS)
	tray:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = tray:GetPhysicsObject()
	phys:Wake()
	phys:EnableMotion(true)
	self.OutputModule = nil
	self:SetHasTray(false)
end

function ENT:ResetMachine()
	self:SetCleaningProgress(0)
	self:SetAluminium(0)

	if (zmlab.config.RndAluminium) then
		self:SetNeedAluminium(math.random(1, zmlab.config.MaxAluminium))
	else
		self:SetNeedAluminium(zmlab.config.MaxAluminium)
	end

	self:SetMethylamin(0)

	if (zmlab.config.RndMethylamin) then
		self:SetNeedMethylamin(math.random(1, zmlab.config.MaxMethylamin))
	else
		self:SetNeedMethylamin(zmlab.config.MaxMethylamin)
	end

	self:SetStage(1)
	self:SetProcessingTime(0)
	self:SetMaxProcessingTime(zmlab.config.MixProcessingTime)
	self:SetMethSludge(0)
	self:SetMaxMethSludge(-1)
	self.CheckInput = true
end

------------------------------//
------------------------------//
function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if ((self._zmlab_lastUsed or CurTime()) > CurTime()) then return end
	self._zmlab_lastUsed = CurTime() + 0.3

	if (self:GetStage() == 8 and self.DirtLevel > 0) then
		local HitPos_distance = ply:GetEyeTrace().HitPos:Distance(self.LastCleanPos)

		if (HitPos_distance > 15) then
			self.LastCleanPos = ply:GetEyeTrace().HitPos
			self:CleanMachine(zmlab.config.Combiner_CleanAmount, ply)
		end
	end
end

function ENT:CheckDirtLevel()
	if (self.DirtLevel <= 0) then
		self:ResetMachine()
		self:SetSkin(0)
	elseif (self.DirtLevel <= zmlab.config.Combiner_DirtAmount * 0.3) then
		self:SetSkin(1)
	elseif (self.DirtLevel <= zmlab.config.Combiner_DirtAmount * 0.7) then
		self:SetSkin(2)
	elseif (self.DirtLevel == zmlab.config.Combiner_DirtAmount) then
		self:SetSkin(3)
	end
end

function ENT:DirtyMachine(amount)
	self.DirtLevel = self.DirtLevel + amount
	self:CheckDirtLevel()
end

function ENT:CleanMachine(amount, ply)
	zmlab.f.CreateEffectTable("zmlab_cleaning", "Combiner_cleaning", self, self:GetAngles(), ply:GetEyeTrace().HitPos)
	self.DirtLevel = self.DirtLevel - amount
	self:SetCleaningProgress(self.DirtLevel)
	self:CheckDirtLevel()
end

------------------------------//
------------------------------//


------------------------------//
------------------------------//
function ENT:OnRemove()
	self:StopParticles()
end

------------------------------//
-- Damage Stuff
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	local damage = dmg:GetDamage()
	local entHealth = zmlab.config.Damageable["Combiner"].EntityHealth

	if (entHealth > 0) then
		self.CurrentHealth = (self.CurrentHealth or entHealth) - damage

		if (self.CurrentHealth <= 0) then
			zmlab.f.Destruct(self,"Explosion")
			self:Remove()
		end
	end
end
