class_name BaseLoot extends Node2D
var loot_tag

var loot_type = ""
var loot_tier = ""
var loot_roll = 0

func init(_loot_type, _loot_tier, _loot_roll):
	self.loot_type = _loot_type
	self.loot_tier = _loot_tier
	self.loot_roll = _loot_roll
	self.loot_tag = loot_type.left(1) + loot_tier.right(1)

func click():
	print("You just clicked loot!")
