class_name EquipmentItem extends RigidBody2D

@onready var sprite = $Sprite2D

@export var equipment_id = "ECBC"

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = load("res://sprites/bases_or_alts/helm-" + Global.ITEM_MATERIAL[equipment_id[1]] + ".png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
