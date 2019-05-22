if (not CLIENT) then return end
local zfs_Halotable = {}
local trace
local traceEnt

hook.Add("PreDrawHalos", "zmlab_AddHalos", function()
	if (zmlab.config.meth_Consumable) then
		if (CurTime() > (lastTrace or 1)) then
			zfs_Halotable = {}
			lastTrace = CurTime() + 0.3
			trace = LocalPlayer():GetEyeTrace()
			traceEnt = trace.Entity

			-- Adds Halo
			if (IsValid(traceEnt) and traceEnt:GetClass() == "zmlab_meth_baggy") then
				table.insert(zfs_Halotable, traceEnt)
			end
		end

		halo.Add(zfs_Halotable, Color(255, 255, 255), 3, 3, 2, true, true)
	end
end)
