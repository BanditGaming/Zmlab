AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 35
	local ent = ents.Create("zmlab_frezzingtray")
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
	self:SetModel("models/zerochain/zmlab/zmlab_frezzertray.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true)
		phys:SetAngleDragCoefficient(1)
	end

	self.PhysgunDisable = true
	self.STATE = "EMPTY"
	self.InFrezzer = false
	self.BreakState = 0
end

------------------------------//
function ENT:Use(ply, caller)
	if (not self:IsValid()) then return end
	if ((self._zmlab_lastUsed or CurTime()) > CurTime()) then return end
	self._zmlab_lastUsed = CurTime() + 0.3
	if (self.InFrezzer) then return end

	if (self.STATE == "METH") then
		self.BreakState = self.BreakState + 1
		zmlab.f.CreateEffectTable("zmlab_meth_breaking", "BreakingIce", self, self:GetAngles(), ply:GetEyeTrace().HitPos)

		if (self.BreakState == 3) then
			self:EmptyTray(ply)
		elseif (self.BreakState == 2) then
			self:SetSkin(3)
		elseif (self.BreakState == 1) then
			self:SetSkin(2)
		end
	end
end

------------------------------//
function ENT:AddSludge(amount)
	self:SetBodygroup(0, 1)
	self.STATE = "SLUDGE"
	self:SetInBucket(self:GetInBucket() + amount)
end

function ENT:ConvertSludge()
	self:SetBodygroup(0, 2)
	self:SetSkin(1)
	self.STATE = "METH"
	self:SetInBucket(self:GetInBucket() * (1 - zmlab.config.MethFrezzeLoss))
	zmlab.f.CreateEffectTable(nil, "ConvertingSludge", self, self:GetAngles(), self:GetPos())
end

function ENT:EmptyTray(ply)
	local meth = ents.Create("zmlab_meth")
	meth:SetPos(self:GetPos() + Vector(1, 1, 15))
	meth:SetAngles(self:GetAngles())
	meth:Spawn()
	meth:Activate()
	zmlab.f.SetOwnerID(meth, zmlab.f.GetOwner(self))

	local methAmount = self:GetInBucket() * (1 - zmlab.config.MethBreakLoss)
	meth:SetMethAmount(methAmount)
	constraint.NoCollide(meth, self, 0, 0)

	--Vrondakis
	if (zmlab.config.VrondakisLevelSystem) then
		ply:addXP(zmlab.config.Vrondakis["BreakingIce"].XP * methAmount, " ", true)
	end

	self:SetBodygroup(0, 0)
	self:SetSkin(0)
	self.STATE = "EMPTY"
	self:SetInBucket(0)
	self:SetFrezzingProgress(0)
	self.BreakState = 0

	hook.Run("zmlab_OnMethMade", ply, self, meth)
end
------------------------------//
