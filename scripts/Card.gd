class_name Card extends Area2D

@export var code = "MWC"
@onready var sprite = $Sprite

var hand: Hand
var idx

var do_not_eval = false
var hovering = false

var card_type
var description
var tier

func _ready():
	hand = get_parent()
	sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[code[0]] + ".png")

func _on_mouse_entered():
	if !hovering && !do_not_eval:
		hovering = true
		hand.hover(idx)

func _on_mouse_exited():
	hovering = false
	var dif = get_global_mouse_position() - global_position
	if dif.x > 50 && dif.y < 60 && dif.y > -60:
		hand.hover(idx - 1)
	elif dif.x < -50 && dif.y < 60 && dif.y > -60:
		hand.hover(idx + 1)
	else:
		hand.hover(-1)
