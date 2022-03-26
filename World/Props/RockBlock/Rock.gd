extends StaticBody2D

func _ready() -> void:
	if GameManager.worldData.rooms.size() > 0:
		yield(TempTimer.idle_frame(self), "timeout")
		var exploded = GameManager.worldData.get_room_data(self, false)
		if exploded: queue_free()

func _explode(area: Area2D) -> void:
	if area.is_in_group("Explosion"):
		queue_free()
		GameManager.worldData.store_room_data(self, true)
