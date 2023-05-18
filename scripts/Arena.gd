class_name Arena extends Node

# Get Actors in the Arena
@onready
var enemies = $Enemies.get_children() as Array[BaseEntity]

@onready
var player_character: PlayerCharacter = $PlayerCharacter

### Arena Steps
# (1) Combat order is rolled per actor based on speed at the beginning of combat
# (2) Attacks are made in order (Greatest to lowest) Always Player to An Enemy or An Enemy to Player
# (3) Repeat! (2 Seconds per round to slow down pace

# Enums
enum CombatState {ACTIVE, INACTIVE}

# Properties
var combat_order = []
var current_state = CombatState.ACTIVE
var current_turn = 0

# Utils
var rng = RandomNumberGenerator.new()

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Evaluate Combat State and turn order
	# Skip if not in Combat
	if (current_state == CombatState.INACTIVE):
		pass
	# Begin Combat
	elif (current_state == CombatState.ACTIVE && combat_order.is_empty()):
		# Populate Combat order (Probably a memory nightmare right here)
		combat_order = enemies.duplicate()
		combat_order.push_back(player_character)
		
		# Sort Combat Order
		combat_order.sort_custom(func(a: BaseEntity, b: BaseEntity): return a.get_speed() > b.get_speed())
	# Perform turn
	elif (current_state == CombatState.ACTIVE && !combat_order.is_empty()):
		var current_actor: BaseEntity = combat_order[current_turn]
		
		var source: BaseEntity = current_actor
		var target: BaseEntity = player_character

		# Assign Source and Target for attack
		var enemy_idx = rng.randi_range(0, enemies.size() - 1)
		if (current_actor == player_character):
			source = player_character
			target = enemies[enemy_idx]
			
		# Evaluate attack
		var attack_roll = source.attempt_attack()
		var damage = source.roll_dmg()
		if (target.evaluate_attack(attack_roll, damage)):
			print("Whamo Bamo! %s successfully struck %s for %s, reducing %s to %s" % [source, target, damage, target, target.health])
			if (target.health <= 0 && target == player_character):
				print("Game Over! You lose!")
				current_state = CombatState.INACTIVE
			elif (target.health <= 0 && source == player_character):
				print("Got One!")
				# Remove Enemy from list
				enemies.pop_at(enemy_idx)
				combat_order.pop_at(combat_order.find(target))
			
			# Check if all combatants have been defeated
			if (enemies.is_empty()):
				print("Congrats! You've won!")
				current_state = CombatState.INACTIVE
		else:
			print("Big miss from %s" % source)
		# Move To Next 
		current_turn = (current_turn + 1) % combat_order.size()
		
	await(get_tree().create_timer(1.0).timeout)