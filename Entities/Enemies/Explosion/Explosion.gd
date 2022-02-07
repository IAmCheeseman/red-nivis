extends Node2D

onready var pHB = $PlayerHitbox/CollisionShape2D
onready var eHB = $EnemyHitbox/CollisionShape2D
onready var particles = $ExplosionParticles


func set_size(size: int) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size
	eHB.shape.radius = size
	pHB.shape.radius = size * 0.75
