extends KinematicBody2D
class_name PotionBottle


var direction : Vector2
var speed : float
var peircing = false
var damage:float = 0

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var light = $Light
onready var particles = $Particles

signal hitCollision

var vel: Vector2

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
	vel = direction * speed


func _physics_process(delta):
	vel.y += Globals.GRAVITY * delta
	vel.y = move_and_slide(vel).y
	
	sprite.rotation += 20 * delta


func add_particles():
	var newParticles = particleScene.instance()
	newParticles.position = position
	get_parent().call_deferred("add_child", newParticles)
	
	for i in 10:
		var newFrost = preload("res://Entities/Enemies/Scientists/FreezingPotion/Freeze.tscn").instance()
		newFrost.global_position = global_position + Vector2(0, -8)
		newFrost.vel = Vector2.RIGHT.rotated(rand_range(0, PI*2)) * (40 * randf())
		GameManager.spawnManager.spawn_object(newFrost)
	
	queue_free()


func _on_QueueArea_body_entered(body):
	if !body.is_in_group("Platform"):
		emit_signal("hitCollision", self)
		add_particles()


func _on_Hitbox_hit_object(_object):
	if !peircing:
		add_particles()
