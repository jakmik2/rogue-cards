extends BaseEntity

@export var is_player = false				# Not a player character
@export var loot_tier = randi_range(0,2)	# Loot Tier for skele
@export var loot = {11:'N', 15:'W', 19:'A', 20:'S'}

# Called when the node enters the scene tree for the first time.
func _init():
# Override inverted for enemy -> This is bad and we shouldn't be doing this
	inverted = true

func attempt_attack():
	print("Goblin Scum!")
	return await super.attempt_attack()
	
func roll_dmg(d_size: int = 6):
	return super.roll_dmg(d_size)

func evaluate_attack(roll, dmg, invert = false) -> bool:
	return await super.evaluate_attack(roll, dmg, inverted)
