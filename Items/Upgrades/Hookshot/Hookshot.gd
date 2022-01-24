extends Node2D

const SPEED = 750


onready var hookSprite = $Sprite
onready var chainSprite = $Sprite/Chain

var zipDir: Vector2
var isZippingPlayer := false
var startingPos: Vector2
var player: Node2D


func _ready() -> void:
	startingPos = global_position
	
	zipDir = get_local_mouse_position().normalized()
	position.y -= 8
	position += zipDir * 8
	
	look_at(global_position + zipDir)


func _process(delta: float) -> void:
	if !isZippingPlayer:
		position += zipDir * SPEED * delta
	else:
		startingPos += zipDir * SPEED * delta
		player.vel.y = 1
		if startingPos.distance_to(global_position) < 24:
			player.vel = zipDir * SPEED
			queue_free()
	player.global_position = startingPos
	player.scaleHelper.scale = Vector2.ONE
	chainSprite.rect_size.y = startingPos.distance_to(global_position) - 8


func _on_collision(_body: Node) -> void:
	isZippingPlayer = true


func _on_timeout() -> void:
	if !isZippingPlayer: 
		player.vel.y = 1
		queue_free()
