extends KinematicBody2D
class_name EnemyBullet
#
#var direction : Vector2
#var speed : float
#var peircing = false
#onready var lastFramePos = global_position
#
#onready var hitbox = $Hitbox
#
#func _physics_process(delta):
#	global_position = lastFramePos
#	global_position += (direction*speed)*delta
#	lastFramePos = global_position
#
#
#func _on_QueueArea_body_entered(_body):
#	queue_free()
#
#
#func _on_Hitbox_hit_object():
#	if !peircing:
#		queue_free()


var direction : Vector2
var speed : float
var peircing = false

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var light = $Light
onready var particles = $Particles


func set_texture(texture:StreamTexture, lightTexture:StreamTexture):
	sprite.texture = texture
	light.texture = lightTexture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width())/2, float(texture.get_height())/2, 1)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)


func _ready():
	look_at(global_position+direction)


func _physics_process(delta):
	position += (direction*speed)*delta


func _on_QueueArea_body_entered(_body):
	queue_free()


func _on_Hitbox_hit_object():
	if !peircing:
		queue_free()
