include("shared.lua")

-- Draw
function ENT:Draw()
	self:DrawModel()

	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 200) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

-- UI
function ENT:DrawInfo()
	local meth = self:GetMethAmount()
	if (meth <= 0) then return end
	local Pos = self:GetPos() + Vector(0, 0, 30)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	local Text = math.Round(meth) .. "g"
	cam.Start3D2D(Pos, Ang, 0.2)
	draw.DrawText(Text, "zmlab_font4", 0, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:Think()
	self:SetNextClientThink(CurTime()) -- Make animations run smoothly
	-- Apply NextThink() call

	return true
end
