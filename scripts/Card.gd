class_name Card extends Area2D

@export var code = "MWC"
@onready var sprite = $Sprite
@onready var outline = $Outline
@onready var animation_player = $Animator

var hand: Hand
var idx
var disabled = false
var hovering = false
var selected = false

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
var pressed_offset = 8


func _ready():
	# if card is in the DeckManager scene
	if get_parent().name == "CardHolder":
		text_box = get_node("/root/DeckManager/Description/Textbox")
  else:
    hand = get_parent()
	
	# add pressed timer to tree
	timer.wait_time = 0.1
	add_child(timer)
  
  # set texture
  sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[card_code[0]] + ".png")
  
  # set card attributes and name
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

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("ui_select") and !pressed:
		# fake press and release
		pressed = true
		position.y += pressed_offset
		timer.start()
		
		# set description
		text_box.text = description
		if card_type == "death":
			text_box.text += "\n\n\n\n\n\n\n\n"
		else:
			text_box.text += "\n\n\n\n\n\n\n\n\n"
		text_box.text += card_name
		
		await timer.timeout
		position.y -= pressed_offset
		pressed = false
   
  if disabled:
    return

	if hovering and Input.is_action_just_pressed("click") && !selected:
		selected = true
		hand.play_card(idx)
		card_method()
		animation_player.play("card_exit")
		await animation_player.animation_finished
		queue_free()
		await tree_exited
		hand.reactivate()

func _on_mouse_entered():
  if !hovering && !disabled:
    hovering = true
    hand.hover(idx)
	outline.show()

func _on_mouse_exited():
	outline.hide()
  if disabled:
		return
	hovering = false
	var dif = get_global_mouse_position() - global_position
	if dif.x > 50 && dif.y < 60 && dif.y > -60:
		hand.hover(idx - 1)
	elif dif.x < -50 && dif.y < 60 && dif.y > -60:
		hand.hover(idx + 1)
	else:
		hand.hover(-1)

func card_method():
	# TODO: Implement card use
	print("I've used this card!")
