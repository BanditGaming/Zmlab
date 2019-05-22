--MethConsum
sound.Add({
	name = "sfx_meth_consum_music",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 80,
	pitch = {85, 90},
	sound = "zmlab/meth_consum_music.wav"
})

sound.Add({
	name = "sfx_meth_consum01",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {85, 90},
	sound = "zmlab/meth_consum01.wav"
})

sound.Add({
	name = "sfx_meth_consum02",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {85, 90},
	sound = "zmlab/meth_consum02.wav"
})

sound.Add({
	name = "sfx_meth_consum03",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {85, 90},
	sound = "zmlab/meth_consum03.wav"
})

--Methylamin
sound.Add({
	name = "Methylamin_filling",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 65,
	pitch = {25, 30},
	sound = "ambient/water/water_flow_loop1.wav"
})

--Aluminium
sound.Add({
	name = "Aluminium_filling",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 65,
	pitch = {90, 100},
	sound = "zmlab/aluminfill01.mp3",
	"zmlab/aluminfill02.mp3"
})

--"physics/cardboard/cardboard_box_break3.wav",
sound.Add({
	name = "Aluminium_walk",
	channel = CHAN_STATIC,
	volume = 0.25,
	level = 60,
	pitch = {90, 100},
	sound = "zmlab/aluminiumshake01.mp3",
	"zmlab/aluminiumshake02.mp3", "zmlab/aluminiumshake03.mp3", "zmlab/aluminiumshake04.mp3", "zmlab/aluminiumshake05.mp3", "zmlab/aluminiumshake06.mp3"
})

--MethBuyer
sound.Add({
	name = "Meth_Sell01",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 65,
	pitch = {60, 90},
	sound = "zmlab/sfx_cash01.wav"
})
sound.Add({
	name = "zmlab_npc_wrongjob",
	channel = CHAN_STATIC,
	volume = 1,
	level = SNDLVL_45dB,
	pitch = {100, 100},
	sound = {"vo/npc/male01/pardonme01.wav", "vo/npc/male01/pardonme02.wav"}
})

sound.Add({
	name = "zmlab_npc_sell",
	channel = CHAN_STATIC,
	volume = 1,
	level = SNDLVL_45dB,
	pitch = {100, 100},
	sound = {"vo/npc/male01/question05.wav", "vo/npc/male01/question06.wav", "vo/npc/male01/question09.wav", "vo/npc/male01/question10.wav", "vo/npc/male01/question13.wav", "vo/npc/male01/question16.wav", "vo/npc/male01/question17.wav", "vo/npc/male01/question18.wav", "vo/npc/male01/question19.wav", "vo/npc/male01/question23.wav", "vo/npc/male01/question25.wav", "vo/npc/male01/question27.wav", "vo/npc/male01/question28.wav", "vo/npc/male01/question29.wav", "vo/npc/male01/question30.wav"}
})

sound.Add({
	name = "DropOffSpawn",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 70,
	pitch = {70, 90},
	sound = "doors/door_metal_thin_close2.wav",
	"doors/door_metal_thin_move1.wav", "doors/door_metal_thin_open1.wav"
})

--TransportCrate
sound.Add({
	name = "progress_fillingcrate",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 60,
	pitch = {80, 90},
	sound = "zmlab/methcrate_fill01.mp3",
	"zmlab/methcrate_fill02.mp3", "zmlab/methcrate_fill03.mp3"
})

sound.Add({
	name = "progress_collecting",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {50, 100},
	sound = "physics/plastic/plastic_barrel_impact_soft1.wav",
	"physics/plastic/plastic_barrel_impact_soft2.wav", "physics/plastic/plastic_barrel_impact_soft3.wav", "physics/plastic/plastic_barrel_impact_soft4.wav", "physics/plastic/plastic_barrel_impact_soft5.wav"
})

--Combiner
sound.Add({
	name = "Combiner_cleaning",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 70,
	pitch = {60, 90},
	sound = "ambient/water/water_splash1.wav",
	"ambient/water/water_splash2.wav", "ambient/water/water_splash3.wav"
})

sound.Add({
	name = "MethylaminSludge_pump",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {50, 70},
	sound = "ambient/levels/canals/toxic_slime_gurgle2.wav",
	"ambient/levels/canals/toxic_slime_gurgle3.wav", "ambient/levels/canals/toxic_slime_gurgle4.wav", "ambient/levels/canals/toxic_slime_gurgle5.wav", "ambient/levels/canals/toxic_slime_gurgle6.wav", "ambient/levels/canals/toxic_slime_gurgle7.wav", "ambient/levels/canals/toxic_slime_gurgle8.wav"
})

sound.Add({
	name = "progress_cooking",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {95, 110},
	sound = "/ambient/water/underwater.wav"
})

sound.Add({
	name = "progress_done",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 70,
	pitch = {95, 110},
	sound = "buttons/combine_button_locked.wav"
})

--FrezzerTray
sound.Add({
	name = "BreakingIce",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {70, 90},
	sound = "physics/plastic/plastic_box_break2.wav",
	"zmlab/meth_breaking01.mp3", "zmlab/meth_breaking02.mp3"
})

sound.Add({
	name = "ConvertingSludge",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {70, 90},
	sound = "weapons/debris1.wav"
})

--Frezzer
sound.Add({
	name = "progress_frezzing",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {80, 90},
	sound = "zmlab/meth_frezzing01.mp3",
	"zmlab/meth_frezzing02.mp3", "zmlab/meth_frezzing03.mp3", "zmlab/meth_frezzing04.mp3"
})

sound.Add({
	name = "frezzer_addTray",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {70, 90},
	sound = "doors/door_latch1.wav"
})

sound.Add({
	name = "frezzer_removeTray",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {70, 90},
	sound = "doors/door_metal_thin_open1.wav"
})

--Filter
sound.Add({
	name = "filter_break",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {80, 90},
	sound = "physics/metal/metal_box_break1.wav"
})

sound.Add({
	name = "filter_attach",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {80, 90},
	sound = "buttons/lever2.wav"
})

sound.Add({
	name = "filter_dettach",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {80, 90},
	sound = "buttons/lever3.wav"
})
