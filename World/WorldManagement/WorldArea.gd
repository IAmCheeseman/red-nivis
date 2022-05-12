extends Resource
class_name WorldArea

# Display Stuff
export var name:String = "Unamed"
export var solids:PackedScene
export var brokenWall:PackedScene = preload("res://World/EnviormentalArt/Lab/LabSolidsBroken.tscn")
export var background:PackedScene
export var platforms:PackedScene
export var bgColor:Color = Color("#10141f")
export var atmosphere:PackedScene
export(float, 0, 1) var brightness:float = 104.0/255.0
export var music: AudioStreamOGGVorbis = preload("res://World/EnviormentalArt/Lab/LabAmbience.ogg")

# World Gen
export var startingArea:bool = false
export var biomeIndex:int = 0
export var biomeTile:int = 0
export var mapColor:Color = Color.white
export var secondaryColor:Color = Color.gray

export var growChance:float = .5
export var middleRemovalChance:float = .666
export var connectionChance:float = .05

# Room Gen
export(Resource) var decorator: Resource
export var roomTemplates:StreamTexture = preload("res://World/Templates/LabTemplates.png")

# Other

export(Array, Resource) var enemyPools := [
	preload("res://World/EnemyPools/BasicEnemies.tres")
]

