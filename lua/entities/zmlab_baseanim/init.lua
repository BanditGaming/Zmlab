AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

------------------------------//
-- Used to Play a Animation after another
function ENT:AnimSequence(anim1, anim2, speed)
	zmlab_CreateAnimTable(self, anim1, speed)

	timer.Simple(self:SequenceDuration(self:GetSequence()), function()
		if (not IsValid(self)) then return end
		zmlab_CreateAnimTable(self, anim2, speed)
	end)
end

function ENT:Initialize()
	self:UseClientSideAnimation()
end
