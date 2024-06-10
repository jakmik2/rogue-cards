class_name Arena extends Node

# Get Actors in the Arena
var enemies

@onready var player_character: Player = $Player

### Arena Steps
# (1) Combat order is rolled per actor based on speed at the beginning of combat
# (2) Attacks are made in order (Greatest to lowest) Always Player to An Enemy or An Enemy to Player
# (3) Repeat! (2 Seconds per round to slow down pace)

# enums
enum CombatState {ACTIVE, INACTIVE}
enum Round {ACTIVE, INACTIVE}

# properties
var combat_order = []
var current_state = CombatState.ACTIVE
var current_turn = 0
var round_tracker = Round.INACTIVE

# utils
var rng = RandomNumberGenerator.new()
var paused = false
var counter: float = 0.0;


func _ready():
	enemies = $Mobs.get_children() as Array[BaseEntity]

func _process(delta):
	if paused:
		return
		
	counter += delta
	# evaluate combat state and turn order
	# skip if not in combat or if actively resolving a round
	if (current_state == CombatState.INACTIVE || round_tracker == Round.ACTIVE):
		pass
	# run round
	elif (counter > 0):
		combat_round()
		counter = 0

func combat_round():
	round_tracker = Round.ACTIVE
	
	# fresh combat
	if (combat_order.is_empty()):
		# populate combat order (probably a memory nightmare right here)
		combat_order = enemies.duplicate()
		combat_order.push_back(player_character)
		
		# sort combat order
		print(combat_order)
		for combatant in combat_order:
			print(combatant.name," ", combatant.get_speed())
		print("========")
		#combat_order.sort_custom(func(a: BaseEntity, b: BaseEntity): return a.get_speed() > b.get_speed())
	# perform turn
	elif (current_state == CombatState.ACTIVE && !combat_order.is_empty()):
		var current_actor: BaseEntity = combat_order[current_turn]
		
		var source: BaseEntity = current_actor
		var target: BaseEntity = player_character

		# assign source and target for attack
		var enemy_idx = rng.randi_range(0, enemies.size() - 1)
		if (current_actor == player_character):
			source = player_character
			target = enemies[enemy_idx]
		
		# evaluate attack
		var attack_roll = await source.attempt_attack()
		var damage = source.roll_dmg()
		var attack_result = await target.evaluate_attack(attack_roll, damage)
		if (attack_result):
			print(
				"%s hit %s for %s, %s at %s" % 
				[source.name, target.name, damage, target.name, target.health]
			)
			if (target.health <= 0 && target == player_character):
				print("Game Over! You lose!")
				current_state = CombatState.INACTIVE
				player_character.kill()
			elif (target.health <= 0 && source == player_character):
				print("Got One!")
				# remove enemy from list
				enemies.pop_at(enemy_idx)
				combat_order.pop_at(combat_order.find(target))
				target.kill()
			
			# check if all combatants have been defeated
			if (enemies.is_empty()):
				print("Congrats! You've won!")
				current_state = CombatState.INACTIVE
		else:
			print("Big miss from %s" % source)
		# move To next 
		current_turn = (current_turn + 1) % combat_order.size()
	round_tracker = Round.INACTIVE
