extends Node2D

# Nodes
@onready
var parent: BaseEntity = self.get_parent() as BaseEntity
@onready
var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	print(parent)
	print(parent.inverted)
	if parent.inverted:
		print("Inverting!")
		self.scale = Vector2(-1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(parent.health)
