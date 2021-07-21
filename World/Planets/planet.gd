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

export var gravity = 350

export(Array, Resource) var miniBiomes

export var flatTemplates:String = "res://World/Templates/FlatTemplates.png"
export var connectionTemplates:String = "res://World/Templates/ConnectionTemplates.png"

export(Array, PackedScene) var props

export(Array, PackedScene) var enemies
export(Array, float) var enemyChances


