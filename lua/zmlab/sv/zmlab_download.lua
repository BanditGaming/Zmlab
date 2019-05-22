if (not SERVER) then return end

if zmlab.config.EnableResourceAddfile then
	zmlab = zmlab or {}
	zmlab.force = zmlab.force or {}

	function zmlab.force.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zmlab.force.AddDir(path .. "/" .. v)
		end
	end

	zmlab.force.AddDir("materials/zerochain/particles/zmlab")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_aluminiumbox")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_combiner")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_dropoff")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_filter")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_frezzer")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_frezzertray")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_methbag")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_methylamin")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_sludge")
	zmlab.force.AddDir("materials/zerochain/zmlab/zmlab_transportcrate")
	zmlab.force.AddDir("models/zerochain/zmlab")
	zmlab.force.AddDir("particles")
	zmlab.force.AddDir("sound/zmlab")
else
	resource.AddWorkshop("1228585060") -- zmLab Contentpack
end
