include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) and self:GetInBucket() > 0 then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), -90)
	Pos = Pos + self:GetRight() * -1
	Pos = Pos + self:GetUp() * 1
	cam.Start3D2D(Pos, Ang, 0.2)
	local text = math.Round(self:GetInBucket()) .. "g"

	draw.DrawText(text, "zmlab_font4", 50, -20, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end
