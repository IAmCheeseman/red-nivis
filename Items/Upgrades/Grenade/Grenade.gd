extends RigidBody2D

onready var anim = $AnimationPlayer

export var time := 1.0
export var size := 75
export var damage := 1.0

var explosion: PackedScene = preload("res://Entities/Enemies/Explosion/Explosion.tscn")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	anim.play("Init", -1, time)

func screenshake() -> void:
	GameManager.emit_signal("screenshake", 3, 6, .15/6, .15)
	
	var newExplosion := explosion.instance()
	newExplosion.global_position = global_position
	newExplosion.set_size(size)
	newExplosion.damage = damage
	GameManager.spawnManager.spawn_object(newExplosion)
