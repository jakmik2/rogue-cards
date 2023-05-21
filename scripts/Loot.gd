class_name Loot extends Node2D

const TypeTableObj = preload("res://loot_tables/TypeTable.gd")
const QualityTableObj = preload("res://loot_tables/QualityTable.gd")

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
	if loot_type != 'None':
		var lootie_tootie = loot_type.left(1) + loot_tier.right(1)
			
		print(lootie_tootie + " loot")
		return true
	else:
		return false

