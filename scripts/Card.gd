class_name Card extends Control

@onready var sprite = $Sprite
@onready var outline = $Outline

var timer = Timer.new()

var card_code
var card_type
var description
var rarity
var tier

var pressed = false
var pressed_offset = 0.5


func _ready():
	# add pressed timer to tree
	timer.wait_time = 0.1
	add_child(timer)
	if card_code:
		sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[card_code[0]] + ".png")
	
		description = Global.LOOT_DESCRIPTIONS[Global.CARD_TYPE[card_code[0]]]
		rarity = Global.ITEM_RARITY[card_code[1]]
		tier = Global.ITEM_TIER[card_code[2]]
	

static func new_card(code: String) -> Card:
	# load card template and instantiate it
	var card_template : PackedScene = load("res://scenes/Card.tscn")
	var new_card: Card = card_template.instantiate()
	new_card.card_code = code
	new_card.card_type = Global.CARD_TYPE[code[0]]
	return new_card

func _on_gui_input(event):
	if Input.is_action_just_pressed("ui_select") and !pressed:
		pressed = true
		position.y += pressed_offset
		timer.start()
		await timer.timeout
		position.y -= pressed_offset
		pressed = false

func _on_hover_enter():
	print(description)
	outline.show()

func _on_hover_exit():
	outline.hide()
