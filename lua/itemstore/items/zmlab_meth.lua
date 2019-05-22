ITEM.Name = "Meth"
ITEM.Description = "A Bag of Meth"
ITEM.Model = "models/zerochain/zmlab/zmlab_methbag.mdl"
ITEM.Base = "base_darkrp"

function ITEM:GetDescription()
	local desc = self.Description
	local MethAmount = self:GetData("MethAmount")
	desc = "Meth: " .. tostring(MethAmount)

	return self:GetData("Description", desc)
end

function ITEM:SaveData(ent)
	self:SetData("MethAmount", ent:GetMethAmount())
end

function ITEM:LoadData(ent)
	timer.Simple(0.1, function()
		if IsValid(ent) then
			ent:SetMethAmount(self:GetData("MethAmount"))
		end
	end)
end
