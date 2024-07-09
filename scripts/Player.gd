class_name Player extends BaseEntity

var deck : Array[Card] = []

# placeholder/reminder for future use
# TODO add equipment sprite to character
# TODO add ability to add textures to the sprite??
var equipment_sprite
@onready var card_prefab = preload("res://scenes/Card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# override BaseEntity values
	get_stats("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	return await super.attempt_attack()

func kill() -> void:
	await super.kill()
	
	var new_timer = Timer.new()
	add_child(new_timer)
	new_timer.wait_time = 3.0
	new_timer.start()
	await new_timer.timeout
	
	get_tree().change_scene_to_file("res://scenes/Arena.tscn")

func equipment_to_stats(equipment_code) -> void:
	# liquify equipment, utilize multiple Global dictionaries
	# get stat from equipment
	var stat_modified = rand_pick_stat(equipment_code[0])
	Global.stat_lookup["Player"][stat_modified] += (
		# get base stat increase
		Global.BASE_STAT_INCREASE[stat_modified] * 
		# mult by (tier + rarity + 1)
		(Global.mods[equipment_code[2]] + Global.mods[equipment_code[2]] + 1)
	)

func rand_pick_stat(equipment_category, modifier=10) -> String:
	# randomly pick from primary and secondary stats
	# modified by modifier (higher modifier = more likely for secondary)
	var roll = randi_range(0,100)
	return Global.EQUIPMENT_STATS[Global.EQUIPMENT_CATEGORY[equipment_category]][0 if roll >= modifier else 1]
