class_name Mob extends BaseEntity

@onready var lootPrefab = preload("res://scenes/Loot.tscn")

# default to Skele
var mob_type = "Skele"

func _init():
	# Override inverted for enemy -> This is bad and we shouldn't be doing this
	inverted = true

func _ready():
	# substitute with mob type
	get_stats(mob_type)

func evaluate_attack(roll, dmg, _invert = false) -> bool:
	return await super.evaluate_attack(roll, dmg, inverted)

func kill():
	super.kill()
	var loot: Loot = lootPrefab.instantiate()
	var loot_status = loot.spawn()
	if (loot_status):
		add_child(loot)
	else:
		loot.queue_free()
