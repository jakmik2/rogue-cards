class_name PlayerCharacter extends BaseEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	print("I'm a nasty lil'goblin!")
	return await super.attempt_attack()

func roll_dmg(d_size: int = 12):
	return super.roll_dmg(d_size)
