extends Resource
class_name Prefix

export var name = "Unnamed Prefix"
export var effect : PackedScene
export var particleEffect : PackedScene
export(int, "CALLED_ON_SHOOT", "CALLED_ON_HIT") var callMethod = 0
export(float, 0, 50) var chance = 50
