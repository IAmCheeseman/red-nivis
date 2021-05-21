extends Resource
class_name RuinHandler

var humanRuins = [
	{
		"scene" : preload("res://Ruins/Human/WorldAppearance/BaseRuins1.tscn"),
		"customPosition" : Vector2.LEFT
	},
	{
		"scene" : preload("res://Ruins/Human/WorldAppearance/BaseRuins2.tscn"),
		"customPosition" : Vector2.LEFT
	}
]

var alienRuins = [
	
]


func get_ruins(getHuman : bool) -> Array:
	if getHuman: return humanRuins
	else: return alienRuins


func get_ruin(index : int, fromHuman : bool) -> PackedScene:
	match fromHuman:
		true:
			return humanRuins[index]
		false:
			return alienRuins[index]
	return humanRuins[index]
