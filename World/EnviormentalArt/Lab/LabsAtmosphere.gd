extends Node2D

func _ready() -> void:
	var mist = $Mist
	if Settings.gfx == Settings.GFX_BAD:
		mist.queue_free()
