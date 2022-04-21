extends KinematicBody2D
class_name HomingEnemyBullet


var direction : Vector2
var speed : float
var peircing = false
var damage:float = 0

var homingTarget: Node2D

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var light = $Light
onready var particles = $Particles

signal hitCollision


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


func _physics_process(delta):
	position += (direction.normalized()*speed)*delta
	if is_instance_valid(homingTarget):
		direction = direction.move_toward(
			global_position.direction_to(homingTarget.global_position),
			1.5 * delta
		)


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


func _on_homing_area_area_entered(area: Area2D) -> void:
	homingTarget = area
