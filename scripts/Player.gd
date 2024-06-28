class_name Player extends BaseEntity

var deck : Array[String]
var equipment_modifiers : Dictionary

# placeholder/reminder for future use
# TODO add equipment sprite to character
# TODO add ability to add textures to the sprite??
var equipment_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# override BaseEntity values
	get_stats("Player")
	deck = Global.current_player_deck

# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	return await super.attempt_attack()

func equipment_to_stats(equipment) -> void:
	# TODO equipment conversion
	print("ADDED " + equipment + " TO PLAYER STATS")
	Global.stat_lookup["Player"]["damage"] += 2
	print("NEW DAMAGE: " + str(Global.stat_lookup["Player"]["damage"]))
