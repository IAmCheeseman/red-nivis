tool
extends Particles2D

var lastFrameEmitting = false


func _process(_delta: float) -> void:
	if emitting and !lastFrameEmitting:
		$Smoke.process_material.emission_sphere_radius = process_material.emission_sphere_radius / 3
		$Smoke.restart()
	lastFrameEmitting = emitting
