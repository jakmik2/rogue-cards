class_name Arena extends Node

# Get Actors in the Arena
@onready
var enemies = $Enemies.get_children() as Array[BaseEntity]
@onready
var lootManager: LootManager = $Enemies

@onready
var player_character: PlayerCharacter = $PlayerCharacter

@onready
var card_deck: Deck = $Deck

### Arena Steps
# (1) Combat order is rolled per actor based on speed at the beginning of combat
# (2) Attacks are made in order (Greatest to lowest) Always Player to An Enemy or An Enemy to Player
# (3) Repeat! (2 Seconds per round to slow down pace

# Enums
enum CombatState {ACTIVE, INACTIVE}
enum Round {ACTIVE, INACTIVE}

# Properties
var combat_order = []
var current_state = CombatState.INACTIVE
var current_turn = 0
var round_tracker = Round.INACTIVE

# Utils
var rng = RandomNumberGenerator.new()

func _ready():
	pass

func _process(_delta):
	# Evaluate Combat State and turn order
	# Skip if not in Combat or if actively resolving a round
	if (current_state == CombatState.INACTIVE):
		if (!card_deck.can_draw):
			# If Deck has been drawn, begin combat
			current_state = CombatState.ACTIVE
			# Clear out Previous round
			queue_free_children($Enemies)
			card_deck.spawn_mobs()
	elif (round_tracker == Round.ACTIVE):
		pass
	# Run Round
	else:
		combat_round()

func combat_round():
	round_tracker = Round.ACTIVE
	
	# Fresh combat
	if (combat_order.is_empty()):
		# Revoke draw permissions
		card_deck.can_draw = false
		
		# Check Enemies
		enemies = $Enemies.get_children() as Array[BaseEntity]
		
		# Populate Combat order (Probably a memory nightmare right here)		
		combat_order = enemies.duplicate()

		lootManager.round_start = true

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
		var attack_roll = await source.attempt_attack()
		var damage = source.roll_dmg()
		var attack_result = await target.evaluate_attack(attack_roll, damage)
		if (attack_result):
			print("Whamo Bamo! %s successfully struck %s for %s, reducing %s to %s" % [source, target, damage, target, target.health])
			if (target.health <= 0 && target == player_character):
				print("Game Over! You lose!")
				reset_combat()
				player_character.kill()
				return
			elif (target.health <= 0 && source == player_character):
				print("Got One!")
				# Remove Enemy from list
				enemies.pop_at(enemy_idx)
				combat_order.pop_at(combat_order.find(target))
				target.kill()
			
			# Check if all combatants have been defeated
			if (enemies.is_empty()):
				print("Congrats! You've won!")
				reset_combat()
				return
		else:
			print("Big miss from %s" % source)
		# Move To Next 
		current_turn = (current_turn + 1) % combat_order.size()
	round_tracker = Round.INACTIVE
	
	
func reset_combat():
	current_state = CombatState.INACTIVE
	round_tracker = Round.INACTIVE
	combat_order = []
	card_deck.can_draw = true


static func queue_free_children(parent: Node2D) -> void:
	for child in parent.get_children():
		child.queue_free()

