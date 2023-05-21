extends BaseEntity

# Called when the node enters the scene tree for the first time.
func _init():
# Override inverted for enemy -> This is bad and we shouldn't be doing this
	inverted = true

func attempt_attack():
	print("I Hate Goblins!")
	return await super.attempt_attack()
	
func roll_dmg(d_size: int = 6):
	return super.roll_dmg(d_size)

func evaluate_attack(roll, dmg, invert = false) -> bool:
	return await super.evaluate_attack(roll, dmg, inverted)
