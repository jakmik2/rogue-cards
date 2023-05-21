extends Node2D

# Properties
@export_category("Properties")
@export var scale_modifier = 1

# Nodes
@onready
var parent: BaseEntity = self.get_parent() as BaseEntity
@onready
var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale *= scale_modifier
	
	if parent.inverted:
		print("Inverting!")
		self.scale = Vector2(-scale_modifier, scale_modifier)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(parent.health)
