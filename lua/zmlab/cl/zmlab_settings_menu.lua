if not CLIENT then return end
local Created = false

CreateConVar("zmlab_cl_vfx_particleeffects", "1", {FCVAR_ARCHIVE})
CreateConVar("zmlab_cl_vfx_dynamiclight", "1", {FCVAR_ARCHIVE})

local function zmlab_settings(CPanel)
	Created = true
	CPanel:AddControl("Header", {
		Text = "Client Settings",
		Description = "Here you can change SFX and VFX Settings."
	})

	CPanel:AddControl("label", {
		Text = "__________________________________"
	})


	local ParticleEffects = CPanel:AddControl("CheckBox", {
		Label = "ParticleEffects",
		Command = "zmlab_cl_vfx_particleeffects"
	})
	ParticleEffects.OnChange = function(panel, bVal)
		if (not Created) then
			if ((bVal and 1 or 0) == cvars.Number("zmlab_cl_vfx_particleeffects")) then return end
			RunConsoleCommand("zmlab_cl_vfx_particleeffects", tostring(bVal))
		end
	end


	local DynamicLights = CPanel:AddControl("CheckBox", {
		Label = "Dynamic Lights",
		Command = "zmlab_cl_vfx_dynamiclight"
	})
	DynamicLights.OnChange = function(panel, bVal)
		if (not Created) then
			if ((bVal and 1 or 0) == cvars.Number("zmlab_cl_vfx_dynamiclight")) then return end
			RunConsoleCommand("zmlab_cl_vfx_dynamiclight", tostring(bVal))
		end
	end

	timer.Simple(0.1, function()
		if (ParticleEffects) then
			ParticleEffects:SetValue(GetConVar("zmlab_cl_vfx_particleeffects"):GetInt())
		end

		if (DynamicLights) then
			DynamicLights:SetValue(GetConVar("zmlab_cl_vfx_dynamiclight"):GetInt())
		end
		Created = false
	end)
end


hook.Add( "PopulateToolMenu", "PopulatezmlabMenus", function()
	spawnmenu.AddToolMenuOption( "Options", "Zeros Methlab", "zmlab_Settings", "Client Settings", "", "", zmlab_settings )
end )

hook.Add( "AddToolMenuCategories", "CreatezmlabCategories", function()
	spawnmenu.AddToolCategory( "Options", "Zeros Methlab", "Zeros Methlab" );
end )
