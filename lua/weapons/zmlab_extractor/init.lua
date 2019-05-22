AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("zmlab/sh/zmlab_config.lua")
SWEP.Weight = 5

--SWEP:Initialize\\
--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

local vmAnims = {ACT_VM_HITCENTER, ACT_VM_HITKILL}

function SWEP:SecondaryAttack()
	self:SendWeaponAnim(vmAnims[math.random(#vmAnims)])
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(-1, 0, 0))
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if (IsValid(ent) and ent:GetClass() == "zmlab_meth" or ent:GetClass() == "zmlab_collectcrate") then
		if (ent:GetMethAmount() <= 0) then return end
		local takeAmount

		if (ent:GetMethAmount() > zmlab.config.swep_extractor_amount) then
			takeAmount = zmlab.config.swep_extractor_amount
		else
			takeAmount = ent:GetMethAmount()
		end

		ent:SetMethAmount(ent:GetMethAmount() - takeAmount)

		if (ent:GetMethAmount() <= 0) then
			ent:Remove()
		end

		local meth = ents.Create("zmlab_meth_baggy")
		meth:SetPos(ent:GetPos() + Vector(1, 1, 25))
		meth:SetAngles(Angle(0, 0, 0))
		meth:Spawn()
		meth:Activate()
		meth:CPPISetOwner(self.Owner)
		meth:SetMethAmount(takeAmount)
	end

	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
end

function SWEP:Reload()
end

function SWEP:ShouldDropOnDie()
	return false
end
