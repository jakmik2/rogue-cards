extends Node

var LOOT_DESCRIPTIONS = {
	# Loot descriptions
	"TAROT" : "Various uses",
	"ATTACK" : "Buffs Hero Damage during fight.",
	"DEFENSE" : "Buffs Hero Armor Class during fight.",
	"MAGIC" : "Buffs Hero Crit Chance during fight.",
	"UTILITY" : "Buffs Hero Speed during fight.",
	"EQUIPMENT" : "Permanent Small Buff to Hero.",
	"MONSTER" : "Buffs Monsters during fight, raises Rewards.",
}

var TAROT_CARDS = [ # numbered 0 to 21
	"THE_FOOL", 		"THE_MAGICIAN", 	"THE_HIGH_PRIESTESS", 	"THE_EMPRESS",
	"THE_EMPEROR", 		"THE_HIEROPHANT", 	"THE_LOVERS", 			"THE_CHARIOT", 
	"JUSTICE", 			"THE_HERMIT", 		"WHEEL_OF_FORTUNE", 	"STRENGTH",
	"THE_HANGED_MAN", 	"DEATH", 			"TEMPERANCE", 			"THE_DEVIL",
	"THE_TOWER", 		"THE_STAR", 		"THE_MOON", 			"THE_SUN",
	"JUDGEMENT", 		"THE_WORLD",
]

var TIER_COLORS = {
	0 : "ffffff",
	1 : "00ffff",
	2 : "ffff00",
	3 : "ff0000",
}

var stat_lookup = {
	# PLAYER
	"Player" : {
		"health" : 30,
		"armor_class" : 0,
		"damage" : 5,
		"speed" : 11,
		"crit_chance" : 0,
		"crit_damage" : 5,
	},
	# MOBS
	"Skele" : {
		"health" : 10,
		"armor_class" : 0,
		"damage" : 1,
		"speed" : 10,
		"crit_chance" : 15,
		"crit_damage" : 3,
	},
}

var current_arena_loadout : Array[String] = ["Skele0", "Skele0", "Skele0"]

