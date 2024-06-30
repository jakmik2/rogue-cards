class_name Card extends Area2D

@export var code = "MWC"
@onready var sprite = $Sprite
@onready var animation_player = $AnimationPlayer

var hand: Hand
var idx
var disabled = false
var hovering = false
var selected = false

var card_type
var description
var tier

var rng = RandomNumberGenerator.new()

func _ready():
	hand = get_parent()
	sprite.texture = load("res://sprites/card/" + Global.CARD_TYPE[code[0]] + ".png")

func _input(event):
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

func _on_mouse_exited():
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

var temp_modifier = {
	"health"		: 0,
	"armor_class"	: 0,
	"damage"		: 0,
	"speed"			: 0,
	"crit_chance"	: 0,
	"crit_damage"	: 0,
}

func card_method():
	# Switch on card effects
	print("Temp upgrade to ", Global.CARD_TYPE[code[0]])
	var stat = '';
	match Global.CARD_TYPE[code[0]]:
		"the-magician":
			var rand_i = rng.randi_range(0,1)
			if rand_i == 1:
				stat = 'crit_chance'
			else:
				stat = 'crit_damage'
		"strength":
			stat = 'damage'
		"the-tower":
			stat = 'armor_class'
		"the-hermit":
			stat = 'speed'
		"the-devil":
			# TODO: Implement monster effect
			pass
		"death":
			# TODO: Implement monster effect
			pass
		_:
			pass
	
	if stat != '':
		Global.temp_modifier[stat] += (
			# get base stat increase
			Global.BASE_STAT_INCREASE[stat] * 
			# mult by (tier + rarity + 1) * 1.5
			# 1.5 times more powerful as it's temp
			(Global.mods[code[1]] + Global.mods[code[1]] + 3) * 1.5
		)

	print("Current temp mod after impact: ", Global.temp_modifier)
