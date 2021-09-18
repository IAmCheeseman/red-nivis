extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false
var prefix : Prefix
var damage : float 
var lifetime = 5.0
onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var particles = $Particles
onready var liftimeTimer = $Lifetime
onready var anim = $AnimationPlayer
onready var dieTween = $DieTween

var particleScene = preload("res://Items/Weapons/Bullet/BulletParticles.tscn")


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width()), float(texture.get_height()), 2)/(2+sprite.hframes)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	hitbox.damage = damage
	get_parent().add_child(particles)


func _ready():
	look_at(global_position+direction)
	hitbox.setDirection = direction
	liftimeTimer.start(clamp(lifetime-0.2, .001, INF))


func _physics_process(delta):
	position += (direction*speed)*delta


func _on_QueueArea_body_entered(body):
	if body.is_in_group("Platform"):
		return
	add_particles()
	queue_free()


func add_particles():
	var newParticles = particleScene.instance()
	newParticles.position = position
	get_parent().add_child(newParticles)


func _on_Hitbox_hit_object(object):
	if !peircing:
		add_particles()
		queue_free()
	if object.get_parent().is_in_group("enemy"):
		object.get_parent().bulletDir = direction


func _on_lifetime_timeout():
	dieTween.interpolate_property(self, "speed", speed, 0, .2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	dieTween.start()
	modulate = Color.gray
	anim.play("Free")



