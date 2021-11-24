extends Node2D

onready var enemySpawner = $EnemySpawner
onready var anim = $AnimationPlayer
onready var startTimer = $Timer

var enemyPool:Resource


func _ready() -> void:
	enemySpawner.enemyTable = enemyPool
	startTimer.start(rand_range(0.001, .5))


func _on_start_timer_timeout() -> void:
	anim.play("default")


func _on_enemy_added(enemy) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	
	enemy.get_parent().remove_child(enemy)
	get_parent().add_child(enemy)

