include("zmlab/sh/zmlab_config.lua")
AddCSLuaFile("zmlab/sh/zmlab_config.lua")
print("[    zmLab - Initialization.Start    ] ")

local function zmlab_LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") then
			if SERVER then
				AddCSLuaFile(fdir .. afile)
			end

			include(fdir .. afile)
			print("[    zmLab - Initialize:    ] " .. afile)
		end
	end

	for _, dir in ipairs(dirs) do
		zmlab_LoadAllFiles(fdir .. dir .. "/")
	end
end

zmlab_LoadAllFiles("zmlab_languages/")
zmlab_LoadAllFiles("zmlab/")
print("[    zmLab - Initialization.End    ] ")
