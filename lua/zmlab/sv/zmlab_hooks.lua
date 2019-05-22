if not SERVER then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

// Here are some Hooks you can use for Custom Code


// Called when the player sells meth to a NPC
/*
hook.Add("zmlab_OnMethSell_NPC", "zmlab_methsellnpc_test", function(ply, methAmount, npc)
    if (IsValid(ply)) then
        print(ply:Nick() .. " sold " .. methAmount .. "g Meth to NPC " .. npc:EntIndex())
    end
end)
*/


// Called when the player drops the Meth Entity to a DropOff Point
/*
hook.Add("zmlab_OnMethSell_DropOff", "zmlab_methselldropoff_test", function(ply, methEnt, dropoffpoint)
    if (IsValid(ply)) then
        print(ply:Nick() .. " sold " .. methEnt:GetMethAmount() .. "g Meth at DropOffPoint[" .. dropoffpoint:EntIndex() .. "]")
    end
end)
*/


// Called when the player sells the Meth by Pressing E on the DropOff Point
/*
hook.Add("zmlab_OnMethSell_DropOff_Use", "zmlab_methselldropoffuse_test", function(ply, methAmount, dropoffpoint)
    if (IsValid(ply)) then
        print(ply:Nick() .. " sold " .. methAmount .. "g Meth at DropOffPoint[" .. dropoffpoint:EntIndex() .. "]")
    end
end)
*/


// Called when the player creates the Final Meth by Pressing E on the frezzing Tray
/*
hook.Add("zmlab_OnMethMade", "zmlab_OnMethMade_test", function(ply, frezzingTray, methEnt)
    if (IsValid(ply)) then
        print(ply:Nick() .. " made meth entity" .. methEnt:EntIndex() .. " on Frezzing Tray [" .. frezzingTray:EntIndex() .. "]")
    end
end)
*/


// Called when a player gets wanted for selling meth
/*
hook.Add("zmlab_OnWanted", "zmlab_OnWanted_test", function(ply)
    if (IsValid(ply)) then
        print(ply:Nick() .. " is now wanted for Selling Meth!")
    end
end)
*/
