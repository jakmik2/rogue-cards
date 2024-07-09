extends Control

@onready var pause_menu = $UI/PauseMenu
@onready var card_holder : Control = $DeckDisplay/CardHolder


# size determines how many pages
var deck_size
# 1 page = 9 card block
var current_page = 0
var card_selected = 0
var max_pages : int


func _ready():
	# connect signals for pause button and exit button
	pause_menu.get_node("PauseReturn").pressed.connect(_on_close_button_pressed)
	pause_menu.get_node("ExitButton").pressed.connect(_on_exit_button_pressed)
	
	deck_size = len(Global.current_player_deck)
	max_pages = deck_size / 9
	stock_page()

func _input(_event):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = true
		pause_menu.show()

func stock_page() -> void:
	for child in card_holder.get_children():
		child.queue_free()
	
	for i in range(9):
		if i+current_page*9 < len(Global.current_player_deck):
			var card_dupe = Card.new_card(Global.current_player_deck[i+current_page*9])
			card_holder.add_child(card_dupe)
			match i:
				0, 1, 2:
					card_dupe.position = Vector2(96+i*200, 88)
				3, 4, 5:
					card_dupe.position = Vector2(96+(i-3)*200, 256)
				6, 7, 8:
					card_dupe.position = Vector2(96+(i-6)*200, 424)
			print(card_dupe.position)
		else:
			return

func _on_close_button_pressed():
	pause_menu.hide()
	get_tree().paused = false

func _on_exit_button_pressed():
	get_tree().quit()

func _on_overworld_pressed():
	get_tree().change_scene_to_file("res://scenes/Overworld.tscn")

func _on_right_arrow_pressed():
	if current_page < max_pages:
		current_page += 1
		stock_page()
		
func _on_left_arrow_pressed():
	if current_page > 0:
		current_page -= 1
		stock_page()
