include("shared.lua")
ZMLAB_SHAFTS = ZMLAB_SHAFTS or {}

------------------------------//
function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()

	if (IsValid(self.csModel)) then
		self.csModel:SetPos(self:GetPos())
		self.csModel:SetAngles(self:GetAngles())
	end

	local closed  = self:GetIsClosed()

	if self.Closed ~= closed then
		self.Closed = closed

		if self.Closed then

			zmlab.f.ClientAnim(self, "close", 2)
			self:EmitSound("DropOffSpawn")

			timer.Simple(2,function()
				if IsValid(self) then
					self.RenderStencil = false
				end
			end)
		else
			self.RenderStencil = true
			zmlab.f.ClientAnim(self, "open", 1)
			self:EmitSound("DropOffSpawn")
		end
	end

	self:SetNextClientThink(CurTime())
	return true
end


function ENT:CreateClientSideModel()
	self.csModel = ClientsideModel("models/zerochain/zmlab/zmlab_dropoffshaft_shaft.mdl")
	self.csModel:SetPos(self:GetPos())
	self.csModel:SetAngles(self:GetAngles())
	self.csModel:SetParent(self)
	self.csModel:SetNoDraw(true)
end

function ENT:Initialize()
	self.Closed = true
	self.RenderStencil = false
	self:CreateClientSideModel()
	ZMLAB_SHAFTS[self:EntIndex()] = self
end


function ENT:OnRemove()
	self.csModel:Remove()
end


hook.Add("PreDrawTranslucentRenderables", "zmlabdrawdropoff", function(depth, skybox)
	if skybox then return end
	if depth then return end

	for k, s in pairs(ZMLAB_SHAFTS) do
		if not IsValid(s) then continue end
		if (s.RenderStencil == false) then continue end
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(57)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilFailOperation(STENCIL_ZERO)
		render.SetStencilZFailOperation(STENCIL_ZERO)
		local angle = s:GetAngles()
		cam.Start3D2D(s:GetPos() + s:GetUp() * 1, angle, 0.5)
		surface.SetDrawColor(0, 200, 255, 200)
		draw.NoTexture()
		draw.RoundedBox(0, -45, -45, 90, 90, Color(255, 255, 255, 1))
		cam.End3D2D()
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SuppressEngineLighting(true)
		render.DepthRange(0, 0.8)

		if (IsValid(s.csModel)) then
			s.csModel:DrawModel()
		else
			s:CreateClientSideModel()
		end

		render.SuppressEngineLighting(false)
		render.SetStencilEnable(false)
		render.DepthRange(0, 1)
	end
end)
------------------------------//
