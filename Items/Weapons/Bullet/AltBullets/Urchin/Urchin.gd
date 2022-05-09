extends RigidBody2D

var direction : Vector2
var speed : float
var peircing = false
var damage: float
var lifetime = 5.0
onready var sprite = $Sprite
onready var particles = $Particles
onready var liftimeTimer = $Lifetime

var explosion = preload("res://Entities/Enemies/Explosion/Explosion.tscn")

# warning-ignore:unused_signal
signal hit_wall
# warning-ignore:unused_signal
signal hit_enemy

var targetNode: Node2D

func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width())/2, float(texture.get_height())/2, 1)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)


func _ready():
	set_vars()
	
	look_at(global_position+direction)
	apply_central_impulse(direction * speed)
	
	liftimeTimer.start(lifetime)


func set_vars() -> void:
	pass


func _process(delta: float) -> void:
	if targetNode:
		if !is_instance_valid(targetNode):
			queue_free()
			return
		global_position = targetNode.global_position


func _on_QueueArea_body_entered(_body):
	queue_free()


func add_explosion():
	var newExplosion = explosion.instance()
	newExplosion.position = position
	newExplosion.damage = damage
	newExplosion.set_size(47)
	get_parent().add_child(newExplosion)


func _on_Hitbox_hit_object(object):
	if !peircing:
		queue_free()
	var parent = object.get_parent()
	if parent.is_in_group("enemy"):
		parent.bulletDir = direction
	targetNode = object
	mode = RigidBody2D.MODE_KINEMATIC
	linear_velocity = Vector2.ZERO


func _on_lifetime_timeout():
	queue_free()
