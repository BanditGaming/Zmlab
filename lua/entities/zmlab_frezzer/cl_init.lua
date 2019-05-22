include("shared.lua")

function ENT:Initialize()
	self.LastUsedPositions = -1
	self.LastFrezze = 0
end

function ENT:Draw()
	self:DrawModel()
	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) and GetConVar("zmlab_cl_vfx_dynamiclight"):GetInt() == 1 then

		local dlight01 = DynamicLight(self:EntIndex())

		if (dlight01 and self:GetIsFrezzig()) then
			dlight01.pos = self:GetPos() + self:GetUp() * 50 + self:GetRight() * 20
			dlight01.r = 0
			dlight01.g = 200
			dlight01.b = 255
			dlight01.brightness = 2
			dlight01.Decay = 1000
			dlight01.Size = 300
			dlight01.DieTime = CurTime() + 1
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 600) then
		local usedPos = self:GetUsedPositions()

		if self.LastUsedPositions ~= usedPos then
			if usedPos > self.LastUsedPositions then
				self:EmitSound("frezzer_addTray")
			else
				self:EmitSound("frezzer_removeTray")
			end

			self.LastUsedPositions = usedPos
		end

		if self:GetIsFrezzig() and CurTime() > self.LastFrezze then
			self:EmitSound("progress_frezzing")
			if GetConVar("zmlab_cl_vfx_particleeffects"):GetInt() == 1 then
				ParticleEffect("zmlab_frozen_tray", self:GetPos() + self:GetUp() * 25, self:GetAngles(), self)
				ParticleEffect("zmlab_frozen_tray", self:GetPos() + self:GetUp() * 35, self:GetAngles(), self)
				ParticleEffect("zmlab_frozen_tray", self:GetPos() + self:GetUp() * 45, self:GetAngles(), self)
				ParticleEffect("zmlab_frozen_tray", self:GetPos() + self:GetUp() * 55, self:GetAngles(), self)
				ParticleEffect("zmlab_frozen_tray", self:GetPos() + self:GetUp() * 65, self:GetAngles(), self)
			end
			self.LastFrezze = CurTime() + 1
		end
	end
end
