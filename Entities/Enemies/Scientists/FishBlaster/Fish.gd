extends KinematicBody2D
class_name FishBullet


var direction : Vector2
var speed : float
var peircing = false
var damage:float = 0

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var light = $Light
onready var particles = $Particles
onready var floorRC = $FloorRC
onready var lifetime = $Lifetime

signal hitCollision


var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")
var vel: Vector2
var rcWidth: float


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width())/2, float(texture.get_height())/2, 1)
	rcWidth = sprite.texture.get_width() + 3
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)


func _ready():
	if damage != 0: hitbox.damage = damage
	vel = (direction*speed)
	rcWidth = sprite.texture.get_height()
	lifetime.wait_time = rand_range(2.5, 3.5)
	lifetime.start()


func _physics_process(delta):
	floorRC.cast_to = vel.normalized().rotated(PI / 2) * rcWidth
	floorRC.force_raycast_update()
	if floorRC.is_colliding():
		vel = vel.bounce(floorRC.get_collision_normal()) * 0.95
		if vel.y > -20: vel.y = -100 
		sprite.frame = rand_range(0, 2)
	
	vel.y += Globals.GRAVITY * delta
	vel.x = lerp(vel.x, 0, 5 * delta)
	vel.y = move_and_slide(vel).y
	
	look_at(global_position+direction)


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


func _exit_tree() -> void:
	particles.get_node("AnimationPlayer").play("Kill")
	particles.emitting = true
	remove_child(particles)
	GameManager.spawnManager.spawn_object(particles)
