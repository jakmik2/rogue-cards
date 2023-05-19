extends BaseEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite2D").flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attempt_attack():
	print("I Hate Goblins!")
	return super.attempt_attack()
	
func roll_dmg(d_size: int = 8):
	return super.roll_dmg(d_size)
