extends Resource
class_name Planet

export var solidTiles : PackedScene
export var backgroundTiles : PackedScene
export var backgroundImage : StreamTexture
export var atmosphereColor : Color
export var amosphereParticles : PackedScene

export var ruinChance := 6
export var minRuinDist := 15
export var ruinColor : Color

export(Array, Resource) var miniBiomes

export var size := 16
export var chunkSize := 10

export var noiseTexture : NoiseTexture
export(float, -1, .5) var minNoise := -.1

export(Array, PackedScene) var props

export(Array, PackedScene) var enemies
export(Array, float) var enemyChances
export var maxEnemies = 5

# uwu
