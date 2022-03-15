extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var playerData = preload("res://Entities/Player/Player.tres")
		if !playerData.upgrades.has("res://Items/Upgrades/Teleport/Teleport.tres"):
			Achievement.unlock("HANK_SKIP")
