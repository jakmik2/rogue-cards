class_name EnemyEntity extends BaseEntity

@export var loot_tier = randi_range(0,2)	# Loot Tier for skele

@onready 
var lootPrefab = preload("res://scenes/Loot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill():
	super.kill()
	var loot: Loot = lootPrefab.instantiate()
	var loot_status = loot.spawn(loot_tier)
	if (loot_status):
		add_child(loot)
	else:
		loot.queue_free()
