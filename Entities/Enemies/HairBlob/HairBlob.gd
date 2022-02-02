extends KinematicBody2D

onready var playerDetection = $PlayerDetection
onready var anim = $AnimationPlayer
onready var floorRC = $FloorDetection

const EXPLOSION = preload("res://Entities/Enemies/Explosion/Explosion.tscn")

var player: Node2D


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	global_position = floorRC.get_collision_point() + Vector2(0, 3)


func _process(_delta: float) -> void:
	if !player: player = playerDetection.get_player()
	elif !anim.is_playing(): anim.play("Jump")


func explode() -> void:
	var newExplosion = EXPLOSION.instance()
	newExplosion.global_position = global_position
	GameManager.spawnManager.call_deferred("add_child", newExplosion)
	queue_free()
