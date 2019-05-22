if not SERVER then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

function zmlab.f.GiveMoney(ply, amount)
    if zmlab.config.GameMode == "DarkRP" then
        ply:addMoney(amount)
    elseif zmlab.config.GameMode == "BaseWars" then
        ply:GiveMoney(amount)
    end
end
