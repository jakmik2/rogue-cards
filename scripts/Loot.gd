extends Node2D


var loot_code


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $Sprite2D.get_rect().has_point(to_local(event.position)):
			print(self.loot_code)

			self.queue_free()
