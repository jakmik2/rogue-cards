class_name ArenaCamera extends Camera2D

var animation_player

func _ready():
	print("ready")
	animation_player = $AnimationPlayer

func center_arena():
	animation_player.play("center_arena")
	await animation_player.animation_finished

func center_hand():
	animation_player.play("center_hand")
	await animation_player.animation_finished
