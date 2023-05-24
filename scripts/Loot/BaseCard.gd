class_name BaseCard extends BaseLoot

@export var enemy: Resource

func spawn_mobs():
	pass

func get_scene():
	return preload("res://scenes/loot/cards/BaseCard.tscn").instantiate()

func click():
	print("You just clicked a card!")
