include("shared.lua")

local StageInfo = {
	[1] = zmlab.language.combiner_step01,
	[2] = zmlab.language.combiner_step02,
	[3] = zmlab.language.combiner_step03,
	[4] = zmlab.language.combiner_step04,
	[5] = zmlab.language.combiner_step05,
	[6] = zmlab.language.combiner_step06,
	[7] = zmlab.language.combiner_step07,
	[8] = zmlab.language.combiner_step08
}

function ENT:Initialize()
	self.PoisonGasSound = CreateSound(self, Sound("/ambient/gas/steam2.wav"))
	self.PoisonGasSound:SetSoundLevel(60)

	self.FilterSound = CreateSound(self, Sound("ambient/machines/city_ventpump_loop1.wav"))
	self.FilterSound:SetSoundLevel(60)

	self.LastStage = 0
	self.HasFilter = false
	self.HasTray = false

	self.LastMethSludge = 0

	self.LastMethylamin = 0
	self.LastAluminium = 0
end

-- Draw
function ENT:Draw()
	self:DrawModel()

	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

-- UI
function ENT:DrawInfo()
	local attach = self:GetAttachment(self:LookupAttachment("screen"))

	if attach then

		local Pos = attach.Pos
		local Ang = attach.Ang

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Pos = Pos + self:GetRight() * -0.7

		local comp01_Text = "Aluminium: " .. self:GetNeedAluminium() .. " (" .. self:GetAluminium() .. ")"
		local comp02_Text = "Methylamin: " .. self:GetNeedMethylamin() .. " (" .. self:GetMethylamin() .. ")"

		cam.Start3D2D(Pos, Ang, 0.05)
			draw.RoundedBox(3, -380, -200, 760, 400, Color(50, 50, 50))

			draw.RoundedBox(0, -380, -100, 760, 5, Color(75, 75, 75))
			draw.RoundedBox(0, -380, 13, 760, 5, Color(75, 75, 75))

			local currentStage = self:GetStage()

			if (currentStage ~= 7) then
				if (currentStage == 3) then
					draw.DrawText(comp01_Text, "zmlab_font1", -350, -170, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				end

				if (currentStage == 1) then
					draw.DrawText(comp02_Text, "zmlab_font1", -350, -170, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				end
			end

			draw.DrawText(zmlab.language.combiner_nextstep, "zmlab_nextstep", -350, -90, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText(StageInfo[currentStage], "zmlab_font_info", -80, -88, Color(255, 255, 0, 255), TEXT_ALIGN_LEFT)

			if (self:GetHasFilter()) then
				draw.DrawText(zmlab.language.combiner_filter, "zmlab_font2", 340, -160, Color(0, 200, 0), TEXT_ALIGN_RIGHT)
			else
				if (currentStage == 5) then
					local glow = math.abs(math.sin(CurTime() * 6) * 255) -- Math stuff for flashing.
					local warncolor = Color(glow, 0, 0) -- This flashes red.
					draw.DrawText(zmlab.language.combiner_danger, "zmlab_font3", 350, -175, warncolor, TEXT_ALIGN_RIGHT)
				end
			end

			local procesTime = self:GetProcessingTime()
			local methSludge = self:GetMethSludge()
			local cleanProcess = self:GetCleaningProgress()

			if (procesTime > 0) then
				draw.RoundedBox(12, -349, 55, 695 , 100, Color(0, 0, 0,75))
				draw.RoundedBox(12, -349, 55, (695 / self:GetMaxProcessingTime()) * procesTime, 100, Color(0, 150, 0))
				draw.DrawText(zmlab.language.combiner_processing, "zmlab_font_processing", 0, 76, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end

			if (methSludge > 0) then
				draw.RoundedBox(12, -349, 55, 695 , 100, Color(0, 0, 0,75))
				draw.RoundedBox(12, -349, 55, (695 / self:GetMaxMethSludge()) * methSludge, 100, Color(0, 150, 255))
				draw.DrawText(zmlab.language.combiner_methsludge .. methSludge, "zmlab_font_processing", 0, 76, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end

			if (cleanProcess > 0) then
				local color01 = Color(197, 218, 231)
				local color02 = Color(45, 74, 92)
				local progress = (1 / zmlab.config.Combiner_DirtAmount) * cleanProcess
				local progressColor = LerpVector(progress, Vector(color01.r, color01.g, color01.b), Vector(color02.r, color02.g, color02.b))

				draw.RoundedBox(12, -349, 55, 695 , 100, Color(0, 0, 0,75))
				draw.RoundedBox(12, -349, 55, (695 / zmlab.config.Combiner_DirtAmount) * cleanProcess, 100, progressColor)
			end
		cam.End3D2D()
	end
end


function ENT:Think()
	if zmlab.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 600) then

		if self.ClientProps then
			if not IsValid(self.ClientProps["MethSludge"]) then
				self:SpawnClientModel_MethSludge()
			else

				local currentStage = self:GetStage()
				local hasFilter = self:GetHasFilter()
				local hasTray = self:GetHasTray()

				if self.LastStage ~= currentStage or hasFilter ~= self.HasFilter or hasTray ~= self.HasTray then

					self.ClientProps["MethSludge"]:SetNoDraw(false)

					if (currentStage == 1) then
						self.ClientProps["MethSludge"]:SetNoDraw(true)
						zmlab.f.ClientAnim(self.ClientProps["MethSludge"], "idle", 1)
					elseif (currentStage == 2) then
						zmlab.f.ClientAnim(self.ClientProps["MethSludge"], "half", 1)
					elseif (currentStage == 4 or currentStage == 5 or currentStage == 6 or currentStage == 7) then
						zmlab.f.ClientAnim(self.ClientProps["MethSludge"], "full", 1)
					elseif (currentStage == 8) then
						self.ClientProps["MethSludge"]:SetNoDraw(true)
						zmlab.f.ClientAnim(self.ClientProps["MethSludge"], "idle", 1)
					end

					-- Updates the Sound and Particle Effects
					self:VFXSoundLogic(currentStage,hasFilter)

					--Animation
					self:AnimationSwitch(currentStage,hasTray)

					self.LastStage = currentStage
					self.HasFilter = hasFilter
					self.HasTray = hasTray
				end
			end
		else
			self.ClientProps = {}
		end

		-- PumpSound and Effects
		self:OutputVFX()
	else
		self.LastStage = -1
		self.HasFilter = -1
		self.HasTray = -1

		self:StopSound("progress_cooking")
		self:StopSound("progress_done")
		self:StopSound("progress_filter")

		self:RemoveClientModels()

		if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
			self.PoisonGasSound:Stop()
		end

		if (self.FilterSound and self.FilterSound:IsPlaying()) then
			self.FilterSound:Stop()
		end

		self:StopParticles()
	end

	self:SetNextClientThink(CurTime())

	return true
end


-- Sound and Effects
function ENT:VFXSoundLogic(stage,hasFilter)

	-- Stop the current state of effects
	self:StopSound("progress_cooking")
	self:StopSound("progress_done")
	self:StopSound("progress_filter")

	if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
		self.PoisonGasSound:Stop()
	end

	if (self.FilterSound and self.FilterSound:IsPlaying()) then
		self.FilterSound:Stop()
	end

	self:StopParticles()


	-- Create the new state of effecs
	if self.LastStage ~= stage or hasFilter ~= self.HasFilter then
		if (stage == 2 or stage == 4 or stage == 6) then
			self:EmitSound("progress_cooking")
		elseif (stage == 3 or stage == 7) then
			self:StopSound("progress_cooking")
			self:EmitSound("progress_done")
		else
			self:StopSound("progress_cooking")
		end
	end

	if (stage == 5) then
		-- The Sound Stuff
		if (hasFilter) then
			if (self.PoisonGasSound:IsPlaying()) then
				self.PoisonGasSound:Stop()
			end

			if (not self.FilterSound:IsPlaying()) then
				self.FilterSound:Play()
			end
		else
			if (self.FilterSound:IsPlaying()) then
				self.FilterSound:Stop()
			end

			if (not self.PoisonGasSound:IsPlaying()) then
				self.PoisonGasSound:Play()
			end
		end
		if GetConVar("zmlab_cl_vfx_particleeffects"):GetInt() == 1 then
			if hasFilter then
				ParticleEffectAttach("zmlab_cleand_gas", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("input"))
			else
				ParticleEffectAttach("zmlab_poison_gas", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("input"))
			end
		end
	else
		if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
			self.PoisonGasSound:Stop()
		end

		if (self.FilterSound and self.FilterSound:IsPlaying()) then
			self.FilterSound:Stop()
		end
	end
end

function ENT:OutputVFX()
	local currentMeth = self:GetMethSludge()

	if self.LastMethSludge ~= currentMeth and self:GetHasTray() then

		self:EmitSound("MethylaminSludge_pump")

		local attach = self:LookupAttachment("effect0" .. math.random(1, 5))
		local attachData = self:GetAttachment(attach)
		if GetConVar("zmlab_cl_vfx_particleeffects"):GetInt() == 1 then
			ParticleEffect("zmlab_methsludge_fill", attachData.Pos, attachData.Ang, self)
		end
		self.LastMethSludge = currentMeth
	end
end

-- Animation
function ENT:AnimationSwitch(stage,hastray)

	if (stage == 7) then

		if hastray then
			zmlab.f.ClientAnim(self, "mode_pump", 1)
		else
			zmlab.f.ClientAnim(self, "mode_idle", 1)
		end
	end

	if (stage == 1 or stage == 3 or stage == 8) then
		zmlab.f.ClientAnim(self, "mode_idle", 1)
	end

	if (stage == 2 or stage == 4 or stage == 5 or stage == 6) then
		zmlab.f.ClientAnim(self, "mode_mix", 1)
	end
end

-- Client Model
function ENT:SpawnClientModel_MethSludge()
	local ent = ents.CreateClientProp("models/zerochain/zmlab/zmlab_sludge.mdl")
	ent:SetPos(self:GetPos() + self:GetUp() * 20)
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)
	ent:SetNoDraw(true)
	self.ClientProps["MethSludge"] = ent
end

function ENT:RemoveClientModels()
	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end

	self.ClientProps = {}
	self.RollCount = 0
end



function ENT:OnRemove()
	self:StopSound("progress_cooking")
	self:StopSound("progress_done")
	self:StopSound("progress_filter")

	self:RemoveClientModels()

	if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
		self.PoisonGasSound:Stop()
	end

	if (self.FilterSound and self.FilterSound:IsPlaying()) then
		self.FilterSound:Stop()
	end
end
