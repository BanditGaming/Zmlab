if not SERVER then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

function zmlab.f.GravGun_DropOffPoint(ply, ent)
	if ((ent:GetClass() == "zmlab_meth" or ent:GetClass() == "zmlab_collectcrate" or ent:GetClass() == "zmlab_palette") and ent:GetMethAmount() > 0) then
		for k, v in pairs(ents.FindByClass("zmlab_methdropoff")) do
			if zmlab.f.InDistance(v:GetPos(), ent:GetPos(), 45) and IsValid(v.Deliver_Player) then

				zmlab.f.SellMeth_DropOffPoint(ply, v,ent)
				break
			end
		end
	end
end

function zmlab.f.GravGun_MainLogic(ply, ent)
	zmlab.f.GravGun_DropOffPoint(ply, ent)
end

hook.Add("GravGunOnDropped", "zmlab_GravGunOnDropped", zmlab.f.GravGun_MainLogic)
