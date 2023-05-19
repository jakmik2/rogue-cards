class_name DamageNumber extends Node2D

@onready
var label: Label = get_node("Container/Label")
@onready
var container: Container = get_node("Container")
@onready
var animation_player: AnimationPlayer = $AnimationPlayer

func set_values_and_animate(value: String, start_position: Vector2, height: float, spread: float, invert=false) -> void:
	if (invert):
		self.scale = Vector2(-1, 1)
	
	label.text = value
	animation_player.play('display_damage')
	
	var tween = get_tree().create_tween()
	var end_position = Vector2(randf_range(-spread, spread), -height) + start_position
	var tween_length = animation_player.get_animation('display_damage').length
	
	tween.tween_property(container, "position", end_position, tween_length).from(start_position)

func remove() -> void:
	animation_player.stop()
	if (is_inside_tree()):
		get_parent().remove_child(self)
