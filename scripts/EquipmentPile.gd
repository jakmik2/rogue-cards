class_name EquipmentPile extends StaticBody2D

@onready var equipment_item_prefab = preload("res://scenes/EquipmentItem.tscn")
@onready var equipment_storage = $EquipmentStorage

@export var pile: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.packed_equipment_pile != null:
		var old_equipment_pile = Global.packed_equipment_pile
		for code in old_equipment_pile:
			add_equipment(code)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func add_equipment(code):
	pile.push_front(code)
	var equipment_item: EquipmentItem = equipment_item_prefab.instantiate()
	equipment_item.equipment_id = code
	equipment_storage.add_child(equipment_item)
	equipment_item.owner = equipment_storage


func _on_tree_exiting():
	Global.packed_equipment_pile = pile
