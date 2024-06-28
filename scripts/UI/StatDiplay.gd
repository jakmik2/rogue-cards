extends ColorRect


func _ready():
	update_stats()

func update_stats():
	get_node("GridContainer/CurrentHealth").text = str(Global.stat_lookup["Player"]["health"])
	get_node("GridContainer/CurrentArmorClass").text = str(Global.stat_lookup["Player"]["armor_class"])
	get_node("GridContainer/CurrentDamage").text = str(Global.stat_lookup["Player"]["damage"])
	get_node("GridContainer/CurrentSpeed").text = str(Global.stat_lookup["Player"]["speed"])
	get_node("GridContainer/CurrentCChance").text = str(Global.stat_lookup["Player"]["crit_chance"])
	get_node("GridContainer/CurrentCDamage").text = str(Global.stat_lookup["Player"]["crit_damage"])

func _on_visibility_changed():
	update_stats()
