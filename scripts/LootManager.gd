class_name LootManager extends Node

const TypeTableObj = preload("res://loot_tables/TypeTable.gd")
const QualityTableObj = preload("res://loot_tables/QualityTable.gd")

const BaseLootScene = preload("res://scenes/loot/Loot.tscn")
const BaseEquipmentScene = preload("res://scenes/loot/Equipment/BaseEquipment.tscn")
const CardScript = preload("res://scenes/loot/cards/BaseCard.tscn")

var typeTable: TypeTable = null
var qualTable: QualityTable = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Init Tables
	typeTable = TypeTableObj.new()
	qualTable = QualityTableObj.new()

func spawn_loot(tier):
	# Perform loot roll
	var loot_roll = randi_range(1,20)
	
	# Address roll on tables 
	var loot_type = typeTable.roll(loot_roll)
	var loot_tier = qualTable.data[tier]
	
	# Perform drop
	match loot_type:
		"Equipment":
			var loot: BaseEquipment = BaseEquipmentScene.instantiate()
			print("Equipment!")
			loot.init(loot_type, loot_tier, loot_roll)
			return loot
		"Card":
			var loot: BaseEquipment = BaseEquipmentScene.instantiate()
			print("Card!")
			loot.init(loot_type, loot_tier, loot_roll)
			return loot
		_:
			print("Unlucky")
			return null
	
