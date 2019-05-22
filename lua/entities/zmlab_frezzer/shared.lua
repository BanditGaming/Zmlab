ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Frezzer"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros Meth Lab"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "UsedPositions")
	self:NetworkVar("Bool", 0, "IsFrezzig")

	if (SERVER) then
		self:SetUsedPositions(0)
		self:SetIsFrezzig(false)
	end
end
