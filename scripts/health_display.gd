extends Node2D

# Properties
@export_category("Properties")
@export var scale_modifier = 1

# Nodes
@onready
var parent: BaseEntity = self.get_parent() as BaseEntity
@onready
var label: Label = $Label
@onready
var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	match scale_modifier:
		1:
			sprite.scale *= 0.5
		2:
			sprite.scale *= 1
		3:
			sprite.scale *= 1.5
	
	if parent.inverted:
		print("Inverting!")
		self.scale.x *= -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(parent.health)
