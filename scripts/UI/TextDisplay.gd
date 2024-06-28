extends Control

@onready var backing : ColorRect = $Backing
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

func fit():
	# fit to the content
	await get_tree().process_frame
	textbox.fit_content = true
	backing.size = textbox.size 
	

func change_text(new_text):
	textbox.text = new_text
	fit()

func display_loot(code):
	# display WORN MAGIC ARCANE WEAPON for equipment
	# display FINE RARE DEATH for card
	textbox.text = (
		"[color="+ Global.TIER_COLORS[Global.mods[code[2]]] +"]" + 
		Global.ITEM_RARITY[code[2]].capitalize() + "[/color] " + 
		"[color="+ Global.TIER_COLORS[Global.mods[code[3]]] +"]" + 
		Global.ITEM_TIER[code[3]].capitalize() + "[/color] \n"
	)
	
	# check if card, else is equipment
	if code[0] == "A":
		textbox.text += Global.CARD_TYPE[code[1]].replace("-", " ").capitalize() + " "
	else:
		textbox.text += Global.ITEM_MATERIAL[code[1]].capitalize() + " "
	
	textbox.text += Global.EQUIPMENT_CATEGORY[code[0]].capitalize()
	
	fit()

func overworld_setup():
	textbox.size.x = 200
