extends Node2D

const SPEED = 500

onready var zipPointRC = $ZipPoint
onready var hookSprite = $Sprite
onready var chainSprite = $Sprite/Chain

var zipDir: Vector2
var isZippingPlayer := false
var startingPos: Vector2


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
		GameManager.player.vel.y = 0
		if startingPos.distance_to(global_position) < 16:
			queue_free()
	GameManager.player.global_position = startingPos


func _on_body_entered(body: Node) -> void:
	print("*zips*")
	isZippingPlayer = true
