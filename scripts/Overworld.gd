extends Control

@onready var tooltip = $UI/TextDisplay
@onready var pause_menu = $UI/PauseMenu


func _ready():
	# connect signals for pause button and exit button
	pause_menu.get_node("PauseReturn").pressed.connect(_on_close_button_pressed)
	pause_menu.get_node("ExitButton").pressed.connect(_on_exit_button_pressed)
	
	# set custom tooltip params for Overworld scene
	tooltip.overworld_setup()
	
	# hide tooltip until hovering over level
	tooltip.hide()

func _input(_event):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = true
		pause_menu.show()

func _on_close_button_pressed():
	pause_menu.hide()
	get_tree().paused = false

func _on_exit_button_pressed():
	get_tree().quit()

func _on_deck_manager_pressed():
	get_tree().change_scene_to_file("res://scenes/DeckManager.tscn")
