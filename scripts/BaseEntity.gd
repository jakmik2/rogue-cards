class_name BaseEntity extends Node

# Nodes
@onready var animation_player = $AnimationPlayer
@onready var damage_number_template = preload("res://scenes/UI/DamageDisplay.tscn")

# Properties
var health
var armor_class
var damage
var speed
var crit_chance
var crit_damage

# Status
var status: LifeStatus

# Enums
enum LifeStatus {ALIVE, DEAD}

# Util
var rng = RandomNumberGenerator.new()
var damage_number_pool: Array[DamageNumber] = []
var inverted = false


func _ready():
	animation_player.play('BaseEntityAnims/idle')

func get_stats(entity_name) -> void:
	var entity_stats = Global.stat_lookup[entity_name]
	health = entity_stats["health"]
	armor_class = entity_stats["armor_class"]
	damage = entity_stats["damage"]
	speed = entity_stats["speed"]
	crit_chance = entity_stats["crit_chance"]
	crit_damage = entity_stats["crit_damage"]

func get_speed() -> int:
	return rng.randi_range(-1, 1) + speed

func kill() -> void:
	status = LifeStatus.DEAD
	animation_player.play('BaseEntityAnims/death')

func attempt_attack() -> int:
	# Play Attack Animation
	animation_player.play('BaseEntityAnims/attack')
	await animation_player.animation_finished
	animation_player.play('BaseEntityAnims/idle')
	# Make an Attack roll
	return rng.randi_range(1, damage)

func roll_dmg() -> int:
	return damage if randi_range(0,100) > crit_chance else crit_damage

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
