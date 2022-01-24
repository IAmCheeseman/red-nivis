extends KinematicBody2D

const FBOMB = preload("res://Entities/Enemies/Bosses/Billy/FBomb.tscn")

onready var attacks = $Attacks
onready var attackTimer = $Timers/Attack
onready var damageManager = $DamageManager
onready var anim = $AnimationPlayer

export var speed := 50.0
export var accel := 2.0

var vel := Vector2.ZERO
var isEnraged := false


func _physics_process(delta: float) -> void:
	var target = GameManager.player.global_position - Vector2(0, 100)
	var dir    =                global_position.direction_to(target ) * speed
	vel.x      =                lerp(vel.x, dir.x, accel * delta    )
	vel.y      =                lerp(vel.y, dir.y, accel * delta * 8)
	
	if isEnraged: anim.play("IdleEnraged")
	
	vel = move_and_slide(vel)


func _on_damaged() -> void:
	isEnraged = damageManager.health < damageManager.maxHealth / 2


func attack() -> void:
	var attackNodes = attacks.get_children()
	attackNodes.shuffle()
	for i in attackNodes.size():
		var attack = attackNodes.pop_front()
		if attack.attack(): break
	attackTimer.start(rand_range(2, 4))
	if isEnraged: attackTimer.start(rand_range(1, 2))
