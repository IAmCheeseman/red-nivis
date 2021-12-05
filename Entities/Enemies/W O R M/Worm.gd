extends KinematicBody2D

onready var body = $Body
onready var head = $Head
onready var tail = $Tail

onready var playerDetection = $Collision/PlayerDetection

export var turnStrength := 800.0
export var speed := 16000.0

var vel = Vector2.ZERO

var player: Node2D


func _physics_process(delta: float) -> void:
	head.rotation = vel.angle()
	if body.points.size() > 2:
		tail.position = body.points[0]
		tail.rotation = vel.angle()
	
	if !player:
		player = playerDetection.get_player()
	else:
		var targetDir := global_position.direction_to(player.global_position)
		vel = vel.move_toward(targetDir*speed, turnStrength*delta)
	move_and_slide(vel*delta)
