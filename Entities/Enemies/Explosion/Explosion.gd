extends Node2D

onready var pHB = $PlayerHitbox/CollisionShape2D
onready var eHB = $EnemyHitbox/CollisionShape2D
onready var particles = $ExplosionParticles
onready var charAdder = $Char

export var damage: int
export var startSize: int = -1

func _ready() -> void:
	eHB.owner.damage = damage
	if startSize != -1: set_size(startSize)

func set_size(size: int) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size
	eHB.shape.radius = size
	pHB.shape.radius = size * 0.90
	charAdder.startDist = size
	charAdder.endDist = size
	particles.restart()
