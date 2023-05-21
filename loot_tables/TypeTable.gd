class_name TypeTable

func roll(loot_roll: int) -> String:
	# Roll on Type
	if range(1, 11).has(loot_roll):
		return "None"
	elif range(12, 15).has(loot_roll):
		return "Weapon"
	elif range(16, 19).has(loot_roll):
		return "Armor"
	else:
		return "Card"
