ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Transport Palette"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros Meth Lab"
ENT.Model = "models/props_junk/wood_pallet001a.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "MethAmount")
	self:NetworkVar("Int", 0, "CrateCount")

	if (SERVER) then
		self:SetMethAmount(0)
		self:SetCrateCount(0)
	end
end
