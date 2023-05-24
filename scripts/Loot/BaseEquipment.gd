class_name BaseEquipment extends BaseLoot

func get_scene():
	return preload("res://scenes/loot/Equipment/BaseEquipment.tscn").instantiate()

func click():
	print("You just clicked an equipment!")
