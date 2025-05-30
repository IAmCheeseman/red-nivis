extends KinematicBody2D
class_name EFallingBullet


var direction : Vector2 = Vector2(0, -1)
var speed : float = 200
var peircing = false
var damage:float = 0

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var light = $Light
onready var particles = $Particles

signal hitCollision

var vel


var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width())/2, float(texture.get_height())/2, 1)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)


func _ready():
	if damage != 0: hitbox.damage = damage
	look_at(global_position+direction)
	vel = direction * speed


func _physics_process(delta):
	vel.y += Globals.GRAVITY * delta * .5
	vel.y = move_and_slide(vel).y


func add_particles():
	var newParticles = particleScene.instance()
	newParticles.position = position
	get_parent().call_deferred("add_child", newParticles)
	queue_free()


func _on_QueueArea_body_entered(body):
	if !body.is_in_group("Platform"):
		emit_signal("hitCollision", self)
		add_particles()


func _on_Hitbox_hit_object(_object):
	if !peircing:
		add_particles()
