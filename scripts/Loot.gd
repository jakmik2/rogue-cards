class_name Loot extends Area2D

@onready var text_template = "res://scenes/UI/"
var arena
var player

var loot = {}


func _ready():
	arena = get_parent().get_parent()
	player = arena.get_node("Player")

func spawn() -> bool:
	loot = LootManager.generate_loot()
	if loot != {}:
		if loot["card_type"]:
			# change to appropriate sprite
			get_child(0).texture = load(
				"res://sprites/drops/" + get_loot_type() + "-drop.png"
			)
		else:
			# must be equipment
			get_child(0).texture = load(
				"res://sprites/drops/" +
				"equipment" + # LootManager.EquipmentCategory.keys()[loot["category"]] +
				"-drop.png"
			)
		return true
	else:
		print("NO DROP")
		return false

func get_loot_type():
	if loot["card_type"]:
		return LootManager.CardType.keys()[loot["card_type"]]
	else:
		#return LootManager.EquipmentCategory.keys()[loot["category"]]
		return "EQUIPMENT"

func _on_mouse_click(_viewport, _event, _shape_idx):
	if (
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and 
		arena.current_phase == arena.Phase.LOOTING
	):
		arena.hide_tooltip()
		if get_parent().get_child_count() == 1:
			arena.current_phase = arena.Phase.FINISHED
			arena.end_looting()
	 	
		print("Loot Type before ingestion: " + get_loot_type())
		
		if get_loot_type() == "EQUIPMENT":
			# Add to player stats
			player.equipment_to_stats(loot)
		else:
			# Add to deck
			var new_card = Card.from_loot(loot)
			player.card_to_deck(new_card)
		
		queue_free()

func _on_mouse_entered():
	# display textbox with information
	if arena.current_phase == arena.Phase.LOOTING:
		arena.tooltip.change_text(Global.LOOT_DESCRIPTIONS[get_loot_type()])
		arena.show_tooltip()

func _on_mouse_exited():
	# hide textbox or destroy it
	if arena.current_phase == arena.Phase.LOOTING:
		arena.hide_tooltip()
