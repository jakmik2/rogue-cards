extends Node

# Define constants for different types of equipment
enum EquipmentCategory { A,B,C,D,E,F }
enum ItemMaterial { A,B,C }
enum CardType { A,B,C,D,E,F }
enum ItemRarity { A,B,C,D }
enum ItemTier { A,B,C,D }

# Define the drop rates for different categories
var loot_drop_rate = 0.85  # 85% chance of dropping equipment/card
var category_drop_rates = {
	# 50/50 for equipment or card
	EquipmentCategory.A: 0.9,	# new card
	EquipmentCategory.B: 0.1,	# helm
	EquipmentCategory.C: 0.0,	# torso
	EquipmentCategory.D: 0.0,	# weapon
	EquipmentCategory.E: 0.0,	# gloves
	EquipmentCategory.F: 0.0,	# boots
}

# Define the drop rates for different materials
var material_drop_rates = {
	ItemMaterial.A: 0.33,
	ItemMaterial.B: 0.33,
	ItemMaterial.C: 0.34,
}

# Define the drop rates for different card types
var card_type_drop_rates = {
	CardType.A: 0.15,
	CardType.B: 0.15,
	CardType.C: 0.15,
	CardType.D: 0.15,
	CardType.E: 0.35,
	CardType.F: 0.05,
}

# Define the drop rates for item rarity
var rarity_drop_rates = {
	ItemRarity.A: 0.75,
	ItemRarity.B: 0.20,
	ItemRarity.C: 0.045,
	ItemRarity.D: 0.005,
}

# Define the drop rates for item tier
var tier_drop_rates = {
	ItemTier.A: 0.6,
	ItemTier.B: 0.3,
	ItemTier.C: 0.09,
	ItemTier.D: 0.01
}

# Main function to generate loot
func generate_loot() -> String:
	if randf() > loot_drop_rate:
		return ""  # No loot dropped
	
	# Determine the category of equipment
	var loot_code = str(EquipmentCategory.keys()[choose_category()])
	
	# pick card_type if card or material if equipment
	if loot_code[0] == "A":
		loot_code += str(CardType.keys()[choose_card_type()])
	else:
		loot_code += str(ItemMaterial.keys()[choose_material()])
	
	# Determine the rarity and tier of the item
	loot_code += str(ItemRarity.keys()[choose_rarity()])
	loot_code += str(ItemTier.keys()[choose_tier()])

	return loot_code

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
