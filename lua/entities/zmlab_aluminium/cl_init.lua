include("shared.lua")

function ENT:OnRemove()
	self:StopParticles()
end

function ENT:Initialize()
	self.emitTime = -1
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:ShakeLogic()
	if ((self:GetVelocity():Length() > 200) and (self:GetVelocity():Length() < 1000) and self.emitTime < CurTime()) then
		self:EmitSound("Aluminium_walk")
		if GetConVar("zmlab_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffect("zmlab_aluminium_drops", self:GetPos(), self:GetAngles(), self)
		end
		self.emitTime = CurTime() + 0.5
	end
end

function ENT:Think()
	self:ShakeLogic()
end
