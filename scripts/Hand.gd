extends Node2D

var arena
var player

var hand: Array[Card]
# Called when the node enters the scene tree for the first time.
func _ready():
	arena = get_parent()
	player = arena.get_node("Player")
	
	hand = player.draw()
	for card in hand:
		add_child(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
