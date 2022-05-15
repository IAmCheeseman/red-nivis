extends KinematicBody2D
class_name EnemyBullet


var direction : Vector2
var speed : float
var peircing = false
var damage:float = 0

onready var hitbox = $Hitbox
onready var particles = $Particles

signal hitCollision


var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")


func _ready():
	if damage != 0: hitbox.damage = damage


func _physics_process(delta):
	position += (direction * speed) * delta
	speed = lerp(speed, 0, delta * 5)


func add_particles():
	var newParticles = particleScene.instance()
	newParticles.position = position
	get_parent().call_deferred("add_child", newParticles)
	do_free()


func _on_QueueArea_body_entered(body):
	if !body.is_in_group("Platform"):
		emit_signal("hitCollision", self)
		add_particles()


func _on_Hitbox_hit_object(_object):
	if !peircing:
		add_particles()


func do_free() -> void:
	hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	$Particles2D.emitting = false
	yield(TempTimer.timer(self, 1), "timeout")
	
	queue_free()
