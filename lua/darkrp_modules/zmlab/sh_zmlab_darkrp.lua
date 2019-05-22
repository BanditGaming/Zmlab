TEAM_ZMLAB_COOK = DarkRP.createJob("Master Meth Cook", {
	color = Color(0, 128, 255, 255),
	model = {"models/player/group03/male_04.mdl"},
	description = [[You are a Master manufacture of Methamphetamin]],
	weapons = {"zmlab_extractor"},
	command = "zmlab_MethCook",
	max = 4,
	salary = 0,
	admin = 0,
	vote = false,
	category = "Citizens",
	hasLicense = false
})

DarkRP.createCategory{
	name = "MasterMethCook",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = function(ply) return true end,
	sortOrder = 103
}

DarkRP.createEntity("Combiner", {
	ent = "zmlab_combiner",
	model = "models/zerochain/zmlab/zmlab_combiner.mdl",
	price = 6000,
	max = 1,
	cmd = "buycombiner_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Gas Filter", {
	ent = "zmlab_filter",
	model = "models/zerochain/zmlab/zmlab_filter.mdl",
	price = 1000,
	max = 2,
	cmd = "buyfilter_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Frezzer", {
	ent = "zmlab_frezzer",
	model = "models/zerochain/zmlab/zmlab_frezzer.mdl",
	price = 2000,
	max = 2,
	cmd = "buyfrezzer_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Transport Crate", {
	ent = "zmlab_collectcrate",
	model = "models/zerochain/zmlab/zmlab_transportcrate.mdl",
	price = 250,
	max = 5,
	cmd = "buycollectcrate_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Methylamin", {
	ent = "zmlab_methylamin",
	model = "models/zerochain/zmlab/zmlab_methylamin.mdl",
	price = 1000,
	max = 6,
	cmd = "buymethylamin_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Aluminium", {
	ent = "zmlab_aluminium",
	model = "models/zerochain/zmlab/zmlab_aluminiumbox.mdl",
	price = 100,
	max = 6,
	cmd = "buyaluminium_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})

DarkRP.createEntity("Transport Palette", {
	ent = "zmlab_palette",
	model = "models/props_junk/wood_pallet001a.mdl",
	price = 100,
	max = 3,
	cmd = "buypalette_zmlab",
	allowed = TEAM_ZMLAB_COOK,
	category = "MasterMethCook"
})
