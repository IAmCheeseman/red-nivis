extends Resource
class_name Planet

export var solidTiles : PackedScene
export(Array, StreamTexture) var backgroundImages
export var sky:StreamTexture
export var atmosphereColor : Color
export var atmosphereParticles : PackedScene

export var mistStrength:float = .5
export var mistColor: Color

export var ruinChance := 6
export var minRuinDist := 15
export var ruinColor: Color

export(Array, Resource) var miniBiomes

export var CAIterations := 2
export var CAStarveLimit := 3
export var CAOverPop := 4
export var prefabs := "res://WorldGeneration/Prefabs/"

export(Array, PackedScene) var props

export(Array, PackedScene) var enemies
export(Array, float) var enemyChances


