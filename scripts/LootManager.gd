extends Node

# Define constants for different types of equipment
enum EquipmentCategory { CARD, HELM, CHEST, WEAPON, BOOTS, GLOVES }
enum ItemMaterial { ARCANE = 2, LEATHER = 1, METAL = 3 }
enum CardType { MAGIC, ATTACK, DEFENSE, UTILITY, MONSTER }
enum ItemRarity { WORN = 1, FINE = 2, EXCEPTIONAL = 3 }
enum ItemTier { COMMON = 1, RARE = 2, MAGIC = 3 }

# Define the drop rates for different categories
var loot_drop_rate = 0.7  # 60% chance of dropping equipment/card
var category_drop_rates = {
	# 50/50 for equipment or card
	EquipmentCategory.CARD: 0.75,	# new card
	EquipmentCategory.HELM: 0.05,	# health
	EquipmentCategory.CHEST: 0.05,	# armor_class
	EquipmentCategory.WEAPON: 0.05,	# damage
	EquipmentCategory.BOOTS: 0.05,	# speed
	EquipmentCategory.GLOVES: 0.05,	# crit chance or dmg
}

# Define the drop rates for different materials
var material_drop_rates = {
	ItemMaterial.ARCANE: 0.33,
	ItemMaterial.LEATHER: 0.33,
	ItemMaterial.METAL: 0.34
}

# Define the drop rates for different card types
var card_type_drop_rates = {
	CardType.MAGIC: 0.15,
	CardType.ATTACK: 0.15,
	CardType.DEFENSE: 0.15,
	CardType.UTILITY: 0.15,
	CardType.MONSTER: 0.4,
}

# Define the drop rates for item rarity
var rarity_drop_rates = {
	ItemRarity.WORN: 0.5,
	ItemRarity.FINE: 0.35,
	ItemRarity.EXCEPTIONAL: 0.15
}

# Define the drop rates for item tier
var tier_drop_rates = {
	ItemTier.COMMON: 0.6,
	ItemTier.RARE: 0.3,
	ItemTier.MAGIC: 0.1
}

# Main function to generate loot
func generate_loot() -> Dictionary:
	if randf() > loot_drop_rate:
		return {}  # No loot dropped
	
	# Determine the category of equipment
	var category = choose_category()
	
	# If the category is armor/weapon, determine the material
	var card_type = null
	var material = null
	
	# Construct the loot dictionary
	print("spawning: " + EquipmentCategory.find_key(category))
	if category == EquipmentCategory.CARD:
		print("Setting Card")
		card_type = choose_card_type()
	else:
		print("Setting Material")
		material = choose_material()
	
	# Determine the rarity and tier of the item
	var rarity = choose_rarity()
	var tier = choose_tier()
	
	
	var loot = {
		"category": EquipmentCategory.find_key(category),
		"material": material,
		"card_type": card_type,
		"rarity": rarity,
		"tier": tier,
	}
	
	return loot

# Helper function to choose an equipment category based on predefined drop rates
func choose_category() -> int:
	return weighted_random(category_drop_rates)

# Helper function to choose an armor material based on predefined drop rates
func choose_material() -> int:
	return weighted_random(material_drop_rates)
	
# Helper function to choose an armor material based on predefined drop rates
func choose_card_type() -> int:
	return weighted_random(card_type_drop_rates)

# Helper function to choose item rarity based on predefined drop rates
func choose_rarity() -> int:
	return weighted_random(rarity_drop_rates)

# Helper function to choose item tier based on predefined drop rates
func choose_tier() -> int:
	return weighted_random(tier_drop_rates)

# Utility function to select an item from a dictionary of weights using a weighted random choice
func weighted_random(weights: Dictionary) -> int:
	var total_weight = 0
	for weight in weights.values():
		total_weight += weight
	
	var random_value = randf() * total_weight
	for key in weights.keys():
		random_value -= weights[key]
		if random_value <= 0:
			return key
	
	# Fallback in case of rounding errors
	return weights.keys().back()

static func get_stat(category: String) -> String:
	match category:
		"HELM": 
			return "health"
		"CHEST":
			return "armor_class"
		"WEAPON":
			return "damage"
		"BOOTS":
			return "speed"
		"GLOVES":
			return "crit_chance"
		_:
			return "Ooop"

static func calc_value(equipment: Dictionary) -> int:
	return equipment['material'] * equipment['rarity'] * equipment['tier']
