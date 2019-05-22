AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/zerochain/zmlab/zmlab_sludge.mdl")
	self.PhysgunDisable = true
	self:UseClientSideAnimation()
end
