class_name Card extends Area2D

@export var code = "MWC"
@onready var sprite = $Sprite
@onready var animation_player = $AnimationPlayer

var hand: Hand
var idx

var hovering = false
var selected = false

var card_type
var description
var tier

func _ready():
	hand = get_parent()
	sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[code[0]] + ".png")

func _input(event):
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
	if !hovering:
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

func card_method():
	# TODO: Implement card use
	print("I've used this card!")
