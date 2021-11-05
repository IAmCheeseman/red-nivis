extends Resource
class_name WorldArea

# Display Stuff
export var name:String = "Unamed"
export var solids:PackedScene
export var background:PackedScene
export var platforms:PackedScene
export var bgColor:Color = Color("#10141f")
export var mistColor:Color = Color("#734c3a")

# World Gen
export var biomeIndex:int = 0
export var mapColor:Color = Color.white

export var growChance:float = .5
export var middleRemovalChance:float = .666
export var connectionChance:float = .05

# Room Gen
export var roomTemplates:StreamTexture = preload("res://World/Templates/LabTemplates.png")
export(Array, PackedScene) var roofProps := []
export(Array, PackedScene) var groundProps := []

# Other

export(Array, Resource) var enemyPools := [
	preload("res://World/EnemyPools/BasicEnemies.tres")
]
