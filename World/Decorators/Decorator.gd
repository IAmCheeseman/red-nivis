extends Resource
class_name Decorator

export var roomTemplates:StreamTexture = preload("res://World/Templates/LabTemplates.png")
export(Array, PackedScene) var roofProps := []
export(Array, float)       var roofPropsChance := []
export(Array, PackedScene) var groundProps := []
export(Array, float)       var groundPropsChance := []
