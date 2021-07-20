extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false
var prefix : Prefix
var lifetime = 5.0
onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var particles = $Particles
onready var liftimeTimer = $Lifetime
onready var anim = $AnimationPlayer
onready var dieTween = $DieTween

var explosion = preload("res://Enemies/Explosion.tscn")
var vel:Vector2 = Vector2.ZERO
var bounces = 0


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(float(texture.get_width()), float(texture.get_height()), 2)/(2+sprite.hframes)
	remove_child(particles)
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)


func _ready():
	look_at(global_position+direction)
	liftimeTimer.start(clamp(lifetime-0.2, .001, INF))
	vel = direction*speed


func _physics_process(delta):
	vel.y += GameManager.gravity*delta
	look_at(global_position+vel.normalized()+direction)


	vel.y = move_and_slide(vel).y


func _on_QueueArea_body_entered(_body):
	vel = -vel/2
	bounces += 1
	if bounces == 3:
		add_explosion()
		queue_free()


func add_explosion():
	var newExplosion = explosion.instance()
	newExplosion.position = position
	get_parent().call_deferred("add_child", newExplosion)


func _on_Hitbox_hit_object(object):
	if !peircing:
		add_explosion()
		queue_free()
	if object.get_parent().is_in_group("enemy"):
		object.get_parent().bulletDir = direction


func _on_lifetime_timeout():
	dieTween.interpolate_property(self, "speed", speed, 0, .2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	dieTween.start()
	modulate = Color.gray
	queue_free()
#	anim.play("Free")
