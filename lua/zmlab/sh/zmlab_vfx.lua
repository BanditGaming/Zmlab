zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

if SERVER then
	-- Animation
	util.AddNetworkString("zmlab_AnimEvent")

	local function ServerAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	function zmlab.f.CreateAnimTable(prop, anim, speed)
		if IsValid(prop) then
			//ServerAnim(prop, anim, speed)
			net.Start("zmlab_AnimEvent")
			local animInfo = {}
			animInfo.anim = anim
			animInfo.speed = speed
			animInfo.parent = prop
			net.WriteTable(animInfo)
			net.SendPVS(prop:GetPos())
		end
	end

	--Effects
	util.AddNetworkString("zmlab_FX")

	function zmlab.f.CreateEffectTable(effect, sound, parent, angle, position, attach)
		if (not zmlab.config.NoEffects) then
			local effectInfo = {}
			effectInfo.effect = effect
			effectInfo.sound = sound
			effectInfo.pos = position
			effectInfo.ang = angle
			effectInfo.parent = parent
			effectInfo.attach = attach
			net.Start("zmlab_FX")
			net.WriteTable(effectInfo)
			net.SendPVS(parent:GetPos())
		end
	end

	util.AddNetworkString("zmlab_remove_FX")

	function zmlab.f.RemoveEffectNamed(prop, effect)
		net.Start("zmlab_remove_FX")
		local effectInfo = {}
		effectInfo.effect = effect
		effectInfo.parent = prop
		net.WriteTable(effectInfo)
		net.SendPVS(prop:GetPos())
	end

	--Screeneffects
	util.AddNetworkString("zmlab_screeneffect")

	function zmlab.f.CreateScreenEffectTable(screeneffect, duration, ply)
		net.Start("zmlab_screeneffect")
		local screeneffectInfo = {}
		screeneffectInfo.screeneffect = screeneffect
		screeneffectInfo.duration = duration
		screeneffectInfo.ply = ply
		net.WriteTable(screeneffectInfo)
		net.Send(ply)
	end
end

if CLIENT then
	-- Animation
	function zmlab.f.ClientAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	net.Receive("zmlab_AnimEvent", function(len, ply)
		local animInfo = net.ReadTable()

		if (animInfo and IsValid(animInfo.parent) and animInfo.anim) then
			timer.Simple(0.1, function()
				if (IsValid(animInfo.parent)) then
					zmlab.f.ClientAnim(animInfo.parent, animInfo.anim, animInfo.speed)
				end
			end)
		end
	end)

	-- Effects
	net.Receive("zmlab_FX", function(len, ply)
		local effectInfo = net.ReadTable()

		if (effectInfo) then
			if (effectInfo.parent == nil) then return end

			if (IsValid(effectInfo.parent)) then
				if (effectInfo.sound) then
					effectInfo.parent:EmitSound(effectInfo.sound)
				end


				if effectInfo.effect and GetConVar("zmlab_cl_vfx_particleeffects"):GetInt() == 1 then
					if (effectInfo.attach) then
						ParticleEffectAttach(effectInfo.effect, PATTACH_POINT_FOLLOW, effectInfo.parent, effectInfo.attach)
					else
						ParticleEffect(effectInfo.effect, effectInfo.pos, effectInfo.ang, effectInfo.parent)
					end
				end
			end
		end
	end)

	net.Receive("zmlab_remove_FX", function(len, ply)
		local effectInfo = net.ReadTable()

		if (effectInfo and IsValid(effectInfo.parent) and effectInfo.effect) then
			effectInfo.parent:StopParticlesNamed(effectInfo.effect)
		end
	end)

	-- Screeneffects
	local screeneffect_duration = 0
	local ScreenEffectAmount = 0
	local screeneffect = nil

	--Starts our screeneffect
	net.Receive("zmlab_screeneffect", function(len, ply)
		local effectInfo = net.ReadTable()

		if (effectInfo and IsValid(effectInfo.ply) and effectInfo.screeneffect) then
			screeneffect = effectInfo.screeneffect
			screeneffect_duration = effectInfo.duration
			ScreenEffectAmount = 100 * screeneffect_duration
		end
	end)

	--Stops our screeneffect
	net.Receive("zmlab_stop_screeneffects", function(len, ply)
		screeneffect_duration = 0
		ScreenEffectAmount = 0
		screeneffect = nil
	end)

	if (not timer.Exists("zmlab_screeneffect_counter")) then
		timer.Create("zmlab_screeneffect_counter", 0.1, 0, function()
			if (ScreenEffectAmount or 0) > 0 then
				ScreenEffectAmount = ScreenEffectAmount - 10
			else
				if (screeneffect_duration > 0) then
					screeneffect_duration = 0
				end

				if (ScreenEffectAmount > 0) then
					ScreenEffectAmount = 0
				end

				if (screeneffect ~= nil) then
					screeneffect = nil
				end

				if IsValid(LocalPlayer()) then
					LocalPlayer():SetDSP(0)
				end
			end
		end)
	end

	local lastSoundStop

	local function zmlab_MethMusic()
		local ply = LocalPlayer()
		local methsound = CreateSound(ply, "sfx_meth_consum_music")

		if ScreenEffectAmount > 0 then
			if ply.zmlab_MethSoundObj == nil then
				ply.zmlab_MethSoundObj = methsound
			end

			if ply.zmlab_MethSoundObj:IsPlaying() == false then
				ply.zmlab_MethSoundObj:Play()
				ply.zmlab_MethSoundObj:ChangeVolume(0, 0)
				ply.zmlab_MethSoundObj:ChangeVolume(1, 2)
			end
		else
			if ply.zmlab_MethSoundObj == nil then
				ply.zmlab_MethSoundObj = methsound
			end

			if ply.zmlab_MethSoundObj:IsPlaying() == true then
				ply.zmlab_MethSoundObj:ChangeVolume(0, 2)
				if ((lastSoundStop or CurTime()) > CurTime()) then return end
				lastSoundStop = CurTime() + 3

				timer.Simple(2, function()
					if (IsValid(ply)) then
						ply.zmlab_MethSoundObj:Stop()
					end
				end)
			end
		end
	end

	hook.Add("RenderScreenspaceEffects", "zmlab_RenderScreenspaceEffects", function()
		if (zmlab.config.meth_EffectMusic) then
			zmlab_MethMusic()
		end

		if (ScreenEffectAmount or 0) > 0 then
			local alpha = 1 / (100 * screeneffect_duration) * ScreenEffectAmount

			if (screeneffect == "METH") then
				LocalPlayer():SetDSP(3)
				DrawBloom(alpha * 0.3, alpha * 2, alpha * 8, alpha * 8, 15, 1, 0, 0.8, 1)
				DrawMotionBlur(0.1 * alpha, alpha, 0)
				DrawSharpen(0.2 * alpha, 10 * alpha)
				DrawSunbeams(1 * alpha, 0.1 * alpha, 0.08 * alpha, 0, 0)
				DrawMaterialOverlay("effects/tp_eyefx/tpeye3", -0.2 * alpha)
				DrawMaterialOverlay("effects/water_warp01", 0.1 * alpha)
				local tab = {}
				tab["$pp_colour_colour"] = math.Clamp(0.7 * alpha, 0, 2)
				tab["$pp_colour_contrast"] = math.Clamp(2 * alpha, 1, 2)
				tab["$pp_colour_brightness"] = math.Clamp(-0.3 * alpha, -1, 1)
				tab["$pp_colour_addb"] = 0.3 * alpha
				tab["$pp_colour_addg"] = 0.2 * alpha
				DrawColorModify(tab)
			end
		end
	end)
end
