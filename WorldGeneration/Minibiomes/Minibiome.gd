extends Resource
class_name Minibiome

export(float, -1, 1) var rarity = -.4
export var mainTiles : PackedScene
export var secondaryTiles : PackedScene
export var solidNoise : NoiseTexture
export var generationNoise : NoiseTexture
export(float, -1, 1) var minNoiseValue = .2
export(Array, PackedScene) var props
export(Array, PackedScene) var enemies
export(Array, float) var enemyChances
#
