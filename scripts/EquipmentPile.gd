class_name EquipmentPile extends StaticBody2D

@onready var equipment_item_prefab = preload("res://scenes/EquipmentItem.tscn")
@onready var equipment_storage = $EquipmentStorage

@export var pile: Array[String] = []

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.packed_equipment_pile != null:
		var old_equipment_pile = Global.packed_equipment_pile
		for code in old_equipment_pile:
			add_equipment(code)

func add_equipment(code):
	pile.push_front(code)
	# Spawn it in a random position above the container
	var rand_x = rng.randi_range(-20, 20)
	var rand_y = rng.randi_range(-100, -300)
	var rand_rot = rng.randf_range(-PI/2, PI/2)
	
	var equipment_item: EquipmentItem = equipment_item_prefab.instantiate()
	equipment_item.equipment_id = code
	equipment_storage.add_child(equipment_item)
	equipment_item.owner = equipment_storage
	
	equipment_item.rotate(rand_rot)
	
	equipment_item.position = Vector2(rand_x, rand_y)

func _on_tree_exiting():
	Global.packed_equipment_pile = pile
