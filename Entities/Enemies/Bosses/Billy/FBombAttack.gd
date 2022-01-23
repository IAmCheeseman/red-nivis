extends Node2D

const FBOMB = preload("res://Entities/Enemies/Bosses/Billy/FBomb.tscn")

onready var chargeTimer = $Charge
onready var fbomb1 = $FBomb1
onready var fbomb2 = $FBomb2

func attack() -> bool:
	show()
	chargeTimer.start()
	return true


func _process(delta: float) -> void:
	fbomb1.scale = Vector2.ONE * (1 - (chargeTimer.time_left / chargeTimer.wait_time))
	fbomb2.scale = Vector2.ONE * (1 - (chargeTimer.time_left / chargeTimer.wait_time))


func fBomb() -> void:
	var pos := global_position - Vector2(121 / 2, 0)
	for i in 2:
		var newFBomb = FBOMB.instance()
		newFBomb.global_position = pos
		GameManager.spawnManager.spawn_object(newFBomb)
		pos.x += 121
	hide()
