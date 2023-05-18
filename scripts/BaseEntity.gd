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

func _ready():
	pass

func _process(_delta):
	pass

func get_speed() -> int:
	return rng.randi_range(1, 20) + speed

func kill() -> void:
	status = LifeStatus.DEAD

func attempt_attack() -> int:
	# Make an Attack roll
	return rng.randi_range(1, 20)

func roll_dmg(d_size: int = 1) -> int:
	return rng.randi_range(1, d_size) + damage

func evaluate_attack(roll, dmg) -> bool:
	# Evaluate Attack roll
	# If Roll is greater than `armor_class` apply `dmg` to `health`
	if (roll > armor_class):
		health -= dmg
		return true
	else:
		return false
