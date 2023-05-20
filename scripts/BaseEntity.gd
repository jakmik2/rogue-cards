class_name BaseEntity extends Node

# Properties
@export_group("Properties")
@export var health = 100
@export var armor_class = 10
@export var status: LifeStatus
@export var damage = 10
@export var speed = 5

# Enums
enum LifeStatus {ALIVE, DEAD}

# Util
var rng = RandomNumberGenerator.new()
var damage_number_pool: Array[DamageNumber] = []

# Nodes
@onready
var animation_player = $AnimationPlayer as AnimationPlayer
@onready
var damage_number_template = preload("res://scenes/DamageDisplay.tscn")

func _ready():
	animation_player.play('BaseEntityAnims/idle')

func get_speed() -> int:
	return rng.randi_range(1, 20) + speed

func kill() -> void:
	status = LifeStatus.DEAD
	animation_player.play('BaseEntityAnims/death')
	if !self.is_player:
		print("LOOT!! EHEHEHEHEHEHEHHEHEE!!!!")

func attempt_attack() -> int:
	# Play Attack Animation
	animation_player.play('BaseEntityAnims/attack')
	await animation_player.animation_finished
	animation_player.play('BaseEntityAnims/idle')
	# Make an Attack roll
	return rng.randi_range(1, 20)

func roll_dmg(d_size: int = 1) -> int:
	return rng.randi_range(1, d_size) + damage

func evaluate_attack(roll, dmg, invert = false) -> bool:
	# Evaluate Attack roll
	# If Roll is greater than `armor_class` apply `dmg` to `health`
	if (roll > armor_class):
		spawn_damage_number(dmg, invert)
		animation_player.play('BaseEntityAnims/hit')
		health -= dmg
		await animation_player.animation_finished
		animation_player.play('BaseEntityAnims/idle')
		return true
	else:
		return false

func spawn_damage_number(value: float, invert=false) -> void:
	var damage_number = get_damage_number()
	var val = str(round(value))
	var pos = ($SpawnPoint as Node2D).position
	add_child(damage_number, true)
	damage_number.set_values_and_animate(val, pos, 2.0, 2.0, invert)

func get_damage_number() -> DamageNumber:
	# Get a damage number from the pool
	if (damage_number_pool.size() > 0):
		return damage_number_pool.pop_front()
		
	# Create a new damage number if the pool is empty
	else:
		var new_damage_number = damage_number_template.instantiate()
		new_damage_number.tree_exiting.connect(
			func():damage_number_pool.append(new_damage_number))
		return new_damage_number
