extends RigidBody2D

onready var anim = $AnimationPlayer
onready var particles = $Explosion
onready var enemyHitbox = $EnemyHitbox

export var time = 1.0
export var size = 75
export var damage := 1.0

func _ready() -> void:
	if !is_instance_valid(enemyHitbox): return
	enemyHitbox.damage = damage
	yield(TempTimer.idle_frame(self), "timeout")
	anim.play("Init", -1, time)
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size

func screenshake() -> void:
	GameManager.emit_signal("screenshake", 3, 6, .15/6, .15)
