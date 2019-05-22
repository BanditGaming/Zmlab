zmlab = zmlab || {}
zmlab.config = zmlab.config || {}

////////////////////////////////////////////////////////////////////////////////

// Bought by 76561198049890554
// Version 1.2.9c

////////////////////////////////////////////////////////////////////////////////
// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242

// If you wish to contact me:
// clemensproduction@gmail.com

////////////////////////////////////////////////////////////////////////////////
//////////////BEFORE YOU START BE SURE TO READ THE README.TXT////////////////////
////////////////////////////////////////////////////////////////////////////////



// Misc
///////////////////////
// This enables fast download
zmlab.config.EnableResourceAddfile = true

// Some debug information
zmlab.config.debug = false

// Disables the Owner Checks so everyone can use everyones methlab entitys
zmlab.config.SharedOwnership = false

// This lets you set what Language we want do use
// en,de,dk,es,fr,pl,ru,tr
zmlab.config.SelectedLanguage = "en"

// These Ranks are allowed do use the Chat Command  !savezmlab  which saves all the NPCs and DropOff Points
zmlab.config.allowedRanks = {
	"superadmin",
	"owner",
}

// Do we have VrondakisLevelSystem installed?
zmlab.config.VrondakisLevelSystem = true
zmlab.config.Vrondakis = {}
zmlab.config.Vrondakis["Selling"] = {XP = 1}	// XP per Sold meth (10g = 10XP)
zmlab.config.Vrondakis["BreakingIce"] = {XP = 1} // XP per produced meth g (10g = 10XP)


// This disables all the Particle/Audio FX
zmlab.config.NoEffects = false
//*Note All the Effects get created by default on Client via NetMessage but if you have a massive SERVER with 90> Players then disabling the effects can increase Performance
///////////////////////




// General
///////////////////////
// This is used for making sure the right functions are used
zmlab.config.GameMode = "DarkRP"
// Currently available:
// "DarkRP" is used for the DarkRP GameMode and all that derieve from it
// "BaseWars" is used for the BaseWars GameMode

// Sell Currency
zmlab.config.MethBuyer_Currency = "$"

// The Damage the entitys have do take before they get destroyed.
// Setting it to -1 disables it
zmlab.config.Damageable = {}
zmlab.config.Damageable["Combiner"] = {EntityHealth = 200}
zmlab.config.Damageable["Frezzer"] = {EntityHealth = 150}
zmlab.config.Damageable["MethylaminBarrel"] = {EntityHealth = 25}
zmlab.config.Damageable["Filter"] = {EntityHealth = 100}
zmlab.config.Damageable["TransportCrate"] = {EntityHealth = 100}
zmlab.config.Damageable["MethBag"] = {EntityHealth = 25}
zmlab.config.Damageable["TransportPalette"] = {EntityHealth = 150}

// Do we want to allow everyone to gravgun MethBags, TransportCrates and Palette Entities?
zmlab.config.GlobalMethPickUp = true

// Should the player gets wanted once he sells meth?
zmlab.config.WantedOnMethSell = true

// These jobs can get extra money if they destroy TransportCrates filled with meth and also get a Wanted notification once a player sells meth
zmlab.config.PoliceJobs = {
	"Imperial Army",
	"Republic Army",
	"Jedi Order",
	"Sith Order",
}

// The money the police player receives (for destroying the TransportCrate) is the same amount the meth producer receives times this value
// 1 = 100% , 0.5 = 50%
zmlab.config.PoliceCut = 1

// How much MethSludge do we get if we dont use a filter 1 = 100%, 0.5 = 50%, 0.25 = 25%
zmlab.config.NoFilterPenalty = 0.25

// The Health of the Filter (Setting it to 0 disables the Filter losing Health)
zmlab.config.FilterHealth = 250
// *Note* When the Combiner is in the Filtering Process then the Filter is gonna lose Health every Second if he is installed.

// The damage a player in distance gets per Second if there is no filter installed (Setting it to 0 disables the Damage)
zmlab.config.PoisenDamage = 1
///////////////////////




// Meth
///////////////////////
// Should the player drop all of his meth on Death?
zmlab.config.player_DropMeth_OnDeath = true

// Should the meth be consumable?
zmlab.config.meth_Consumable = true

// The Damage a player gets when consuming meth
zmlab.config.meth_ConsumableDamage = 10

// The duration a bag of meth can get you high, This can stack by multiple consumbtion
zmlab.config.meth_EffectDuration = 30

// This enables the music that plays while the player is high
//*Note The music can only be heard from the player that uses the drug
zmlab.config.meth_EffectMusic = true

zmlab.config.swep_extractor_disable = false

// How much Meth do we extract per click
// *Note This extracts a small bag of meth from a transport crate or Big Bag
zmlab.config.swep_extractor_amount = 25
///////////////////////




// Production
///////////////////////
// This Values Defines needed Methylamin amount
zmlab.config.MaxMethylamin = 3

// Do we want do randomize the needed Methylamin amount for each Cook? (If yes then it will use zmlab.config.MaxMethylamin as max value)
zmlab.config.RndMethylamin = true

// This Values Defines needed Aluminium amount
zmlab.config.MaxAluminium = 5

// Do we want do randomize the needed Aluminium amount for each Cook? (If yes then it will use zmlab.config.MaxAluminium as max value)
zmlab.config.RndAluminium = true

// This Values Defines the Producing Time in seconds
zmlab.config.MixProcessingTime = 60 // 60

// This Values Defines the Finishing MethSludge Time in seconds
zmlab.config.FinishProcessingTime = 100 //100

// This Values Defines the Filtering Time in seconds.
zmlab.config.FilterProcessingTime = 200 // 200
// *Note* I made FilterProcessingTime as a seperate Value since in this time the Filter can lose Health and the Player can get Damage depending on the Values bellow.
///////////////////////



// Post Production
///////////////////////
// This Values Defines the Meth Sludge the combiner can produce per Cook
zmlab.config.Max_Meth_perBatch = 1200

// This Values Defines how fast the Meth Sludge gets Pumped out of the Combiner
zmlab.config.Combiner_PumpAmount = 10

// The amount a frezzing Tray can hold
zmlab.config.TrayCapacity = 250

// How much dirty gets the combiner per Batch (Setting it to 0 means it never gets dirty)
zmlab.config.Combiner_DirtAmount = 125

// How much dirt can the player clean per Use/Click
zmlab.config.Combiner_CleanAmount = 10

// How much Meth do we lose when breaking it (0.05 = 5%)
zmlab.config.MethBreakLoss = 0.05

// How much Meth does remain after its frozen/dry (0.05 = 5%)
zmlab.config.MethFrezzeLoss = 0.1

// The Time in seconds it takes for the Meth do frezze
zmlab.config.FrezzingProcess = 25

// The amount a Transport crate can hold
zmlab.config.TransportCrate_Capacity = 1000

// This will let you collect the TransportCrate no matter if its complete full or not (Only works on zmlab.config.MethBuyer_Mode 1 and 3)
zmlab.config.TransportCrate_NoWait = true

// Should the TransportCrate collide with everything?
zmlab.config.TransportCrate_FullCollide = true
///////////////////////


// Meth Buyer
///////////////////////
// The Model of the Meth Buyer
zmlab.config.MethBuyer_Model = "models/Humans/Group03/male_07.mdl"
// Note* You need do make sure the Model got compiled with the animations you want to use

// Sell Price per unit
// Examble: 1kg Meth = 7$ for a user Rank
zmlab.config.SellRanks = {
	["default"] = 5, // This value gets used if the players rank is not definied in the table
	["user"] = 7,
	["superadmin"] = 15,
	["vip"] = 10,
}

// Here you can add all the Jobs that can sell Meth
//*Note* This has do be the exact name of the Job
zmlab.config.MethBuyer_customers = {
	"Galactic Citizen",
	"Smuggler",
}

// Do we want do Show a Sell/Cash Effect if the user sells something?
zmlab.config.MethBuyer_ShowEffect = true

// What Sell mode do we want?
zmlab.config.MethBuyer_Mode = 3
// 1 = Methcrates can be absorbed by Players and sold by the MethBuyer on use
// 2 = Methcrates cant be absorbed and the MethBuyer tells you a dropoff point instead (Palette Entity gets used here for easier transport)
// 3 = Methcrates can be absorbed and the MethBuyer tells you a dropoff point


// Do we want the DropOff Point do close as soon as it gets a Meth Drop
zmlab.config.MethBuyer_DropOffPoint_OnTimeUse = true

// The Time in seconds before Dropoff Point closes.
zmlab.config.MethBuyer_DeliverTime = 60

// The Time in seconds till you can request another dropoff point.
zmlab.config.MethBuyer_DeliverRequest_CoolDown = 60

// The Color of the Meth Drop Indicator Circle
zmlab.config.DropOffPoint_CircleColor = Color( 0, 200, 255, 255)

// The Color of the Meth Drop Indicator Text
zmlab.config.DropOffPoint_TextColor = Color( 255, 255, 255, 255)
///////////////////////
