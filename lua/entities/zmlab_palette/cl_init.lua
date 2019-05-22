include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 200) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + Vector(0, 0, 50)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	local mAmount = self:GetMethAmount()

	if (mAmount > 0) then
		local Text = math.Round(mAmount) .. "g"
		cam.Start3D2D(Pos, Ang, 0.2)
		draw.DrawText(Text, "zmlab_font4", 0, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self.crateCount_Y = 0
	self.crateCount_X = 0
	self.crateCount_Z = 0
end

function ENT:CrateChangeUpdater()
	local crateCount = self:GetCrateCount()

	if self.LastCrateCount ~= crateCount then
		self.LastCrateCount = crateCount
		self:UpdateClientProps()
	end
end


function ENT:Think()
	self:SetNextClientThink(CurTime())

	--Here we create or remove the client models
	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then
		self:CrateChangeUpdater()
	else
		self:RemoveClientModels()
		self.ClientProps = {}
		self.LastCrateCount = -1
	end

	return true
end

function ENT:UpdateClientProps()
	self:RemoveClientModels()

	self.ClientProps = {}

	for i = 1, self:GetCrateCount() do
		self:CreateClientCrate(i)
	end
end

function ENT:OnRemove()
	self:RemoveClientModels()
end

function ENT:CreateClientCrate(cratecount)

	local pos = self:GetPos() + self:GetRight() * 25 + self:GetForward() * 18
	local ang = self:GetAngles()

	if (self.crateCount_X == 1 and self.crateCount_Y == 3) then
		self.crateCount_X = 0
		self.crateCount_Y = 0
		self.crateCount_Z = 1
	end

	if (self.crateCount_Z < 1) then
		pos = pos + self:GetUp() * 3
	else
		pos = pos + self:GetUp() * 17
	end

	if (self.crateCount_Y < 3) then
		pos = pos + self:GetRight() * -25 * self.crateCount_Y
	else
		self.crateCount_X = 1
		self.crateCount_Y = 0
	end

	if (self.crateCount_X > 0) then
		pos = pos + self:GetForward() * -35 * self.crateCount_X
	end

	self.crateCount_Y = self.crateCount_Y + 1


	local crate = ents.CreateClientProp("models/zerochain/zmlab/zmlab_transportcrate_full.mdl")
	crate:SetAngles(ang)
	crate:SetPos(pos)

	crate:Spawn()
	crate:Activate()

	crate:SetRenderMode(RENDERMODE_NORMAL)
	crate:SetParent(self)

	table.insert(self.ClientProps, crate)
end

function ENT:RemoveClientModels()
	self.crateCount_Y = 0
	self.crateCount_X = 0
	self.crateCount_Z = 0

	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
