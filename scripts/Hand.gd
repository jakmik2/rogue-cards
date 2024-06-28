class_name Hand extends Node2D

@onready var cardPrefab = preload("res://scenes/Card.tscn")
@export var fixed_hand_width = 200
@export var hand_size = 5

var arena
var played = false
var hover_idx

var hand: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready():
	arena = get_parent()
	print(global_position)
	
	hand = Global.draw(hand_size)
	for idx in hand.size():
		var card: Card = cardPrefab.instantiate()
		card.code = hand[idx]
		card.idx = idx
		add_child(card)
	
	sort_card_distance()

func sort_card_distance():
	var children = get_children()
	var variable_max_size = fixed_hand_width + 30 * max((5 - children.size()), 0)
	var partition_size = fixed_hand_width / (children.size() + 1)
	for card_idx in children.size():
		var card: Card = children[card_idx]
		card.set_position(Vector2((card_idx + 1) * partition_size - fixed_hand_width / 2, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("ui_down"):
		played = true

func set_hover(idx):
	if hover_idx != idx:
		unset_hover()
	
	hover_idx = idx
	
	var children = get_children()
	
	for c_idx in children.size():
		var card = children[c_idx]
		if c_idx < idx:
			# Shift left
			card.translate(Vector2(-30, 0))
		elif c_idx == idx:
			card.translate(Vector2(0, -5))
		elif c_idx > idx:
			# shift Right
			card.translate(Vector2(30, 0))

func unset_hover():
	sort_card_distance()
	
