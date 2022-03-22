extends Node2D

export var enemiesPath:NodePath

onready var enemies = get_node(enemiesPath)

var isChecking := false
var lastKilledEnemyPos = Vector2.ZERO

signal enemiesCleared


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	if enemies.get_child_count() == 0:
		emit_signal("enemiesCleared")


func _on_enemy_die(enemy) -> void:
	lastKilledEnemyPos = enemy.global_position

func add_enemies() -> void:
	for i in enemies.get_children():
		if !is_instance_valid(i): break
		if "_on_enemy_die" in i.get_signal_connection_list("dead"): continue
		var _discard = i.get_node("DamageManager").connect("dead", self, "_on_enemy_die", [i])

func _process(_delta: float) -> void:
	if enemies.get_child_count() == 0 and isChecking:
		emit_signal("enemiesCleared")	
	elif enemies.get_child_count() > 0:
		isChecking = true
