extends Resource
class_name WorldArea

# Display Stuff
export var name:String = "Unamed"
export var solids:PackedScene
export var background:PackedScene
export var platforms:PackedScene
export var bgColor:Color

# World Gen
export var biomeIndex:int = 0
export var mapColor:Color = Color.white

export var growChance:float = .5
export var middleRemovalChance:float = .666
export var connectionChance:float = .05

# Room Gen
export var roomTemplates:String = "res://World/Templates/LabTemplates"
export(Array, PackedScene) var roofProps := []
export(Array, PackedScene) var groundProps := []#preload("res://World/Props/Containers/Safe/Safe.tscn"), preload("res://World/Props/Containers/Locker/Locker.tscn")]

# Other

export(Array, Resource) var enemyPools := [
	preload("res://World/EnemyPools/BasicEnemies.tres")
]
