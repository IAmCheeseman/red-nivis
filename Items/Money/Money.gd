extends KinematicBody2D

onready var sprite = $Sprite
onready var timer = $Timer
onready var playerDetection = $PlayerDetection
onready var br = $BounceRay
onready var collision = $CollisionShape2D

export var value:int = 5
export var friction:int = 5
export var speed:int = 200

var coinSprite:StreamTexture = preload("res://Items/Money/Coin.png")
var playerData = preload("res://Entities/Player/Player.tres")
var vel:Vector2 = Vector2.ZERO
var player:Node2D
var gravitation := 1


func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	
	var minCoinSpriteVal = 10
	if value < minCoinSpriteVal:
		sprite.texture = coinSprite
	
	vel = Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))*200


func _physics_process(delta: float) -> void:
	if playerDetection.get_player() and timer.is_stopped():
		playerData.money += value
		vel = global_position.direction_to(
			player.global_position)*speed
		collision.disabled = true
		if global_position.distance_to(
			player.global_position
		) < 5:
			queue_free()
	else:
		br.cast_to = vel.normalized()*8
		br.force_raycast_update()
		if br.is_colliding():
			vel = vel.bounce(br.get_collision_normal())*.5
		vel.y += Globals.GRAVITY*delta
		vel.x = lerp(vel.x, 0, friction*delta)
	
	vel.y = move_and_slide_with_snap(
		vel,
		Vector2.ZERO,
		Vector2.UP,
		false,
		4,
		deg2rad(89)
	).y

