class_name BaseEntity extends Node

# Properties
@export_group("Properties")
@export var health = 100
@export var armor_class = 0
@export var status: LifeStatus
@export var damage = 10
@export var speed = 5
@export var scene = preload("res://scenes/Loot.tscn")

# Enums
enum LifeStatus {ALIVE, DEAD}

# Util
var rng = RandomNumberGenerator.new()
var damage_number_pool: Array[DamageNumber] = []
var inverted = false

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
		
		# roll d20 to see what drops
		var loot_roll = randi_range(1,20)
		
		# categorize loot_roll into appropriate category
		if loot_roll <= 11:
			loot_roll = 11
		elif loot_roll <= 15:
			loot_roll = 15
		elif loot_roll <= 19:
			loot_roll = 19
		
		# loot determination and notification
		var lootie_tootie = self.loot[loot_roll] + str(self.loot_tier)
		print(lootie_tootie + " loot")
		
		# if nothing drops, nothing should drop
		if lootie_tootie[0] != 'N':
			spawn_loot(lootie_tootie)

func spawn_loot(loot_id):
	var new_loot = scene.instantiate()
	new_loot.loot_code = loot_id
	add_child(new_loot)

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
