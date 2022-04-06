extends Node2D

export var accel = 1
export var frict = 2
export var underwater := false

var playerData = preload("res://Entities/Player/Player.tres")
var defaultFrict: float
var defaultAccel: float

func _ready() -> void:
	defaultFrict = playerData.friction
	defaultAccel = playerData.accelaration
	playerData.friction = frict
	playerData.accelaration = accel
	
	GameManager.underwater = underwater
	
	var mist = $Mist
	if Settings.gfx == Settings.GFX_BAD:
		mist.queue_free()

func _exit_tree() -> void:
	playerData.friction = defaultFrict
	playerData.accelaration = defaultAccel
	
	GameManager.underwater = false
