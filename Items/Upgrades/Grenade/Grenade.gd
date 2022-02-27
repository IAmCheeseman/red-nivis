extends RigidBody2D

onready var anim = $AnimationPlayer
onready var particles = $Explosion

export var time = 1.0
export var size = 75

func _ready() -> void:
	anim.play("Init", -1, time)
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = size

func screenshake() -> void:
	GameManager.emit_signal("screenshake", 3, 6, .15/6, .15)
