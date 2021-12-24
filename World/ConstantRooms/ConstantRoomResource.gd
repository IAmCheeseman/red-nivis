extends Resource
class_name ConstantRoom

export(PackedScene) var scene
export(Array, Resource) var biomes
export var mustHave := false
export var typeAlwaysVisible := false
export var roomIcon: AtlasTexture
export var perBiome = 3
export var minDistOfSameType := 2.8
export var constBiome: Resource
