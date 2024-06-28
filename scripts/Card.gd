class_name Card extends Area2D

@export var code = "MWC"
@onready var sprite = $Sprite

var hand
var idx

var hoverable = true

var card_type
var description
var tier

func _ready():
	hand = get_parent()
	sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[code[0]] + ".png")

func _on_mouse_entered():
	print("hovering over ", idx)
	if hoverable:
		hand.set_hover(idx)
		hoverable = false


func _on_mouse_exited():
	print("Exiting ", idx)
	hand.unset_hover()
	hoverable = true
