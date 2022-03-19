extends KinematicBody2D


onready var playerDetection = $Collisions/PlayerDetection

var vel: Vector2
var player: Node2D

export var speed: int


func _process(delta: float) -> void:
	if !player: player = playerDetection.get_player()
	vel.y = move_and_slide(vel).y
