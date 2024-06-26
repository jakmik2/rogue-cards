class_name Player extends BaseEntity

var deck : Array[Card]
var equipment_modifiers : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	# override BaseEntity values
	get_stats("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	return await super.attempt_attack()

func card_to_deck(card) -> void:
	print("Pushing card")
	deck.push_back(card)

func equipment_to_stats(equipment) -> void:
	# TODO equipment conversion
	print("Consuming Equipment : "+ equipment['category'])
	var player_stats = Global.stat_lookup["Player"]
	print("Old stats: ", player_stats)
	player_stats[LootManager.get_stat(equipment['category'])] += LootManager.calc_value(equipment)
	print("new stats: ", player_stats)
	Global.stat_lookup["Player"] = player_stats
