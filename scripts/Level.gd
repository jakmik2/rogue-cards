extends Button


@export var enemies : Array[String] = ["Skele1", "Skele1", "Skele1"]
@export var prereqs : Array[String]
@export var overworld_level : int

@onready var tooltip = get_owner().get_node("UI/TextDisplay")

var description = ""
var difficulty = 0
var clickable = false


func _ready():
	# create a description of enemies
	for enemy in enemies:
		difficulty += enemy.right(1).to_int() + 1
		description += (
			enemy.left(5) + " Tier " + str(enemy.right(1).to_int() + 1) + "\n"
		)
	
	text = str(difficulty)
	
	# if x value of level == this level node, evaluate if prereqs are satisfied if applicable
	if (
		overworld_level == Global.current_overworld_level and 
		(Global.current_level_name in prereqs or 
		(Global.current_level_name == "" and overworld_level == 0))
	):
		clickable = true
	elif overworld_level < Global.current_overworld_level:
		# if player has completed level
		self_modulate = "777777"
	else:
		# if level is locked
		self_modulate = "111111"

func _on_mouse_entered():
	if clickable:
		tooltip.change_text(description)
	else:
		tooltip.change_text("Level\nLocked")
	tooltip.fit()
	tooltip.show()

func _on_mouse_exited():
	tooltip.hide()

func _on_pressed():
	if clickable:
		# select level, transfer level data to Global.current_arena_loadout then load arena scene
		Global.current_level_name = name
		Global.current_arena_loadout = enemies
		get_tree().change_scene_to_file("res://scenes/Arena.tscn")
