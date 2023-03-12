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

func set_size(size: int, playerSize=null) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size
	eHB.shape.radius = size / 2.0
	pHB.shape.radius = (size / 2.0) * 0.90 if playerSize == null else playerSize
	charAdder.startDist = size
	charAdder.endDist = size
	
	particles.amount = size * 3
	particles.restart()
