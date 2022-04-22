extends Node2D

export var accel = 1.0
export var frict = 2.0
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
	
	if underwater:
		AudioServer.set_bus_effect_enabled(4, 1, true)
		AudioServer.set_bus_effect_enabled(5, 1, true)

	var mist = $Mist
	if Settings.gfx == Settings.GFX_BAD:
		mist.queue_free()


func _process(_delta: float) -> void:
	if has_node("Bubbles"):
		$Bubbles.global_position = playerData.playerObject.global_position


func _exit_tree() -> void:
	playerData.friction = defaultFrict
	playerData.accelaration = defaultAccel
	
	AudioServer.set_bus_effect_enabled(4, 1, false)
	AudioServer.set_bus_effect_enabled(5, 1, false)

	GameManager.underwater = false
