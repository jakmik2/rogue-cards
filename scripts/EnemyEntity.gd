class_name EnemyEntity extends BaseEntity

@export var loot_tier = randi_range(0,2)	# Loot Tier for skele

@onready
var lootManager: LootManager = get_parent() as LootManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill():
	super.kill()
	var loot = lootManager.spawn_loot(loot_tier)
	if (loot != null):
		add_child(loot)
		print("Spawned " + loot.loot_tag)
