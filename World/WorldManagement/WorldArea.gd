extends Resource
class_name WorldArea

# Display Stuff
export var name:String = "Unamed"
export var solids:PackedScene
export var background:PackedScene
export var platForms:PackedScene

# World Gen
export var biomeIndex:int = 0
export var mapColor:Color = Color.white
export var roomTemplates:String = "res://World/Templates/"

#export var growLoops:int = 3
export var growChance:float = .5
export var middleRemovalChance:float = .666
