include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 250) then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + self:GetUp() * 80
	Pos = Pos + self:GetUp() * math.abs(math.sin(CurTime()) * 5)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	cam.Start3D2D(Pos, Ang, 0.1)
	draw.DrawText(zmlab.language.methbuyer_title, "zmlab_npc", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end
------------------------------//
