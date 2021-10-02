extends Node2D

onready var enemySpawner = $EnemySpawner

export var enemyPool:Resource


func _ready() -> void:
	enemySpawner.enemyTable = enemyPool
