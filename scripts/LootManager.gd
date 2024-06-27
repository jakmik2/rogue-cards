extends Node

# Define constants for different types of equipment
enum EquipmentCategory { CARD, HELM, TORSO, WEAPON, BOOTS, GLOVES }
enum ItemMaterial { ARCANE, LEATHER, METAL }
enum CardType { MAGIC, ATTACK, DEFENSE, UTILITY, SPAWN }
enum ItemRarity { WORN, FINE, EXCEPTIONAL }
enum ItemTier { COMMON, RARE, MAGIC }

# Define the drop rates for different categories
var loot_drop_rate = 0.7  # 60% chance of dropping equipment/card
var category_drop_rates = {
	# 50/50 for equipment or card
	EquipmentCategory.CARD: 0.75,	# new card
	EquipmentCategory.HELM: 0.05,	# health
	EquipmentCategory.TORSO: 0.05,	# armor_class
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
	CardType.SPAWN: 0.4,
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
	
	# If the category is armor/weapon, determine the material
	var card_type = null
	var material = null
	var loot_code = ""
	
	# Determine the category of equipment
	var category = choose_category()
	loot_code += str(EquipmentCategory.keys()[category])[0]
	
	if category == EquipmentCategory.CARD:
		card_type = choose_card_type()
		loot_code += str(CardType.keys()[card_type])[0]
	else:
		material = choose_material()
		loot_code += str(ItemMaterial.keys()[material])[0]
	
	# Determine the rarity and tier of the item
	var rarity = choose_rarity()
	var tier = choose_tier()
	
	loot_code += str(ItemRarity.keys()[rarity])[0]
	loot_code += str(ItemTier.keys()[tier])[0]
	
	print(loot_code)
	# Construct the loot dictionary
	var loot = {
		"category": category,
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
