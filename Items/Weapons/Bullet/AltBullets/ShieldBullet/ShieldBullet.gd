extends "res://Items/Weapons/Bullet/Bullet.gd"


func _on_queue_area_area_entered(area: Area2D) -> void:
	if !area.is_in_group("EnemyBullet"): return
	emit_signal("hit_wall", self)
	yield(TempTimer.idle_frame(self), "timeout")
	add_trail_to_parent()
	add_particles()
	
	if is_instance_valid(area): area.get_parent().queue_free()
	queue_free()
