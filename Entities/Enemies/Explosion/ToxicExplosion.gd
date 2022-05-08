extends "res://Entities/Enemies/Explosion/Explosion.gd"

func set_size(size: int) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size
	eHB.shape.radius = size
	pHB.shape.radius = size * 0.90
	particles.restart()
