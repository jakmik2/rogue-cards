class_name Hand extends Node2D

@onready var cardPrefab = preload("res://scenes/Card.tscn")
@export var fixed_hand_width = 200
@export var hand_size = 5

var arena
var camera: ArenaCamera

var deactivate

var children

var hand: Array[String]

var variable_max_size
var partition_size

# Called when the node enters the scene tree for the first time.
func _ready():
	arena = get_parent()
	camera = arena.get_node("ArenaCamera")
	camera.center_hand()
	hand = Global.draw(hand_size)
	draw_hand()
	
	# empty hand, start battle
	if hand.size() == 0:
		finish_hand()

func _input(event):
	if arena.current_phase == Arena.Phase.PREP:
		# skip card playing
		if Input.is_action_just_pressed("ui_down"):
			finish_hand()
		# numbered inputs for card draw
		elif Input.is_action_just_pressed("card_1") and hand.size() >= 1:
			play_card(0, true)
		elif Input.is_action_just_pressed("card_2") and hand.size() >= 2:
			play_card(1, true)
		elif Input.is_action_just_pressed("card_3") and hand.size() >= 3:
			play_card(2, true)
		elif Input.is_action_just_pressed("card_4") and hand.size() >= 4:
			play_card(3, true)
		elif Input.is_action_just_pressed("card_5") and hand.size() >= 5:
			play_card(4, true)

func draw_hand():
	for idx in hand.size():
		var card := Card.new_card(hand[idx])
		card.idx = idx
		add_child(card)
	
	children = get_children()
	
	variable_max_size = fixed_hand_width + 30 * max((5 - children.size()), 0)
	partition_size = variable_max_size / (children.size() + 1)
	
	var new_positions = sort_card_distance()
	
	for c_idx in children.size():
		children[c_idx].set_position(new_positions[c_idx])

func sort_card_distance() -> Array[Vector2]:
	var outlist: Array[Vector2] = []
	
	for card_idx in children.size():
		outlist.push_front(Vector2((card_idx + 1) * partition_size - variable_max_size / 2, 0))
	return outlist

func play_card(idx, manual=false):
	var played_card = get_child(idx)
	# TODO: Move if able to play more than one card
	for card in children:
		card.disabled = true
	if manual:
		played_card = get_child(get_child_count() - (idx + 1))
	played_card.card_method()
	played_card.animation_player.play("card_exit")
	
	await played_card.animation_player.animation_finished
	played_card.queue_free()
	await played_card.tree_exited
	
	reactivate()
	
	# remove card from hand
	hand.pop_at(idx)
	deactivate = true
	
func reactivate():
	await get_tree().process_frame

	children = get_children()
	# Reset idx
	for c_idx in children.size():
		children[c_idx].idx = c_idx
		
	variable_max_size = fixed_hand_width + 30 * max((5 - children.size()), 0)
	partition_size = variable_max_size / (children.size() + 1)
	
	deactivate = false
	hover(-1)
	
	finish_hand()

func hover(new_idx):
	if deactivate:
		return
	# Get base positions
	var all_pos = sort_card_distance()
	
	if new_idx >= 0 && new_idx < hand.size():
		for c_idx in children.size():
			var card = children[c_idx]
			if c_idx > new_idx:
				# Shift left
				all_pos[c_idx] += Vector2(-13 * children.size(), 0)
			elif c_idx == new_idx:
				# Shift hovered card up slightly
				all_pos[c_idx] += Vector2(0, -5)
			else:
				# shift Right
				all_pos[c_idx] += Vector2(13 * children.size(), 0)
			card.hovering = c_idx == new_idx
	else:
		for card in children:
			card.hovering = false

	for idx in all_pos.size():
		var card = children[idx]
		if card.get_position() != all_pos[idx]:
			children[idx].set_position(all_pos[idx])

	# Finish frame before new hovers
	await get_tree().process_frame

func finish_hand():
	for card in children:
		card.disabled = true
	
	# bring camera center and start combat phase
	camera.center_arena()
	arena.end_prep()
	
	# Return what remains in hand to deck
	Global.return_to_deck(hand)
