extends Node

var EQUIPMENT_CATEGORY = {
	"A" : "card",
	"B" : "helm",
	"C" : "torso",
	"D" : "weapon",
	"E" : "gloves",
	"F" : "boots",
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
	"D" : "perfect"
}

var ITEM_TIER = {
	"A" : "common",
	"B" : "rare",
	"C" : "magic",
	"D" : "legendary",
}

enum mods { A, B, C, D, }

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
	"gloves" 	: ["crit_chance", "speed"],
	"boots" 	: ["speed", "armor_class"],
}

var LOOT_DESCRIPTIONS = {
	# Loot descriptions
	"tarot" : "Various uses",
	"strength" : "Buffs Player Damage during Encounter.",
	"the-tower" : "Buffs Player Armor Class during Encounter.",
	"the-magician" : "Buffs Player Crits during Encounter.",
	"the-hermit" : "Buffs Player Speed during Encounter.",
	"helm" : "Permanent Buff to Player.",
	"the-devil" : "Buffs Monster Tiers if Possible.",
	"death" : "Greatly Increases Enemy Health and Damage."
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
	1 : "73bed3",
	2 : "de9e41",
	3 : "a53030",
	4 : "c65197",
}

var stat_lookup = {
	# PLAYER
	"Player" : {
		"health"		: 5000,
		"armor_class"	: 0,
		"damage"		: 200,
		"speed"			: 75,
		"crit_chance"	: 0,
		"crit_damage"	: 5,
	},
	# MOBS
	"Skele" : {
		"health"		: 10,
		"armor_class"	: 0,
		"damage"		: 3,
		"speed"			: 10,
		"crit_chance"	: 15,
		"crit_damage"	: 3,
	},
}

var packed_equipment_pile: Array[String] = []

var current_arena_loadout : Array[String] = ["Skele0", "Skele0", "Skele0"]
var current_player_deck : Array[String] = ['AAA', 'BBB', 'CCC']

var current_overworld_level = 0
var current_level_name : String

func draw(n = 5) -> Array[String]:
	var max_n = min(current_player_deck.size(), n)
	randomize()
	current_player_deck.shuffle()
	print(current_player_deck)
	var hand = current_player_deck.slice(0, max_n)
	current_player_deck = current_player_deck.slice(max_n, current_player_deck.size())
	print(current_player_deck)
	return hand

func return_to_deck(hand: Array[String]):
	current_player_deck.append_array(hand)

func add_to_deck(card_code) -> void:
	current_player_deck.append(card_code)
