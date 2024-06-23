extends Node2D

@onready var sprite = $Sprite

var card_type
var description
var tier


func _init(code):
	parse_loot(code)

func parse_loot(loot):
	card_type = loot["card_type"]
	description = Global.TAROT_CARDS[card_type]
	tier = loot["tier"]
