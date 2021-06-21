extends Resource
class_name Planet

export var solidTiles : PackedScene
export var backgroundTiles : PackedScene
export var backgroundImage : StreamTexture
export var atmosphereColor : Color
export var amosphereParticles : PackedScene

export var mistStrength = .5
export var mistColor : Color

export var ruinChance := 6
export var minRuinDist := 15
export var ruinColor : Color

export(Array, Resource) var miniBiomes

export var CAIterations := 2
export var CAStarveLimit := 3
export var CAOverPop := 4
export var prefabs := "res://WorldGeneration/Prefabs/"

export(Array, PackedScene) var props

export(Array, PackedScene) var enemies
export(Array, float) var enemyChances


