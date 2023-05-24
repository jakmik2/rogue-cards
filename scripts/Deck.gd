class_name Deck extends Node2D

# Main Properties
@onready
var enemies = get_node('/root/Main/Enemies')

@onready
var discard: Array[BaseCard] = []

var cards: Array[BaseCard]

@onready
var can_draw = true

var mobs: Array

# Spawn Positions
@onready var root = Vector2(708, 288)
@onready var spawn_position = [root, root+Vector2(125, 100), root+Vector2(-125, 100)]

# Temp Vars
@onready
var card_temp = preload('res://scenes/loot/cards/BaseCard.tscn')

func _ready():
	var card = card_temp.instantiate()
	cards = [card]

func push_card(card: BaseCard):
	print("Pushing " + card.card_name + " successfully")
	cards.push_back(card)

func draw():
	if can_draw:
		print("Drawing from deck")
		var card_drawn: BaseCard = cards.pop_front()
		mobs = card_drawn.spawn_mobs()
		# Add spawn functionality here
		discard.push_front(card_drawn)
		# Revert to cannot draw until end of round
		can_draw = false

func reshuffle():
	randomize()
	cards.append_array(discard)
	cards.shuffle()
	discard = []

func click():
	print("Clicked Deck")
	draw()
	
func spawn_mobs():
	print(enemies.global_position)
	for mob_idx in range(mobs.size()):
		enemies.add_child(mobs[mob_idx])
		mobs[mob_idx].global_position = spawn_position[mob_idx]
