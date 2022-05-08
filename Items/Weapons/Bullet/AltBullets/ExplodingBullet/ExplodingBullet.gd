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
		add_explosion()
		queue_free()
	if object.get_parent().is_in_group("enemy"):
		object.get_parent().bulletDir = direction


func _on_lifetime_timeout():
	add_explosion()
	queue_free()
