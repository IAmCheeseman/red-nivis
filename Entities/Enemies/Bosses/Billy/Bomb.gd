extends KinematicBody2D

onready var sprite = $Sprite
onready var rc = $RayCast2D

var vel := Vector2.ZERO
var explosion := preload("res://Entities/Enemies/Explosion/Explosion.tscn")


func _physics_process(delta: float) -> void:
	sprite.rotation += delta * 2
	vel.y += Globals.GRAVITY * delta
	
	if rc.is_colliding():
		explode()
	
	vel.y = move_and_slide(vel).y


func explode() -> void:
	pass
