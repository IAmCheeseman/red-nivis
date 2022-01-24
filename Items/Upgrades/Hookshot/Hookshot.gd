extends Node2D

const SPEED = 750


onready var hookSprite = $Sprite
onready var chainSprite = $Sprite/Chain
onready var collisionTimer = $RenableCollisions
onready var finalPosRC = $Collision

var zipDir: Vector2
var isZippingPlayer := false
var startingPos: Vector2
var player: Node2D
var zipNode: Node
var finalPos: Vector2


func _ready() -> void:
	startingPos = global_position
	
	zipDir = get_local_mouse_position().normalized()
	position.y -= 8
	position += zipDir * 8
	
	finalPosRC.cast_to = zipDir * 1000
	finalPosRC.force_raycast_update()
	finalPos = finalPosRC.get_collision_point() - zipDir * 16
	
	look_at(global_position + zipDir)


func _process(delta: float) -> void:
	if !isZippingPlayer:
		position += zipDir * SPEED * delta
	else:
		startingPos += zipDir * SPEED * delta
		player.vel.y = 1
		if startingPos.distance_to(global_position) < 24:
			player.vel.y = -172
			player.global_position = finalPos
			player.hurtbox.get_node("CollisionShape2D").disabled = true
			hide()
			set_process(false)
			collisionTimer.start()
			return
	player.global_position = startingPos
	player.scaleHelper.scale = Vector2.ONE
	if zipNode: zipNode.global_position = global_position
	
	chainSprite.rect_size.y = startingPos.distance_to(global_position) - 8


func _on_collision(body: Node) -> void:
	if body.is_in_group("EnemyBullet"): return
	isZippingPlayer = true
	if body is Area2D:
		zipNode = get_root(body)


func enable_collisions() -> void:
	player.hurtbox.get_node("CollisionShape2D").disabled = false
	queue_free()


func get_root(node: Node2D) -> Node2D:
	if !node is KinematicBody2D:
		return get_root(node.owner)
	return node


func _on_timeout() -> void:
	if !isZippingPlayer:
		player.vel.y = 1
		queue_free()
