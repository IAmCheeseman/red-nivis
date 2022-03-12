extends Node2D

var playerData = preload("res://Entities/Player/Player.tres")
var defaultFrict: float
var defaultAccel: float

func _ready() -> void:
	defaultFrict = playerData.friction
	defaultAccel = playerData.accelaration
	playerData.friction = 2
	playerData.accelaration = 1
	
	var mist = $Mist
	if Settings.gfx == Settings.GFX_BAD:
		mist.queue_free()

func _exit_tree() -> void:
	playerData.friction = defaultFrict
	playerData.accelaration = defaultAccel
