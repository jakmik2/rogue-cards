class_name Player extends BaseEntity

var deck : Array[Loot]
var equipment_modifiers : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	# override BaseEntity values
	get_stats("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	return await super.attempt_attack()

func card_to_deck(card) -> void:
	pass

func equipment_to_stats(equipment) -> void:
	# TODO equipment conversion
	pass
