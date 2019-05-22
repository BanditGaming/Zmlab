ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Meth DropOff"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros Meth Lab"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Deliver_PlayerID")
	self:NetworkVar("Bool", 0, "IsClosed")

	if SERVER then
		self:SetDeliver_PlayerID("nil")
		self:SetIsClosed(true)
	end
end
