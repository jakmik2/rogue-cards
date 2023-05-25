class_name TypeTable

func roll(loot_roll: int) -> String:
	# Roll on Type
	if range(1, 8).has(loot_roll):
		return "None"
	elif range(9, 15).has(loot_roll):
		return "Equipment"
	else:
		return "Card"
