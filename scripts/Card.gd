class_name Card extends Node2D

@onready var sprite = $Sprite

var card_type
var description
var tier

static func from_loot(loot: Dictionary) -> Card:
	var card = Card.new()
	card.card_type = loot["card_type"]
	card.description = Global.TAROT_CARDS[card.card_type]
	card.tier = loot["tier"]
	return card
