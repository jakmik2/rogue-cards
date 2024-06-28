extends Node

var EQUIPMENT_CATEGORY = {
	"A" : "card",
	"B" : "helm",
	"C" : "torso",
	"D" : "weapon",
	"E" : "boots",
	"F" : "gloves",
}

var ITEM_MATERIAL = {
	"A" : "arcane",
	"B" : "leather",
	"C" : "metal",
}

var CARD_TYPE = {
	"A" : "the-magician",
	"B" : "strength",
	"C" : "the-tower",
	"D" : "the-hermit",
	"E" : "the-devil",
	"F" : "death",
}

var ITEM_RARITY = {
	"A" : "worn",
	"B" : "fine",
	"C" : "exceptional",
}

var ITEM_TIER = {
	"A" : "common",
	"B" : "rare",
	"C" : "magic",
}


# enum tier_and_rarity { A, B, C }
# base stat increase, increased by base tier + rarity + 1
var BASE_STAT_INCREASE = {
	"health"		: 10,
	"armor_class"	: 2,
	"damage"		: 5,
	"speed"			: 1,
	"crit_chance"	: 0.5,
	"crit_damage"	: 0.5,
}

var EQUIPMENT_STATS = {
	"helm" 		: ["health", "damage"],
	"torso" 	: ["armor_class", "health"],
	"weapon" 	: ["damage", "crit_chance"],
	"boots" 	: ["crit_chance", "speed"],
	"gloves" 	: ["speed", "armor_class"],
}

var LOOT_DESCRIPTIONS = {
	# Loot descriptions
	"tarot" : "Various uses",
	"strength" : "Buffs All Damage during fight.",
	"the-tower" : "Buffs All Armor Classes during fight.",
	"the-magician" : "Buffs All Crits during fight.",
	"the-hermit" : "Buffs All Speed during fight.",
	"helm" : "Permanent Buff to Hero.",
	"the-devil" : "Buffs Monster Tiers if Possible.",
	"death" : "Greatly Increases Enemy Health and Damage"
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
		"health"		: 30,
		"armor_class"	: 0,
		"damage"		: 10,
		"speed"			: 11,
		"crit_chance"	: 0,
		"crit_damage"	: 5,
	},
	# MOBS
	"Skele" : {
		"health"		: 10,
		"armor_class"	: 0,
		"damage"		: 5,
		"speed"			: 10,
		"crit_chance"	: 15,
		"crit_damage"	: 3,
	},
}

var current_arena_loadout : Array[String] = ["Skele0", "Skele0", "Skele0"]
var current_player_deck : Array[String] = []

