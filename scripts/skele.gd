extends BaseEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attempt_attack():
	print("I Hate Goblins!")
	return await super.attempt_attack()
	
func roll_dmg(d_size: int = 8):
	return super.roll_dmg(d_size)

func evaluate_attack(roll, dmg, invert = false) -> bool:
	return await super.evaluate_attack(roll, dmg, true)
