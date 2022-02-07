extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false
var damage : float 
var lifetime = 5.0

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var particles = $Particles
onready var lifetimeTimer = $Lifetime

var backToOrigin = false
var start: Vector2


func set_texture(texture:StreamTexture):
	sprite.texture = texture
	particles.process_material.emission_box_extents = Vector3(
		float(texture.get_width()),
		float(texture.get_height()), 2
	) / (2 + sprite.hframes)
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
	start = global_position
	lifetimeTimer.start(clamp(lifetime-0.2, .001, INF))

func _physics_process(delta):
	position += (direction*speed)*delta
	rotation += 15 * delta
	if backToOrigin:
		direction = direction.move_toward(
			global_position.direction_to(start),
			speed * delta
		)
		if global_position.distance_to(start) < 5:
			queue_free()
#	trail.clear_points()
#	trail.add_point(to_local(start))
#	trail.add_point(Vector2.ZERO)


func _on_QueueArea_body_entered(body):
	if body.is_in_group("Platform"):
		return
	backToOrigin = true
	direction = global_position.direction_to(GameManager.player.global_position) * 4


func _on_Hitbox_hit_object(object):
	if object.get_parent().is_in_group("player"):
		object.get_parent().bulletDir = direction


func _on_lifetime_timeout():
	backToOrigin = true

