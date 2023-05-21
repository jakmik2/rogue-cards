class_name Loot extends Node2D

const TypeTableObj = preload("res://loot_tables/TypeTable.gd")
const QualityTableObj = preload("res://loot_tables/QualityTable.gd")

var loot_code

var loot_type = ""
var loot_tier = ""
var loot_roll = 0

func spawn(tier: int) -> bool:
	print("LOOT!! EHEHEHEHEHEHEHHEHEE!!!!")
	var typeTable: TypeTable = TypeTableObj.new()
	var qualTable: QualityTable = QualityTableObj.new()
	
	# roll d20 to see what drops
	loot_roll = randi_range(1,20)
	
	# Address roll
	var loot_type = typeTable.roll(loot_roll)
	var loot_tier = qualTable.data[tier]
	
	# loot determination and notification
	var lootie_tootie = loot_type.left(1) + loot_tier.right(1)
	loot_code = lootie_tootie
	if loot_type != 'None':
			
		print(lootie_tootie + " loot")
		return true
	else:
		return false


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $Sprite2D.get_rect().has_point(to_local(event.position)):
			print(self.loot_code)

			self.queue_free()
