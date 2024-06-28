extends Button


@export var enemies : Array[String] = ["Skele1", "Skele1", "Skele1"]
@export var prereqs : Array[Button]

@onready var tooltip = get_owner().get_node("UI/TextDisplay")

var description = ""
var difficulty = 0
var clickable = false
var completed = false


func _ready():
	for enemy in enemies:
		if enemy == "None0":
			continue
		else:
			difficulty += enemy.right(1).to_int() + 1
			description += enemy + " "
	text = str(difficulty)

func _on_mouse_entered():
	if !clickable:
		tooltip.change_text(description)
		tooltip.show()

func _on_mouse_exited():
	tooltip.hide()

func _on_pressed():
	# select level, transfer level data to Global.current_arena_loadout then load arena scene
	Global.current_arena_loadout = enemies
	get_tree().change_scene_to_file("res://scenes/Arena.tscn")
