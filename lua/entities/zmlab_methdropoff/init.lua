AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------//
util.AddNetworkString("zmlab_AddDropOffHint")
util.AddNetworkString("zmlab_RemoveDropOffHint")

------------------------------//
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 90)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/zerochain/zmlab/zmlab_dropoffshaft.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:UseClientSideAnimation()
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self.Deliver_Player = nil
end


function ENT:DropOff_Open(ply)
	net.Start("zmlab_AddDropOffHint")
	net.WriteVector(self:GetPos())
	net.Send(ply)
	self:SetDeliver_PlayerID(ply:SteamID64())
	self.Deliver_Player = ply

	self:SetIsClosed(false)

	timer.Create(self:EntIndex() .. "_AutoCloseTimer_" .. ply:SteamID64(), zmlab.config.MethBuyer_DeliverTime, 1, function()
		if (IsValid(self)) then
			self:DropOff_Close()
		end
	end)
end

function ENT:DropOff_Close()
	net.Start("zmlab_RemoveDropOffHint")
	net.Send(self.Deliver_Player)
	timer.Remove(self:EntIndex() .. "_AutoCloseTimer_" .. self.Deliver_Player:SteamID64())

	self.Deliver_Player.DropOffPoint = nil
	self:SetDeliver_PlayerID("nil")
	self.Deliver_Player = nil

	self:SetIsClosed(true)
end

function ENT:Use(ply, caller)
	if (ply ~= self.Deliver_Player) then return end

	if (zmlab.f.Player_CheckJob(ply) and zmlab.config.MethBuyer_Mode == 3 and zmlab.f.HasPlayerMeth(ply)) then
		zmlab.f.SellMeth_DropOffPoint_USE(ply, self)
	end
end
