class_name Loot extends Area2D

var arena
var player

@onready var text_template = "res://scenes/UI/"

# 4 letter code (designed for expansion) that determines type of loot
var loot_code

var clicked = false


func _ready():
	arena = get_parent().get_parent()
	player = arena.get_node("Player")

func spawn() -> bool:
	loot_code = LootManager.generate_loot()
	
	# set the sprite if applicable
	set_loot_sprite()
	return true if loot_code != "" else false

func set_loot_sprite():
	if loot_code == "":
		return
	
	var sprite_path = "res://sprites/"
	# determine sprite_path dynamically depending on loot_code
	if loot_code[0] == "C":
		sprite_path += "card/" + Global.CARD_TYPE[loot_code[1]] + ".png"
	else:
		sprite_path += (
			"equipment/" + Global.EQUIPMENT_CATEGORY[loot_code[0]] + \
			"-" + Global.ITEM_MATERIAL[loot_code[1]] + ".png"
		)
	
	# set texture
	get_node("Sprite").texture = load(sprite_path)

func get_loot_type():
	if loot_code[0] == "C":
		return Global.CARD_TYPE[loot_code[1]]
	else:
		return Global.EQUIPMENT_CATEGORY[loot_code[0]]

func _on_mouse_click(_viewport, _event, _shape_idx):
	if (
		Input.is_action_just_pressed("ui_select") and 
		arena.current_phase == arena.Phase.LOOTING and
		not clicked
	):
		clicked = true
		arena.hide_tooltip()
		if loot_code[0] == "C":
			player.add_to_deck(loot_code.right(3))
		else:
			player.equipment_to_stats(loot_code)
		
		if get_parent().get_child_count() == 2:
			arena.current_phase = arena.Phase.FINISHED
			arena.end_looting()
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
