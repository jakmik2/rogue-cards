class_name Deck extends Node2D

var cards: Array[BaseCard] = []
var discard: Array[BaseCard] = []

var can_draw = false

func push_card(card: BaseCard):
	cards.push_back(card)

func draw():
	if can_draw:
		var card_drawn: BaseCard = cards.pop_front()
		card_drawn.do_stuff()
		# Add spawn functionality here
		discard.push_front(card_drawn)

func reshuffle():
	randomize()
	cards.append_array(discard)
	cards.shuffle()
	discard = []

func click():
	print("Clicking in Deck!")
