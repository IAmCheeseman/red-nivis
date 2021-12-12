extends Node2D

onready var anim = $AnimationPlayer
onready var interaction = $Iteraction
onready var spawnPos = $SpawnPosition

var playerData = preload("res://Entities/Player/Player.tres")


func _process(delta: float) -> void:
	interaction.disabled = playerData.maxHeals-playerData.healsLeft == 0


func _on_interaction() -> void:
	anim.play("Open")


func spawn_medkits() -> void:
	var amountGone = playerData.maxHeals-playerData.healsLeft
	
	var angleDiff = 17
	for i in amountGone:
		var angle = deg2rad(
			angleDiff*i-(angleDiff*(amountGone-1)*.5)
		)
		var pushAngle = Vector2.UP.rotated(angle)*60
		
		var newMedkit = preload("res://Items/Medkit/Medkit.tscn").instance()
		newMedkit.apply_central_impulse(pushAngle)
		newMedkit.global_position = spawnPos.global_position
		GameManager.spawnManager.spawn_object(newMedkit)
