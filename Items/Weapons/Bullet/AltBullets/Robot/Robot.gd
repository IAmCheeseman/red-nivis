extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false
var damage : float 
var lifetime = 5.0

const JUMP_FORCE = 350

onready var hitbox = $Hitbox
onready var sprite = $Sprite
onready var lifetimeTimer = $Lifetime
onready var anim = $AnimationPlayer
onready var floorChecker = $FloorChecker

#var particleScene = preload("res://Items/Weapons/Bullet/BulletParticles.tscn")
var particleScene = preload("res://Entities/Effects/ShockwaveEffect.tscn")
var target: Node2D = GameManager.player

signal hit_wall(bullet)
signal hit_enemy(bullet)


func set_texture(_texture:StreamTexture):
	return


func _ready() -> void:
	direction *= speed
	hitbox.damage = damage


func _physics_process(delta):
	if is_instance_valid(target):
		direction.x = lerp(
			direction.x,
			round(
				to_local(target.global_position).normalized().x) * speed,
			5 * delta
		)
		if target.global_position.y > global_position.y and floorChecker.is_colliding():
			direction.y = -JUMP_FORCE
		sprite.flip_h = direction.x < 0
	else:
		direction.x = lerp(direction.x, 0, 5 * delta)
	direction.y += Globals.GRAVITY * delta
	direction.y = move_and_slide(direction).y


func _on_lifetime_timeout():
	queue_free()


func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if !area.is_in_group("EnemyBullet"): target = area
