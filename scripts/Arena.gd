class_name Arena extends Node2D

# Get Actors in the Arena
var enemies = []

@onready var mobs : Node2D = $Mobs
@onready var tooltip : Control = $UI/TextDisplay
@onready var player_character : Player = $Player

@onready var exit_button : Button = $UI/ExitButton
@onready var paused_button : Button = $UI/PauseReturn

@onready var mob_template : PackedScene = preload("res://scenes/Mob.tscn")

### Arena Steps
# (1) Combat order is rolled per actor based on speed at the beginning of combat
# (2) Attacks are made in order (Greatest to lowest) Always Player to An Enemy or An Enemy to Player
# (3) Repeat! (2 Seconds per round to slow down pace)

# enums
enum CombatState {ACTIVE, INACTIVE}
enum Round {ACTIVE, INACTIVE}
enum EndCombat {ACTIVE, INACTIVE}
enum Phase {COMBAT, LOOTING, FINISHED}

# properties
var combat_order = []
var current_state = CombatState.ACTIVE
var current_phase = Phase.COMBAT
var current_turn = 0
var round_tracker = Round.INACTIVE

var mob_num_to_pos = {
	0 : Vector2(640,353.256),
	1 : Vector2(448,243.354),
	2 : Vector2(448,431.757),
	3 : Vector2(832,243.354),
	4 : Vector2(832,431.757),
}

# enemy lineup in order, [BL, TL, MID, TR, BR]
var enemy_lineup : Array[String]

# utils
var rng = RandomNumberGenerator.new()
var paused = false
var counter: float = 0.0;


func _ready():
	mobs.hide()
	enemy_lineup = Global.current_arena_loadout
	# turn off tooltip
	hide_tooltip()
	
	for i in range(len(enemy_lineup)):
		var new_mob = mob_template.instantiate()
		new_mob.species = enemy_lineup[i].left(5)
		new_mob.tier = enemy_lineup[i].right(1).to_int()
		new_mob.position = mob_num_to_pos[i]
		mobs.add_child(new_mob)
		new_mob.setup()
	
	#for i in range(len(enemy_lineup)):
		## parse through the provided enemy string to provide conditions for setup()
		#var new_enemy = enemy_lineup[i]
		#$Mobs.get_child(i).tier = new_enemy.right(1).to_int()
		#new_enemy = new_enemy.left(new_enemy.length()-1)
		#$Mobs.get_child(i).species = new_enemy
		#$Mobs.get_child(i).setup()
	
	for monster in $Mobs.get_children():
		# destroy any instances of "None" 
		# TODO create a system where we can create as many monsters as we wish, not limited to 5
		enemies.append(monster)
	mobs.show()

func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		print("PAUSE ON!")
		get_tree().paused = true
		paused_button.show()
		exit_button.show()

func _process(delta):
	# TODO implement pause
	if paused:
		return
		
	counter += delta
	# evaluate combat state and turn order
	# skip if not in combat or if actively resolving a round
	if (current_state == CombatState.INACTIVE or round_tracker == Round.ACTIVE):
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
		combat_order.sort_custom(func(a: BaseEntity, b: BaseEntity): return a.get_speed() > b.get_speed())
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
			#print(
				#"%s hit %s for %s, %s at %s" % 
				#[source.name, target.name, damage, target.name, target.health]
			#)
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
				print("Congrats! You've won!\nCollect Loot to Continue.")
				current_state = CombatState.INACTIVE
				current_phase = Phase.LOOTING
				end_combat()
		else:
			print("Big miss from %s" % source)
		# move To next
		current_turn = (current_turn + 1) % combat_order.size()
	round_tracker = Round.INACTIVE

func end_combat():
	var loot_counter = 1
	for loot in $Loot.get_children():
		# collect loot and put it in an aesthetic order
		loot.position.x = get_viewport_rect().size.x * loot_counter / ($Loot.get_child_count() + 1)
		loot.position.y = get_viewport_rect().size.y / 2
		loot_counter += 1
	current_phase = Phase.LOOTING

func end_looting():
	print("moving along. . .")
	get_tree().change_scene_to_file("res://scenes/Overworld.tscn")

func toggle_tooltip():
	tooltip.visible = !tooltip.visible

func hide_tooltip():
	tooltip.hide()

func show_tooltip():
	tooltip.show()

func _on_close_button_pressed():
	paused_button.hide()
	exit_button.hide()
	get_tree().paused = false

func _on_exit_button_pressed():
	get_tree().quit()
