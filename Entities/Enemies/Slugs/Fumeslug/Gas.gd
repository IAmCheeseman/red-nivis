extends KinematicBody2D
class_name GasBullet


var direction : Vector2
var speed : float
var peircing = false
var damage:float = 0

onready var hitbox = $Hitbox
onready var particles = $Particles
onready var anim = $AnimationPlayer

signal hitCollision
var vel = Vector2.ZERO


var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")
var burnt = false

func _ready():
	if damage != 0: hitbox.damage = damage
	vel = direction * speed


func _physics_process(delta):
	vel.y += Globals.WATER_GRAVITY * delta * .4
	vel.x = lerp(vel.x, 0, 5 * delta)
	
	vel.y = move_and_slide(vel).y


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
	$Fire.emitting = false
	yield(TempTimer.timer(self, 1), "timeout")
	
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		anim.play("Burn")
		burnt = true
		
		yield(TempTimer.timer(self, 3), "timeout")
		do_free()
