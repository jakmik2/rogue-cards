class_name EquipmentItem extends RigidBody2D

@onready var sprite = $Sprite2D

var equipment_id = ""


func _ready():
	sprite.texture = load("res://sprites/bases_or_alts/helm-" + Global.ITEM_MATERIAL[equipment_id[1]] + ".png")
