include("shared.lua")

------------------------------//
function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime()) -- Make animations run smoothly
	-- Apply NextThink() call

	return true
end
