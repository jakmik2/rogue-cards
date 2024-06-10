class_name Loot extends Node2D


func spawn() -> bool:
	var loot = LootManager.generate_loot()

	if loot != {}:
		if loot["card_type"]:
			# change to appropriate sprite
			get_child(0).texture = load(
				"res://sprites/drops/" + 
				LootManager.CardType.keys()[loot["card_type"]] + 
				"-drop.png"
			)
		else:
			# must be a weapon
			# must be an armor
			# PASS ADD STATS TODO properly implement
			pass
		
		print("DROP IS:")
		print(loot)
		return true
	else:
		print("NO DROP")
		return false
	

