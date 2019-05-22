ITEM.Name = "TransportCrate - Meth"
ITEM.Description = "A TransportCrate full of Meth"
ITEM.Model = "models/zerochain/zmlab/zmlab_transportcrate_full.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local desc = self.Description
	local MethAmount = self:GetData("MethAmount")
	desc = "Meth: " .. tostring(MethAmount)

	return self:GetData("Description", desc)
end

function ITEM:CanPickup(pl, ent)
	if ent:GetMethAmount() >= zmlab.config.TransportCrate_Capacity then return true end

	return false
end

function ITEM:SaveData(ent)
	self:SetData("MethAmount", ent:GetMethAmount())
	self:SetModel("models/zerochain/zmlab/zmlab_transportcrate_full.mdl")
end

function ITEM:LoadData(ent)
	ent:SetMethAmount(self:GetData("MethAmount"))
	ent:Delayed_UpdateVisuals()
end
