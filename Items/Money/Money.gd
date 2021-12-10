extends KinematicBody2D

onready var sprite = $Sprite
onready var timer = $Timer
onready var playerDetection = $PlayerDetection

export var value:int = 5
export var friction:int = 200

var coinSprite:StreamTexture = preload("res://Items/Money/Coin.png")
var playerData = preload("res://Entities/Player/Player.tres")
var vel:Vector2 = Vector2.ZERO
var player:Node2D
var speed = 1600*12


func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	
	var minCoinSpriteVal = 10
	if value < minCoinSpriteVal:
		sprite.texture = coinSprite
	
	vel = Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))*(speed*20)


func _process(delta):
	if timer.is_stopped():
		if playerDetection.get_player():
			playerData.money += value
			queue_free()
		speed *= 150*delta
		speed = clamp(speed, 0, speed*(150*100))
		friction += 250*delta
		var targetVel = position.direction_to(player.position)*speed*delta
		vel = targetVel*friction*delta#vel.move_toward(targetVel, friction*delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
	vel = move_and_slide(vel*delta)

