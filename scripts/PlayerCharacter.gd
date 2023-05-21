class_name PlayerCharacter extends BaseEntity

# Used to determine if the player character is affected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attempt_attack() -> int:
	print("YEEHEEHEE I'M A NASTY LIL'GOBLIN!")
	return await super.attempt_attack()

func roll_dmg(d_size: int = 12):
	return super.roll_dmg(d_size)
