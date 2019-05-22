zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

if SERVER then
	function zmlab.f.Notify(ply, msg, ntfType)
		if gmod.GetGamemode().Name == "DarkRP" then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end

	-- This checks if the player is a admin
	function zmlab.f.IsAdmin(ply)
		local isAdmin = false

		if (table.HasValue(zmlab.config.allowedRanks, ply:GetUserGroup())) then
			isAdmin = true
		end

		return isAdmin
	end

	-- Does the player has the correct job
	function zmlab.f.Player_CheckJob(ply)
		local rightJob = false

		for k, v in pairs(zmlab.config.MethBuyer_customers) do
			if (v == team.GetName(ply:Team())) then
				rightJob = true
				break
			end
		end

		if zmlab.config.GameMode == "BaseWars" then
			rightJob = true
		end

		return rightJob
	end

	-- Does the player has meth?
	function zmlab.f.HasPlayerMeth(ply)
		if (ply.zmlab_meth and ply.zmlab_meth > 0) then
			return true
		else
			zmlab.f.Notify(ply, zmlab.language.methbuyer_nometh, 1)

			return false
		end
	end

	-- This saves the owners SteamID
	function zmlab.f.SetOwnerID(ent, ply)
		if (IsValid(ply)) then
			ent:SetNWString("ZMLAB_Owner", ply:SteamID())

			if CPPI then
				if zmlab.config.GlobalMethPickUp then
					local eClass = ent:GetClass()

					if eClass ~= "zmlab_collectcrate" and eClass ~= "zmlab_meth" and eClass ~= "zmlab_palette" then
						ent:CPPISetOwner(ply)
					end
				else
					ent:CPPISetOwner(ply)
				end
			end
		else
			ent:SetNWString("ZMLAB_Owner", "world")
		end
	end

	-- Creates a util.Effect
	function zmlab.f.Destruct(ent,effect)
		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect(effect, effectdata)
	end
end

-- This returns the entites owner SteamID
function zmlab.f.GetOwnerID(ent)
	return ent:GetNWString("ZMLAB_Owner", "nil")
end

-- This returns the owner
function zmlab.f.GetOwner(ent)
	if (IsValid(ent)) then
		local id = ent:GetNWString("ZMLAB_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if (IsValid(ply)) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

-- This returns true if the input is the owner
function zmlab.f.IsOwner(ply, ent)
	if (IsValid(ent)) then
		local isOwner = false

		if (zmlab.config.SharedOwnership) then
			isOwner = true
		else
			local id = ent:GetNWString("ZMLAB_Owner", "nil")
			local ply_id = ply:SteamID()

			if (IsValid(ply) and id == ply_id or id == "world") then
				isOwner = true
			else
				isOwner = false
			end
		end

		return isOwner
	end
end

-- Checks if the distance between pos01 and pos02 is smaller then dist
function zmlab.f.InDistance(pos01, pos02, dist)
	return pos01:DistToSqr(pos02) < (dist * dist)
end
