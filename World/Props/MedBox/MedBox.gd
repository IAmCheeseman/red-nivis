extends Node2D

onready var anim = $AnimationPlayer
onready var interaction = $Iteraction
onready var spawnPos = $SpawnPosition

var playerData = preload("res://Entities/Player/Player.tres")


func _process(_delta: float) -> void:
	interaction.disabled = playerData.maxHealth <= playerData.health


func _on_interaction() -> void:
	anim.play("Open")
	GameManager.emit_signal(
		"zoom_in",
		.75,
		2,
		.2,
		global_position-Vector2(0, 16)
	)


func spawn_medkits() -> void:
	var medkitsToSpawn := ceil((playerData.maxHealth - playerData.health) / 25) + 1
	
	var angleDiff := 17
	for i in medkitsToSpawn:
		var angle = deg2rad(
			angleDiff * i - (angleDiff * (medkitsToSpawn - 1) * 0.5)
		)
		var pushAngle = Vector2.UP.rotated(angle)*60
		
		var newMedkit = preload("res://Items/Medkit/Medkit.tscn").instance()
		newMedkit.apply_central_impulse(pushAngle) 
		newMedkit.global_position = spawnPos.global_position
		GameManager.spawnManager.spawn_object(newMedkit)
