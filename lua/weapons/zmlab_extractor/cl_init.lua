include("shared.lua")
include("zmlab/sh/zmlab_config.lua")
SWEP.PrintName = "Meth Extractor" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

local vmAnims = {ACT_VM_HITCENTER, ACT_VM_HITKILL}

function SWEP:SecondaryAttack()
	self:SendWeaponAnim(vmAnims[math.random(#vmAnims)])
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

--Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) -- View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) -- 3rd Person Animation
end
