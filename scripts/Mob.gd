class_name Mob extends BaseEntity

@onready var lootPrefab = preload("res://scenes/Loot.tscn")

# EX: Skele0
var species
var tier


func _init():
	# Override inverted for enemy -> This is bad and we shouldn't be doing this
	inverted = true

func setup():
	# substitute with mob type
	get_stats(species, tier)
	get_child(0).set_modulate(Global.TIER_COLORS[tier])

func evaluate_attack(roll, dmg, _invert = false) -> bool:
	return await super.evaluate_attack(roll, dmg, inverted)

func kill():
	super.kill()
	var loot: Loot = lootPrefab.instantiate()
	var loot_status = loot.spawn()
	if (loot_status):
		loot.position = self.position
		get_parent().get_parent().get_node("Loot").add_child(loot)
	else:
		loot.queue_free()
