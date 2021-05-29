extends Node2D
tool

export var mistRarity = 2
export var mistClumpSize = 4
export var mistClumRange = 4
export var clumpSpread = 64
export var color : Color
export var strength = .5

var mist = preload("res://WorldGeneration/Mist.tscn")


func spawn_mist():
	var clumpSize = rand_range(clamp(mistClumpSize-mistClumRange, 1, INF), mistClumpSize+mistClumRange)
	var mistPos = global_position+Vector2(rand_range(-600, 600), rand_range(-600, 600))

	for nm in clumpSize:
		var newMist = mist.instance()
		newMist.rect_global_position = mistPos+Vector2(rand_range(-clumpSpread, clumpSpread), rand_range(-clumpSpread, clumpSpread))
		get_parent().get_parent().get_parent().add_child(newMist)
		newMist.set_param(color, strength)
