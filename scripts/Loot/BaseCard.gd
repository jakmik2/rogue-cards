class_name BaseCard extends BaseLoot

@export var card_name = "Base Card"
@export var enemy: Resource

@onready
var card_deck: Deck = get_node('/root/Main/Deck')
#@onready
#var enemies = get_node('/root/Main/Enemies')

func spawn_mobs():
	var mob: Skele = enemy.instantiate()
	var mob1: Skele = enemy.instantiate()
	var mob2: Skele = enemy.instantiate()
	
	return [mob, mob1, mob2]
	

func click():
	# Push Loose Card into deck
	card_deck.push_card(self)

	# Free from tree
	if (is_inside_tree()):
		get_parent().remove_child(self)
