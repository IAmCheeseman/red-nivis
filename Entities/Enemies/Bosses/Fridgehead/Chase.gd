extends Node2D

var velRot = 0
var rotInc = 1

var isCharging := false
var fridge: KinematicBody2D


func test() -> bool:
	if is_processing(): return true
	set_process(true)
	rotInc = -1 if fridge.vel.x < 0 else 1
	velRot = fridge.vel.angle()
	return true


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	fridge.tilt()
	charge_up(delta)


func charge_up(delta: float) -> void:
	fridge.vel = Vector2.RIGHT.rotated(velRot) * 170
	velRot += (10 * delta) * rotInc
	
	if abs(velRot) > (PI * 2) * 3:
		velRot = 0
		fridge.isAttacking = false
		
		set_process(false)
