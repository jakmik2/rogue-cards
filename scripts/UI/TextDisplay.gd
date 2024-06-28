extends Control

enum mods { A, B, C }

@onready var backing = $Backing
@onready var textbox = $TextBox


func _ready():
	change_text("")

func _process(_delta):
	var mpos = get_global_mouse_position()
	position = mpos + Vector2(16,16)
	
	if mpos.x > get_viewport_rect().size.x / 2:
		position.x -= backing.size.x + 32
	# for lower positions
	#if mpos.y > get_viewport_rect().size.y /2:
		#position.y -= backing.size.y - 32

func change_text(new_text):
	textbox.fit_content = true
	backing.size = textbox.size + Vector2(16,16)
	await get_tree().process_frame
	textbox.text = new_text

func display_loot(code):
	# display WORN MAGIC ARCANE WEAPON for equipment
	# display FINE RARE DEATH for card
	textbox.text = (
		"[color="+ Global.TIER_COLORS[mods[code[2]]] +"]" + 
		Global.ITEM_RARITY[code[2]].capitalize() + "[/color] " + 
		"[color="+ Global.TIER_COLORS[mods[code[3]]] +"]" + 
		Global.ITEM_TIER[code[3]].capitalize() + "[/color] "
	)
	
	# check if card, else is equipment
	if code[0] == "A":
		textbox.text += Global.CARD_TYPE[code[1]].replace("-", " ").capitalize() + " "
	else:
		textbox.text += Global.ITEM_MATERIAL[code[1]].capitalize() + " "
	
	textbox.text += Global.EQUIPMENT_CATEGORY[code[0]].capitalize()
	
	textbox.fit_content = false
	textbox.fit_content = true
