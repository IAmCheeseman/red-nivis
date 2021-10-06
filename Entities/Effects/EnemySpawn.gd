extends Node2D

onready var enemySpawner = $EnemySpawner
onready var anim = $AnimationPlayer
onready var startTimer = $Timer

export var enemyPool:Resource


func _ready() -> void:
	enemySpawner.enemyTable = enemyPool
	startTimer.start(rand_range(0.001, .5))


func _on_start_timer_timeout() -> void:
	anim.play("default")
