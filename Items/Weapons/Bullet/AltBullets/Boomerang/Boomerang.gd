extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false
var damage : float 
var lifetime = 5.0

var startingPos: Vector2

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var particles = $Particles
onready var lifetimeTimer = $Lifetime
onready var dieTween = $DieTween
onready var kill = $Kill
onready var trail = $Trail

#var particleScene = preload("res://Items/Weapons/Bullet/BulletParticles.tscn")
var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")
var toPlayer = false

signal hit_wall(bullet)
signal hit_enemy(bullet)


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(
		float(texture.get_width()),
		float(texture.get_height()), 2)/(2+sprite.hframes)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	hitbox.damage = damage
	get_parent().add_child(particles)


func _ready():
	sprite.look_at(global_position+direction)
	hitbox.look_at(global_position+direction)
	hitbox.setDirection = direction
	hitbox.damage = damage
	lifetimeTimer.start(clamp(lifetime-0.2, .001, INF))
	startingPos = global_position - ( direction * 16 )

func _physics_process(delta):
	position += (direction*speed)*delta
	sprite.rotation += delta * 16
	if toPlayer:
		direction = direction.move_toward(
			global_position.direction_to(GameManager.player.global_position),
			speed
		)
		if global_position.distance_to(GameManager.player.global_position) < 5:
			add_trail_to_parent()
			queue_free()
#	kill.global_position = startingPos


func _on_QueueArea_body_entered(body):
	if body.is_in_group("Platform"):
		return
	emit_signal("hit_wall", self)
	toPlayer = true
	direction = global_position.direction_to(GameManager.player.global_position) * 4
#	add_trail_to_parent()
#	add_particles()
#	queue_free()


func add_particles():
	var newParticles = particleScene.instance()
	newParticles.position = position
	get_parent().add_child(newParticles)


func add_trail_to_parent():
	if !has_node("Trail"): return
	remove_child(trail)
	trail.global_position = global_position
	get_parent().add_child(trail)
	trail.emitting = false
	
	var timer = Timer.new()
	timer.wait_time = 2
	get_parent().add_child(timer)
	timer.start()
	
	timer.connect("timeout", trail, "queue_free")
	timer.connect("timeout", timer, "queue_free")


func _on_Hitbox_hit_object(object):
	emit_signal("hit_enemy", self)
	if object.get_parent().is_in_group("enemy"):
		object.get_parent().bulletDir = direction


func _on_lifetime_timeout():
	toPlayer = true
#	dieTween.interpolate_property(
#		self, "speed", speed,
#		-speed, .2, Tween.TRANS_LINEAR,
#		Tween.EASE_IN_OUT
#	)
#	dieTween.start()

