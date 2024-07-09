class_name Card extends Control

@onready var sprite = $Sprite
@onready var outline = $Outline

# depends on parent location
var text_box

var timer = Timer.new()

var card_code
var card_type
var card_name
var description
var rarity
var tier

var pressed = false
var pressed_offset = 0.5


func _ready():
	# if card is in the DeckManager scene
	if get_parent().name == "CardHolder":
		text_box = get_node("/root/DeckManager/Description/Textbox")
	
	# add pressed timer to tree
	timer.wait_time = 0.1
	add_child(timer)
	if card_code:
		sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[card_code[0]] + ".png")
		
		description = Global.LOOT_DESCRIPTIONS[Global.CARD_TYPE[card_code[0]]]
		rarity = Global.ITEM_RARITY[card_code[1]]
		tier = Global.ITEM_TIER[card_code[2]]
		card_name = (
			card_type.replace("-", " ").capitalize() + " Card\n" + 
			
			"[color=" + Global.TIER_COLORS[Global.mods[card_code[1]]] +"]" +
			rarity.capitalize() + "[/color]\n" +
			 
			"[color=" + Global.TIER_COLORS[Global.mods[card_code[2]]] +"]" +
			tier.capitalize()  + "[/color]\n"
		)

static func new_card(code: String) -> Card:
	# load card template and instantiate it
	var card_template : PackedScene = load("res://scenes/Card.tscn")
	var created_card: Card = card_template.instantiate()
	created_card.card_code = code
	created_card.card_type = Global.CARD_TYPE[code[0]]
	return created_card

func _on_gui_input(event):
	if Input.is_action_just_pressed("ui_select") and !pressed:
		# fake press and release
		pressed = true
		position.y += pressed_offset
		timer.start()
		# set description
		text_box.text = description + "\n\n\n\n\n\n\n\n\n" + card_name
		await timer.timeout
		position.y -= pressed_offset
		pressed = false

func _on_hover_enter():
	outline.show()

func _on_hover_exit():
	outline.hide()
